import { Product, IProduct, InventoryBalance } from '../../models';
import { NotFoundError, ConflictError } from '../../common/errors';
import { buildQueryOptions, PaginatedResponse } from '../../common/pagination';
import mongoose from 'mongoose';

export interface CreateProductInput {
  sku: string;
  barcode?: string;
  name: string;
  description?: string;
  category?: string;
  unit?: string;
  costPrice?: number;
  sellingPrice?: number;
  reorderLevel?: number;
  reorderQuantity?: number;
  imageUrl?: string;
}

export interface UpdateProductInput {
  sku?: string;
  barcode?: string;
  name?: string;
  description?: string;
  category?: string;
  unit?: string;
  costPrice?: number;
  sellingPrice?: number;
  reorderLevel?: number;
  reorderQuantity?: number;
  imageUrl?: string;
  isActive?: boolean;
}

export class ProductsService {
  async getProducts(
    tenantId: string,
    params: { page: number; pageSize: number; search?: string; sortBy?: string; sortOrder?: 'asc' | 'desc' }
  ): Promise<PaginatedResponse<any>> {
    const query: any = { tenantId: new mongoose.Types.ObjectId(tenantId), isActive: true };
    
    if (params.search) {
      query.$or = [
        { name: { $regex: params.search, $options: 'i' } },
        { sku: { $regex: params.search, $options: 'i' } },
        { barcode: { $regex: params.search, $options: 'i' } },
        { category: { $regex: params.search, $options: 'i' } },
      ];
    }

    const options = buildQueryOptions(params);
    const [products, total] = await Promise.all([
      Product.find(query)
        .sort(options.sort)
        .skip(options.skip)
        .limit(options.limit),
      Product.countDocuments(query),
    ]);

    return {
      data: products,
      meta: {
        page: params.page,
        pageSize: params.pageSize,
        total,
        totalPages: Math.ceil(total / params.pageSize),
      },
    };
  }

  async getProductById(tenantId: string, productId: string): Promise<any> {
    const product = await Product.findOne({
      _id: new mongoose.Types.ObjectId(productId),
      tenantId: new mongoose.Types.ObjectId(tenantId),
    });

    if (!product) {
      throw new NotFoundError('Product');
    }
    return product;
  }

  async getProductByBarcode(tenantId: string, barcode: string): Promise<any> {
    const product = await Product.findOne({
      tenantId: new mongoose.Types.ObjectId(tenantId),
      barcode,
      isActive: true,
    });

    if (!product) {
      throw new NotFoundError('Product');
    }

    const balances = await InventoryBalance.aggregate([
      { $match: { productId: product._id } },
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
        $project: {
          locationId: '$location._id',
          locationName: '$location.name',
          quantity: 1,
        },
      },
    ]);

    const totalQuantity = balances.reduce((sum, b) => sum + b.quantity, 0);

    return {
      ...product.toObject(),
      totalQuantity,
      locations: balances,
    };
  }

  async createProduct(tenantId: string, input: CreateProductInput): Promise<any> {
    const existingSku = await Product.findOne({
      tenantId: new mongoose.Types.ObjectId(tenantId),
      sku: input.sku.toUpperCase(),
    });

    if (existingSku) {
      throw new ConflictError('SKU already exists');
    }

    if (input.barcode) {
      const existingBarcode = await Product.findOne({
        tenantId: new mongoose.Types.ObjectId(tenantId),
        barcode: input.barcode,
      });

      if (existingBarcode) {
        throw new ConflictError('Barcode already exists');
      }
    }

    const product = await Product.create({
      tenantId: new mongoose.Types.ObjectId(tenantId),
      ...input,
      sku: input.sku.toUpperCase(),
    });

    return product;
  }

  async updateProduct(
    tenantId: string,
    productId: string,
    input: UpdateProductInput
  ): Promise<any> {
    if (input.sku) {
      const existing = await Product.findOne({
        tenantId: new mongoose.Types.ObjectId(tenantId),
        sku: input.sku.toUpperCase(),
        _id: { $ne: new mongoose.Types.ObjectId(productId) },
      });

      if (existing) {
        throw new ConflictError('SKU already exists');
      }
      input.sku = input.sku.toUpperCase();
    }

    if (input.barcode) {
      const existing = await Product.findOne({
        tenantId: new mongoose.Types.ObjectId(tenantId),
        barcode: input.barcode,
        _id: { $ne: new mongoose.Types.ObjectId(productId) },
      });

      if (existing) {
        throw new ConflictError('Barcode already exists');
      }
    }

    const product = await Product.findOneAndUpdate(
      {
        _id: new mongoose.Types.ObjectId(productId),
        tenantId: new mongoose.Types.ObjectId(tenantId),
      },
      { $set: input },
      { new: true, runValidators: true }
    );

    if (!product) {
      throw new NotFoundError('Product');
    }
    return product;
  }

  async deleteProduct(tenantId: string, productId: string): Promise<void> {
    const product = await Product.findOneAndUpdate(
      {
        _id: new mongoose.Types.ObjectId(productId),
        tenantId: new mongoose.Types.ObjectId(tenantId),
      },
      { $set: { isActive: false } },
      { new: true }
    );

    if (!product) {
      throw new NotFoundError('Product');
    }
  }

  async getProductStock(tenantId: string, productId: string): Promise<any> {
    await this.getProductById(tenantId, productId);

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
        $project: {
          locationId: '$location._id',
          locationName: '$location.name',
          locationCode: '$location.code',
          locationType: '$location.type',
          warehouseId: '$location.warehouseId',
          quantity: 1,
          reservedQuantity: 1,
          availableQuantity: { $subtract: ['$quantity', '$reservedQuantity'] },
        },
      },
      {
        $lookup: {
          from: 'warehouses',
          localField: 'warehouseId',
          foreignField: '_id',
          as: 'warehouse',
        },
      },
      { $unwind: '$warehouse' },
      {
        $project: {
          locationId: 1,
          locationName: 1,
          locationCode: 1,
          locationType: 1,
          warehouseName: '$warehouse.name',
          warehouseCode: '$warehouse.code',
          quantity: 1,
          reservedQuantity: 1,
          availableQuantity: 1,
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

  async getLowStockProducts(tenantId: string): Promise<any[]> {
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
}

export const productsService = new ProductsService();