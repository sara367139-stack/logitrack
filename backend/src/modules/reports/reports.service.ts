import { InventoryBalance, InventoryTransaction, Product, PurchaseOrder, PurchaseOrderItem } from '../../models';
import mongoose from 'mongoose';

export interface DateRange {
  from?: string;
  to?: string;
}

export class ReportsService {
  async getInventoryValue(tenantId: string, params: DateRange): Promise<any> {
    const tenantObjId = new mongoose.Types.ObjectId(tenantId);
    const match: any = { 'product.tenantId': tenantObjId, 'product.isActive': true };
    
    if (params.from || params.to) {
      match.createdAt = {};
      if (params.from) match.createdAt.$gte = new Date(params.from);
      if (params.to) match.createdAt.$lte = new Date(params.to);
    }

    const result = await InventoryBalance.aggregate([
      {
        $lookup: {
          from: 'products',
          localField: 'productId',
          foreignField: '_id',
          as: 'product',
        },
      },
      { $unwind: '$product' },
      { $match: match },
      {
        $group: {
          _id: null,
          totalValue: { $sum: { $multiply: ['$quantity', '$product.costPrice'] } },
          totalItems: { $sum: '$quantity' },
          totalProducts: { $addToSet: '$productId' },
        },
      },
      {
        $project: {
          totalValue: { $round: ['$totalValue', 2] },
          totalItems: 1,
          totalProducts: { $size: '$totalProducts' },
        },
      },
    ]);

    return result[0] || { totalValue: 0, totalItems: 0, totalProducts: 0 };
  }

