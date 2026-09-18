import { PurchaseOrder, IPurchaseOrder, PurchaseOrderItem, IPurchaseOrderItem, PurchaseOrderStatus, Product, InventoryBalance, InventoryTransaction, Warehouse, Location, Notification, AuditLog } from '../../models';
import { NotFoundError, ConflictError, AuthorizationError } from '../../common/errors';
import { buildQueryOptions, PaginatedResponse } from '../../common/pagination';
import { hasPermission, PERMISSIONS } from '../../common/auth';
import mongoose from 'mongoose';

export interface CreatePurchaseOrderInput {
  supplierId: string;
  warehouseId: string;
  orderNumber: string;
  expectedDate?: string;
  notes?: string;
  items: Array<{
    productId: string;
    orderedQuantity: number;
    unitCost: number;
  }>;
}

export interface UpdatePurchaseOrderInput {
  supplierId?: string;
  warehouseId?: string;
  orderNumber?: string;
  expectedDate?: string;
  notes?: string;
}

export class PurchaseOrdersService {
  async getPurchaseOrders(
    tenantId: string,
    params: { page: number; pageSize: number; search?: string; sortBy?: string; sortOrder?: 'asc' | 'desc'; status?: string }
  ): Promise<PaginatedResponse<any>> {
    const query: any = { tenantId: new mongoose.Types.ObjectId(tenantId) };
    
    if (params.search) {
      query.$or = [
        { orderNumber: { $regex: params.search, $options: 'i' } },
      ];
    }

    if (params.status) {
      query.status = params.status;
    }

    const options = buildQueryOptions(params);
    const [orders, total] = await Promise.all([
      PurchaseOrder.find(query)
        .populate('supplierId', 'name')
        .populate('warehouseId', 'name code')
        .populate('createdBy', 'firstName lastName')
        .populate('approvedBy', 'firstName lastName')
        .sort(options.sort)
        .skip(options.skip)
        .limit(options.limit),
      PurchaseOrder.countDocuments(query),
    ]);

    return {
      data: orders,
      meta: {
        page: params.page,
        pageSize: params.pageSize,
        total,
        totalPages: Math.ceil(total / params.pageSize),
      },
    };
  }

  async getPurchaseOrderById(tenantId: string, orderId: string): Promise<any> {
    const order = await PurchaseOrder.findOne({
      _id: new mongoose.Types.ObjectId(orderId),
      tenantId: new mongoose.Types.ObjectId(tenantId),
    })
      .populate('supplierId', 'name contactName email phone')
      .populate('warehouseId', 'name code')
      .populate('createdBy', 'firstName lastName')
      .populate('approvedBy', 'firstName lastName');

    if (!order) {
      throw new NotFoundError('Purchase Order');
    }

    const items = await PurchaseOrderItem.find({ purchaseOrderId: order._id })
      .populate('productId', 'sku name barcode unit');

    return { ...order.toObject(), items };
  }

