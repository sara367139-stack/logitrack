import { InventoryBalance, InventoryTransaction, Product, Location, Notification, AuditLog } from '../../models';
import { NotFoundError, ConflictError } from '../../common/errors';
import { buildQueryOptions, PaginatedResponse } from '../../common/pagination';
import mongoose from 'mongoose';

export interface MoveInventoryInput {
  fromLocationId: string;
  toLocationId: string;
  items: Array<{ productId: string; quantity: number }>;
  note?: string;
}

export interface DispatchInventoryInput {
  locationId: string;
  items: Array<{ productId: string; quantity: number }>;
  reference?: string;
}

export interface AdjustInventoryInput {
  productId: string;
  locationId: string;
  newQuantity: number;
  reason: string;
}

export class InventoryService {
  async getInventory(
    tenantId: string,
    params: { page: number; pageSize: number; search?: string; sortBy?: string; sortOrder?: 'asc' | 'desc'; locationId?: string; productId?: string }
  ): Promise<PaginatedResponse<any>> {
    const query: any = {};
    
    if (params.locationId) {
      query.locationId = new mongoose.Types.ObjectId(params.locationId);
    }
    
    if (params.productId) {
      query.productId = new mongoose.Types.ObjectId(params.productId);
    }

    const options = buildQueryOptions(params);
    
    const pipeline: mongoose.PipelineStage[] = [
      { $match: query },
      {
        $lookup: {
          from: 'products',
          localField: 'productId',
          foreignField: '_id',
          as: 'product',
        },
      },
      { $unwind: '$product' },
      {
        $lookup: {
          from: 'locations',
          localField: 'locationId',
          foreignField: '_id',
          as: 'location',
        },
      },
      { $unwind: '$location' },
      {
        $lookup: {
          from: 'warehouses',
          localField: 'location.warehouseId',
          foreignField: '_id',
          as: 'warehouse',
        },
      },
      { $unwind: '$warehouse' },
      {
        $match: { 'product.tenantId': new mongoose.Types.ObjectId(tenantId) },
      },
      {
        $project: {
          productId: 1,
          locationId: 1,
          quantity: 1,
          reservedQuantity: 1,
          availableQuantity: { $subtract: ['$quantity', '$reservedQuantity'] },
          product: {
            sku: '$product.sku',
            name: '$product.name',
            barcode: '$product.barcode',
            unit: '$product.unit',
          },
          location: {
            name: '$location.name',
            code: '$location.code',
            type: '$location.type',
          },
          warehouse: {
            name: '$warehouse.name',
            code: '$warehouse.code',
          },
        },
      },
      { $sort: options.sort || { createdAt: -1 } },
      { $skip: options.skip },
      { $limit: options.limit },
    ];

    const countPipeline: mongoose.PipelineStage[] = [
      { $match: query },
      {
        $lookup: {
          from: 'products',
          localField: 'productId',
          foreignField: '_id',
          as: 'product',
        },
      },
      { $unwind: '$product' },
      { $match: { 'product.tenantId': new mongoose.Types.ObjectId(tenantId) } },
      { $count: 'total' },
    ];

    const [data, countResult] = await Promise.all([
      InventoryBalance.aggregate(pipeline),
      InventoryBalance.aggregate(countPipeline),
    ]);

    const total = countResult[0]?.total || 0;

    return {
      data,
      meta: {
        page: params.page,
        pageSize: params.pageSize,
        total,
        totalPages: Math.ceil(total / params.pageSize),
      },
    };
  }

  async getInventoryByProduct(tenantId: string, productId: string): Promise<any> {
    const balances = await InventoryBalance.aggregate([
      { $match: { productId: new mongoose.Types.ObjectId(productId) } },
      {
        $lookup: {
          from: 'locations',
          localField: 'locationId',
          foreignField: '_id',
          as: 'location',
        },
      },
      { $unwind: '$location' },
      {
        $lookup: {
          from: 'warehouses',
          localField: 'location.warehouseId',
          foreignField: '_id',
          as: 'warehouse',
        },
      },
      { $unwind: '$warehouse' },
      {
        $project: {
          locationId: '$location._id',
          locationName: '$location.name',
          locationCode: '$location.code',
          locationType: '$location.type',
          warehouseId: '$warehouse._id',
          warehouseName: '$warehouse.name',
          warehouseCode: '$warehouse.code',
          quantity: 1,
          reservedQuantity: 1,
          availableQuantity: { $subtract: ['$quantity', '$reservedQuantity'] },
        },
      },
    ]);

    const totalQuantity = balances.reduce((sum, b) => sum + b.quantity, 0);
    const totalReserved = balances.reduce((sum, b) => sum + b.reservedQuantity, 0);

    return {
      productId,
      totalQuantity,
      totalReserved,
      totalAvailable: totalQuantity - totalReserved,
      locations: balances,
    };
  }