  async getStockMovement(tenantId: string, params: DateRange): Promise<any[]> {
    const tenantObjId = new mongoose.Types.ObjectId(tenantId);
    const match: any = { tenantId: tenantObjId };
    
    if (params.from || params.to) {
      match.createdAt = {};
      if (params.from) match.createdAt.$gte = new Date(params.from);
      if (params.to) match.createdAt.$lte = new Date(params.to);
    }

    const movements = await InventoryTransaction.aggregate([
      { $match: match },
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
          localField: 'fromLocationId',
          foreignField: '_id',
          as: 'fromLocation',
        },
      },
      {
        $lookup: {
          from: 'locations',
          localField: 'toLocationId',
          foreignField: '_id',
          as: 'toLocation',
        },
      },
      {
        $project: {
          type: 1,
          quantity: 1,
          referenceType: 1,
          referenceId: 1,
          reason: 1,
          performedBy: 1,
          createdAt: 1,
          product: { sku: '$product.sku', name: '$product.name' },
          fromLocation: { name: { $arrayElemAt: ['$fromLocation.name', 0] } },
          toLocation: { name: { $arrayElemAt: ['$toLocation.name', 0] } },
        },
      },
      { $sort: { createdAt: -1 } },
    ]);

    return movements;
  }

  async getReceivingReport(tenantId: string, params: DateRange): Promise<any[]> {
    const tenantObjId = new mongoose.Types.ObjectId(tenantId);
    const match: any = { tenantId: tenantObjId, type: 'receive' };
    
    if (params.from || params.to) {
      match.createdAt = {};
      if (params.from) match.createdAt.$gte = new Date(params.from);
      if (params.to) match.createdAt.$lte = new Date(params.to);
    }

    const result = await InventoryTransaction.aggregate([
      { $match: match },
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
          localField: 'toLocationId',
          foreignField: '_id',
          as: 'location',
        },
      },
      { $unwind: '$location' },
      {
        $lookup: {
          from: 'users',
          localField: 'performedBy',
          foreignField: '_id',
          as: 'user',
        },
      },
      { $unwind: '$user' },
      {
        $group: {
          _id: '$referenceId',
          referenceType: { $first: '$referenceType' },
          date: { $first: '$createdAt' },
          performedBy: { $first: '$user.firstName' },
          items: {
            $push: {
              product: { sku: '$product.sku', name: '$product.name' },
              quantity: '$quantity',
              location: '$location.name',
            },
          },
          totalQuantity: { $sum: '$quantity' },
        },
      },
      { $sort: { date: -1 } },
    ]);

    return result;
  }

  async getDispatchReport(tenantId: string, params: DateRange): Promise<any[]> {
    const tenantObjId = new mongoose.Types.ObjectId(tenantId);
    const match: any = { tenantId: tenantObjId, type: 'dispatch' };
    
    if (params.from || params.to) {
      match.createdAt = {};
      if (params.from) match.createdAt.$gte = new Date(params.from);
      if (params.to) match.createdAt.$lte = new Date(params.to);
    }

    const result = await InventoryTransaction.aggregate([
      { $match: match },
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
          localField: 'fromLocationId',
          foreignField: '_id',
          as: 'location',
        },
      },
      { $unwind: '$location' },
      {
        $lookup: {
          from: 'users',
          localField: 'performedBy',
          foreignField: '_id',
          as: 'user',
        },
      },
      { $unwind: '$user' },
      {
        $group: {
          _id: '$referenceId',
          reference: { $first: '$referenceId' },
          referenceType: { $first: '$referenceType' },
          date: { $first: '$createdAt' },
          performedBy: { $first: '$user.firstName' },
          items: {
            $push: {
              product: { sku: '$product.sku', name: '$product.name' },
              quantity: '$quantity',
              location: '$location.name',
            },
          },
          totalQuantity: { $sum: '$quantity' },
        },
      },
      { $sort: { date: -1 } },
    ]);

    return result;
  }

  async getSlowMoving(tenantId: string, days: number = 90): Promise<any[]> {
    const tenantObjId = new mongoose.Types.ObjectId(tenantId);
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);

    const result = await InventoryBalance.aggregate([
      {
        $lookup: {
          from: 'products',
          localField: 'productId',
          foreignField: '_id',
          as: 'product',
        },
      },
      { $unwind: '$product' },
      { $match: { 'product.tenantId': tenantObjId, 'product.isActive': true } },
      {
        $lookup: {
          from: 'inventorytransactions',
          let: { productId: '$productId' },
          pipeline: [
            { $match: { $expr: { $and: [{ $eq: ['$productId', '$$productId'] }, { $gte: ['$createdAt', cutoffDate] }, { $in: ['$type', ['dispatch', 'move']] }] } } },
            { $group: { _id: null, totalDispatched: { $sum: '$quantity' } } },
          ],
          as: 'recentActivity',
        },
      },
      {
        $project: {
          productId: 1,
          sku: '$product.sku',
          name: '$product.name',
          currentStock: '$quantity',
          totalDispatched: { $ifNull: [{ $arrayElemAt: ['$recentActivity.totalDispatched', 0] }, 0] },
          daysSinceLastMovement: {
            $cond: {
              if: { $gt: [{ $size: '$recentActivity' }, 0] },
              then: { $divide: [{ $subtract: [new Date(), cutoffDate] }, 1000 * 60 * 60 * 24] },
              else: days,
            },
          },
        },
      },
      { $match: { totalDispatched: { $lt: 10 }, daysSinceLastMovement: { $gt: days / 2 } } },
      { $sort: { daysSinceLastMovement: -1 } },
    ]);

    return result;
  }

  async exportInventoryCSV(tenantId: string): Promise<string> {
    const tenantObjId = new mongoose.Types.ObjectId(tenantId);

    const balances = await InventoryBalance.aggregate([
      {
        $lookup: {
          from: 'products',
          localField: 'productId',
          foreignField: '_id',
          as: 'product',
        },
      },
      { $unwind: '$product' },
      { $match: { 'product.tenantId': tenantObjId, 'product.isActive': true } },
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
          sku: '$product.sku',
          barcode: '$product.barcode',
          name: '$product.name',
          category: '$product.category',
          unit: '$product.unit',
          costPrice: '$product.costPrice',
          sellingPrice: '$product.sellingPrice',
          warehouse: '$warehouse.name',
          location: '$location.name',
          locationCode: '$location.code',
          quantity: 1,
          reservedQuantity: 1,
          availableQuantity: { $subtract: ['$quantity', '$reservedQuantity'] },
          stockValue: { $multiply: ['$quantity', '$product.costPrice'] },
        },
      },
      { $sort: { warehouse: 1, location: 1, sku: 1 } },
    ]);

    const headers = [
      'SKU', 'Barcode', 'Name', 'Category', 'Unit',
      'Cost Price', 'Selling Price',
      'Warehouse', 'Location', 'Location Code',
      'Quantity', 'Reserved', 'Available', 'Stock Value'
    ];

    const rows = balances.map(b => [
      b.sku,
      b.barcode || '',
      b.name,
      b.category || '',
      b.unit,
      b.costPrice.toFixed(2),
      b.sellingPrice.toFixed(2),
      b.warehouse,
      b.location,
      b.locationCode,
      b.quantity,
      b.reservedQuantity,
      b.availableQuantity,
      b.stockValue.toFixed(2),
    ]);

    return [headers.join(','), ...rows.map(r => r.map(v => `"${v}"`).join(','))].join('\n');
  }
}

export const reportsService = new ReportsService();