  async createPurchaseOrder(tenantId: string, userId: string, input: CreatePurchaseOrderInput): Promise<any> {
    const existing = await PurchaseOrder.findOne({
      tenantId: new mongoose.Types.ObjectId(tenantId),
      orderNumber: input.orderNumber,
    });

    if (existing) {
      throw new ConflictError('Order number already exists');
    }

    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      const order = await PurchaseOrder.create([{
        tenantId: new mongoose.Types.ObjectId(tenantId),
        supplierId: new mongoose.Types.ObjectId(input.supplierId),
        warehouseId: new mongoose.Types.ObjectId(input.warehouseId),
        orderNumber: input.orderNumber,
        status: 'draft',
        expectedDate: input.expectedDate ? new Date(input.expectedDate) : undefined,
        notes: input.notes,
        createdBy: new mongoose.Types.ObjectId(userId),
      }], { session });

      const items = await PurchaseOrderItem.create(
        input.items.map(item => ({
          purchaseOrderId: order[0]._id,
          productId: new mongoose.Types.ObjectId(item.productId),
          orderedQuantity: item.orderedQuantity,
          receivedQuantity: 0,
          unitCost: item.unitCost,
        })),
        { session }
      );

      await session.commitTransaction();

      return { ...order[0].toObject(), items };
    } catch (error) {
      await session.abortTransaction();
      throw error;
    } finally {
      await session.endSession();
    }
  }

  async updatePurchaseOrder(
    tenantId: string,
    orderId: string,
    input: UpdatePurchaseOrderInput,
    userRole: string
  ): Promise<any> {
    if (!hasPermission(userRole, PERMISSIONS.PURCHASE_ORDERS_MANAGE)) {
      throw new AuthorizationError('Insufficient permissions to update purchase orders');
    }

    const order = await PurchaseOrder.findOne({
      _id: new mongoose.Types.ObjectId(orderId),
      tenantId: new mongoose.Types.ObjectId(tenantId),
    });

    if (!order) {
      throw new NotFoundError('Purchase Order');
    }

    if (order.status !== 'draft') {
      throw new ConflictError('Can only update draft purchase orders');
    }

    if (input.orderNumber && input.orderNumber !== order.orderNumber) {
      const existing = await PurchaseOrder.findOne({
        tenantId: new mongoose.Types.ObjectId(tenantId),
        orderNumber: input.orderNumber,
        _id: { $ne: order._id },
      });

      if (existing) {
        throw new ConflictError('Order number already exists');
      }
    }

    const updated = await PurchaseOrder.findByIdAndUpdate(
      orderId,
      { $set: input },
      { new: true, runValidators: true }
    );

    return updated;
  }

  async submitPurchaseOrder(tenantId: string, orderId: string): Promise<any> {
    const order = await PurchaseOrder.findOne({
      _id: new mongoose.Types.ObjectId(orderId),
      tenantId: new mongoose.Types.ObjectId(tenantId),
    });

    if (!order) {
      throw new NotFoundError('Purchase Order');
    }

    if (order.status !== 'draft') {
      throw new ConflictError('Only draft orders can be submitted');
    }

    order.status = 'submitted';
    await order.save();

    return order;
  }

  async approvePurchaseOrder(tenantId: string, orderId: string, userId: string): Promise<any> {
    const order = await PurchaseOrder.findOne({
      _id: new mongoose.Types.ObjectId(orderId),
      tenantId: new mongoose.Types.ObjectId(tenantId),
    });

    if (!order) {
      throw new NotFoundError('Purchase Order');
    }

    if (order.status !== 'submitted') {
      throw new ConflictError('Only submitted orders can be approved');
    }

    order.status = 'approved';
    order.approvedBy = new mongoose.Types.ObjectId(userId);
    await order.save();

    return order;
  }

  async cancelPurchaseOrder(tenantId: string, orderId: string): Promise<any> {
    const order = await PurchaseOrder.findOne({
      _id: new mongoose.Types.ObjectId(orderId),
      tenantId: new mongoose.Types.ObjectId(tenantId),
    });

    if (!order) {
      throw new NotFoundError('Purchase Order');
    }

    const allowedCancelStatuses: PurchaseOrderStatus[] = ['draft', 'submitted', 'approved'];
    if (!allowedCancelStatuses.includes(order.status)) {
      throw new ConflictError(`Cannot cancel order in ${order.status} status`);
    }

    order.status = 'cancelled';
    await order.save();

    return order;
  }

  async receivePurchaseOrder(
    tenantId: string,
    orderId: string,
    userId: string,
    items: Array<{ productId: string; quantity: number; unitCost: number }>,
    locationId: string,
    note?: string
  ): Promise<any> {
    const order = await PurchaseOrder.findOne({
      _id: new mongoose.Types.ObjectId(orderId),
      tenantId: new mongoose.Types.ObjectId(tenantId),
    });

    if (!order) {
      throw new NotFoundError('Purchase Order');
    }

    const allowedReceiveStatuses: PurchaseOrderStatus[] = ['approved', 'partial'];
    if (!allowedReceiveStatuses.includes(order.status)) {
      throw new ConflictError(`Cannot receive order in ${order.status} status`);
    }

    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      for (const item of items) {
        const poItem = await PurchaseOrderItem.findOne({
          purchaseOrderId: order._id,
          productId: new mongoose.Types.ObjectId(item.productId),
        }).session(session);

        if (!poItem) {
          throw new NotFoundError(`Purchase order item for product ${item.productId}`);
        }

        const remainingQty = poItem.orderedQuantity - poItem.receivedQuantity;
        if (item.quantity > remainingQty) {
          throw new ConflictError(`Cannot receive more than ordered. Remaining: ${remainingQty}`);
        }

        await InventoryBalance.findOneAndUpdate(
          { productId: item.productId, locationId },
          { $inc: { quantity: item.quantity }, $set: { updatedAt: new Date() } },
          { upsert: true, new: true, session }
        );

        await InventoryTransaction.create([{
          tenantId: new mongoose.Types.ObjectId(tenantId),
          productId: new mongoose.Types.ObjectId(item.productId),
          toLocationId: new mongoose.Types.ObjectId(locationId),
          quantity: item.quantity,
          type: 'receive',
          referenceType: 'purchase_order',
          referenceId: order._id,
          reason: note || `Received from PO ${order.orderNumber}`,
          performedBy: new mongoose.Types.ObjectId(userId),
        }], { session });

        poItem.receivedQuantity += item.quantity;
        poItem.unitCost = item.unitCost;
        await poItem.save({ session });
      }

      const allItems = await PurchaseOrderItem.find({ purchaseOrderId: order._id }).session(session);
      const allReceived = allItems.every(item => item.receivedQuantity >= item.orderedQuantity);
      const anyReceived = allItems.some(item => item.receivedQuantity > 0);

      if (allReceived) {
        order.status = 'received';
      } else if (anyReceived) {
        order.status = 'partial';
      }

      await order.save({ session });

      await AuditLog.create([{
        tenantId: new mongoose.Types.ObjectId(tenantId),
        userId: new mongoose.Types.ObjectId(userId),
        action: 'purchase_order_receive',
        entityType: 'purchase_order',
        entityId: order._id,
        afterData: { status: order.status, receivedItems: items },
      }], { session });

      await session.commitTransaction();

      return order;
    } catch (error) {
      await session.abortTransaction();
      throw error;
    } finally {
      await session.endSession();
    }
  }
}

export const purchaseOrdersService = new PurchaseOrdersService();