  async getInventoryByLocation(tenantId: string, locationId: string, params: any): Promise<PaginatedResponse<any>> {
    return this.getInventory(tenantId, { ...params, locationId });
  }

  async getLowStock(tenantId: string): Promise<any[]> {
    const products = await Product.find({
      tenantId: new mongoose.Types.ObjectId(tenantId),
      isActive: true,
      reorderLevel: { $gt: 0 },
    }).select('sku name barcode reorderLevel');

    const productIds = products.map(p => p._id);

    const balances = await InventoryBalance.aggregate([
      { $match: { productId: { $in: productIds } } },
      { $group: { _id: '$productId', totalQuantity: { $sum: '$quantity' } } },
    ]);

    const balanceMap = new Map(balances.map(b => [b._id.toString(), b.totalQuantity]));

    const lowStock = products
      .filter(p => (balanceMap.get(p._id.toString()) || 0) <= p.reorderLevel)
      .map(p => ({
        ...p.toObject(),
        currentQuantity: balanceMap.get(p._id.toString()) || 0,
      }));

    return lowStock;
  }

  async moveInventory(
    tenantId: string,
    userId: string,
    input: MoveInventoryInput
  ): Promise<any> {
    if (input.fromLocationId === input.toLocationId) {
      throw new ConflictError('Source and destination locations cannot be the same');
    }

    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      for (const item of input.items) {
        const sourceBalance = await InventoryBalance.findOne({
          productId: item.productId,
          locationId: input.fromLocationId,
        }).session(session);

        if (!sourceBalance) {
          throw new NotFoundError(`No stock found for product ${item.productId} at source location`);
        }

        const available = sourceBalance.quantity - sourceBalance.reservedQuantity;
        if (item.quantity > available) {
          throw new ConflictError(`Insufficient stock for product ${item.productId}. Available: ${available}`);
        }

        sourceBalance.quantity -= item.quantity;
        sourceBalance.updatedAt = new Date();
        await sourceBalance.save({ session });

        await InventoryBalance.findOneAndUpdate(
          { productId: item.productId, locationId: input.toLocationId },
          { $inc: { quantity: item.quantity }, $set: { updatedAt: new Date() } },
          { upsert: true, new: true, session }
        );

        await InventoryTransaction.create([{
          tenantId: new mongoose.Types.ObjectId(tenantId),
          productId: new mongoose.Types.ObjectId(item.productId),
          fromLocationId: new mongoose.Types.ObjectId(input.fromLocationId),
          toLocationId: new mongoose.Types.ObjectId(input.toLocationId),
          quantity: item.quantity,
          type: 'move',
          referenceType: 'manual',
          reason: input.note || 'Stock movement',
          performedBy: new mongoose.Types.ObjectId(userId),
        }], { session });
      }

      await AuditLog.create([{
        tenantId: new mongoose.Types.ObjectId(tenantId),
        userId: new mongoose.Types.ObjectId(userId),
        action: 'inventory_move',
        entityType: 'inventory',
        afterData: { fromLocationId: input.fromLocationId, toLocationId: input.toLocationId, items: input.items },
      }], { session });

      await session.commitTransaction();

      return { message: 'Stock moved successfully' };
    } catch (error) {
      await session.abortTransaction();
      throw error;
    } finally {
      await session.endSession();
    }
  }

  async dispatchInventory(
    tenantId: string,
    userId: string,
    input: DispatchInventoryInput
  ): Promise<any> {
    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      for (const item of input.items) {
        const balance = await InventoryBalance.findOne({
          productId: item.productId,
          locationId: input.locationId,
        }).session(session);

        if (!balance) {
          throw new NotFoundError(`No stock found for product ${item.productId} at location`);
        }

        const available = balance.quantity - balance.reservedQuantity;
        if (item.quantity > available) {
          throw new ConflictError(`Insufficient stock for product ${item.productId}. Available: ${available}`);
        }

        balance.quantity -= item.quantity;
        balance.updatedAt = new Date();
        await balance.save({ session });

        await InventoryTransaction.create([{
          tenantId: new mongoose.Types.ObjectId(tenantId),
          productId: new mongoose.Types.ObjectId(item.productId),
          fromLocationId: new mongoose.Types.ObjectId(input.locationId),
          quantity: item.quantity,
          type: 'dispatch',
          referenceType: 'shipment',
          referenceId: input.reference ? new mongoose.Types.ObjectId(input.reference) : undefined,
          reason: `Dispatched ${input.reference ? `for ${input.reference}` : ''}`,
          performedBy: new mongoose.Types.ObjectId(userId),
        }], { session });

        const product = await Product.findById(item.productId).session(session);
        if (product && balance.quantity <= product.reorderLevel) {
          await Notification.create([{
            tenantId: new mongoose.Types.ObjectId(tenantId),
            type: 'low_stock',
            title: 'Low Stock Alert',
            message: `${product.name} (${product.sku}) has reached reorder level`,
            data: { productId: product._id, locationId: input.locationId, currentQuantity: balance.quantity, reorderLevel: product.reorderLevel },
          }], { session });
        }
      }

      await AuditLog.create([{
        tenantId: new mongoose.Types.ObjectId(tenantId),
        userId: new mongoose.Types.ObjectId(userId),
        action: 'inventory_dispatch',
        entityType: 'inventory',
        afterData: { locationId: input.locationId, items: input.items, reference: input.reference },
      }], { session });

      await session.commitTransaction();

      return { message: 'Stock dispatched successfully' };
    } catch (error) {
      await session.abortTransaction();
      throw error;
    } finally {
      await session.endSession();
    }
  }

  async adjustInventory(
    tenantId: string,
    userId: string,
    input: AdjustInventoryInput
  ): Promise<any> {
    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      const balance = await InventoryBalance.findOne({
        productId: input.productId,
        locationId: input.locationId,
      }).session(session);

      const oldQuantity = balance?.quantity || 0;
      const newQuantity = input.newQuantity;

      if (newQuantity < 0) {
        throw new ConflictError('Quantity cannot be negative');
      }

      if (balance) {
        balance.quantity = newQuantity;
        balance.updatedAt = new Date();
        await balance.save({ session });
      } else if (newQuantity > 0) {
        await InventoryBalance.create([{
          productId: new mongoose.Types.ObjectId(input.productId),
          locationId: new mongoose.Types.ObjectId(input.locationId),
          quantity: newQuantity,
          reservedQuantity: 0,
          updatedAt: new Date(),
        }], { session });
      }

      await InventoryTransaction.create([{
        tenantId: new mongoose.Types.ObjectId(tenantId),
        productId: new mongoose.Types.ObjectId(input.productId),
        toLocationId: new mongoose.Types.ObjectId(input.locationId),
        quantity: Math.abs(newQuantity - oldQuantity),
        type: 'adjustment',
        referenceType: 'manual',
        reason: input.reason,
        performedBy: new mongoose.Types.ObjectId(userId),
      }], { session });

      await AuditLog.create([{
        tenantId: new mongoose.Types.ObjectId(tenantId),
        userId: new mongoose.Types.ObjectId(userId),
        action: 'inventory_adjust',
        entityType: 'inventory_balance',
        entityId: balance?._id,
        beforeData: { quantity: oldQuantity },
        afterData: { quantity: newQuantity, reason: input.reason },
      }], { session });

      await session.commitTransaction();

      return { message: 'Inventory adjusted successfully' };
    } catch (error) {
      await session.abortTransaction();
      throw error;
    } finally {
      await session.endSession();
    }
  }

  async getTransactionHistory(
    tenantId: string,
    params: { page: number; pageSize: number; productId?: string; locationId?: string; type?: string; fromDate?: string; toDate?: string }
  ): Promise<PaginatedResponse<any>> {
    const query: any = { tenantId: new mongoose.Types.ObjectId(tenantId) };
    
    if (params.productId) {
      query.productId = new mongoose.Types.ObjectId(params.productId);
    }
    if (params.locationId) {
      query.$or = [
        { fromLocationId: new mongoose.Types.ObjectId(params.locationId) },
        { toLocationId: new mongoose.Types.ObjectId(params.locationId) },
      ];
    }
    if (params.type) {
      query.type = params.type;
    }
    if (params.fromDate || params.toDate) {
      query.createdAt = {};
      if (params.fromDate) query.createdAt.$gte = new Date(params.fromDate);
      if (params.toDate) query.createdAt.$lte = new Date(params.toDate);
    }

    const options = buildQueryOptions(params);
    const [transactions, total] = await Promise.all([
      InventoryTransaction.find(query)
        .populate('productId', 'sku name barcode')
        .populate('fromLocationId', 'name code')
        .populate('toLocationId', 'name code')
        .populate('performedBy', 'firstName lastName')
        .sort(options.sort)
        .skip(options.skip)
        .limit(options.limit),
      InventoryTransaction.countDocuments(query),
    ]);

    return {
      data: transactions,
      meta: {
        page: params.page,
        pageSize: params.pageSize,
        total,
        totalPages: Math.ceil(total / params.pageSize),
      },
    };
  }
}

export const inventoryService = new InventoryService();