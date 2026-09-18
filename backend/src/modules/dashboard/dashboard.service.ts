import { Product, InventoryBalance, InventoryTransaction, PurchaseOrder, Warehouse, Notification } from '../../models';
import mongoose from 'mongoose';

export interface DashboardSummary {
  totalItems: number;
  openOrders: number;
  lowStockItems: number;
  warehouseCount: number;
  stockValue: number;
  receivedToday: number;
  dispatchedToday: number;
}

export class DashboardService {
  async getSummary(tenantId: string): Promise<DashboardSummary> {
    const tenantObjId = new mongoose.Types.ObjectId(tenantId);

    const [
      totalItemsResult,
      openOrdersResult,
      lowStockProducts,
      warehouseCount,
      stockValueResult,
      receivedTodayResult,
      dispatchedTodayResult,
    ] = await Promise.all([
      InventoryBalance.aggregate([
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
        { $group: { _id: null, total: { $sum: '$quantity' } } },
      ]),
      PurchaseOrder.countDocuments({
        tenantId: tenantObjId,
        status: { $in: ['submitted', 'approved', 'partial'] },
      }),
      Product.find({
        tenantId: tenantObjId,
        isActive: true,
        reorderLevel: { $gt: 0 },
      }).select('_id reorderLevel'),
      Warehouse.countDocuments({ tenantId: tenantObjId, isActive: true }),
      InventoryBalance.aggregate([
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
        { $group: { _id: null, total: { $sum: { $multiply: ['$quantity', '$product.costPrice'] } } } },
      ]),
      InventoryTransaction.countDocuments({
        tenantId: tenantObjId,
        type: 'receive',
        createdAt: { $gte: this.startOfToday() },
      }),
      InventoryTransaction.countDocuments({
        tenantId: tenantObjId,
        type: 'dispatch',
        createdAt: { $gte: this.startOfToday() },
      }),
    ]);

    const totalItems = totalItemsResult[0]?.total || 0;
    const stockValue = stockValueResult[0]?.total || 0;

    const productIds = lowStockProducts.map(p => p._id);
    const balances = await InventoryBalance.aggregate([
      { $match: { productId: { $in: productIds } } },
      { $group: { _id: '$productId', totalQuantity: { $sum: '$quantity' } } },
    ]);

    const balanceMap = new Map(balances.map(b => [b._id.toString(), b.totalQuantity]));
    const lowStockItems = lowStockProducts.filter(p => (balanceMap.get(p._id.toString()) || 0) <= p.reorderLevel).length;

    return {
      totalItems,
      openOrders: openOrdersResult,
      lowStockItems,
      warehouseCount,
      stockValue: Math.round(stockValue * 100) / 100,
      receivedToday: receivedTodayResult,
      dispatchedToday: dispatchedTodayResult,
    };
  }

  async getActivity(tenantId: string, limit: number = 20): Promise<any[]> {
    const transactions = await InventoryTransaction.find({ tenantId: new mongoose.Types.ObjectId(tenantId) })
      .populate('productId', 'sku name')
      .populate('fromLocationId', 'name')
      .populate('toLocationId', 'name')
      .populate('performedBy', 'firstName lastName')
      .sort({ createdAt: -1 })
      .limit(limit);

    return transactions.map(t => ({
      id: t._id,
      type: t.type,
      product: t.productId,
      fromLocation: t.fromLocationId,
      toLocation: t.toLocationId,
      quantity: t.quantity,
      performedBy: t.performedBy,
      referenceType: t.referenceType,
      referenceId: t.referenceId,
      createdAt: t.createdAt,
    }));
  }

  async getStockAlerts(tenantId: string): Promise<any[]> {
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

    const alerts = products
      .filter(p => {
        const qty = balanceMap.get(p._id.toString()) || 0;
        return qty <= p.reorderLevel;
      })
      .map(p => ({
        productId: p._id,
        sku: p.sku,
        name: p.name,
        barcode: p.barcode,
        currentQuantity: balanceMap.get(p._id.toString()) || 0,
        reorderLevel: p.reorderLevel,
        reorderQuantity: p.reorderQuantity,
        severity: (balanceMap.get(p._id.toString()) || 0) === 0 ? 'critical' : 'warning',
      }));

    return alerts;
  }

  private startOfToday(): Date {
    const now = new Date();
    now.setHours(0, 0, 0, 0);
    return now;
  }
}

export const dashboardService = new DashboardService();