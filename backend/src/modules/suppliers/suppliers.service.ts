import { Supplier, ISupplier, PurchaseOrder } from '../../models';
import { NotFoundError, ConflictError } from '../../common/errors';
import { buildQueryOptions, PaginatedResponse } from '../../common/pagination';
import mongoose from 'mongoose';

export interface CreateSupplierInput {
  name: string;
  contactName?: string;
  email?: string;
  phone?: string;
  address?: string;
}

export interface UpdateSupplierInput {
  name?: string;
  contactName?: string;
  email?: string;
  phone?: string;
  address?: string;
  isActive?: boolean;
}

export class SuppliersService {
  async getSuppliers(
    tenantId: string,
    params: { page: number; pageSize: number; search?: string; sortBy?: string; sortOrder?: 'asc' | 'desc' }
  ): Promise<PaginatedResponse<any>> {
    const query: any = { tenantId: new mongoose.Types.ObjectId(tenantId), isActive: true };
    
    if (params.search) {
      query.$or = [
        { name: { $regex: params.search, $options: 'i' } },
        { contactName: { $regex: params.search, $options: 'i' } },
        { email: { $regex: params.search, $options: 'i' } },
      ];
    }

    const options = buildQueryOptions(params);
    const [suppliers, total] = await Promise.all([
      Supplier.find(query)
        .sort(options.sort)
        .skip(options.skip)
        .limit(options.limit),
      Supplier.countDocuments(query),
    ]);

    return {
      data: suppliers,
      meta: {
        page: params.page,
        pageSize: params.pageSize,
        total,
        totalPages: Math.ceil(total / params.pageSize),
      },
    };
  }

  async getSupplierById(tenantId: string, supplierId: string): Promise<any> {
    const supplier = await Supplier.findOne({
      _id: new mongoose.Types.ObjectId(supplierId),
      tenantId: new mongoose.Types.ObjectId(tenantId),
    });

    if (!supplier) {
      throw new NotFoundError('Supplier');
    }
    return supplier;
  }

  async createSupplier(tenantId: string, input: CreateSupplierInput): Promise<any> {
    const supplier = await Supplier.create({
      tenantId: new mongoose.Types.ObjectId(tenantId),
      ...input,
    });

    return supplier;
  }

  async updateSupplier(
    tenantId: string,
    supplierId: string,
    input: UpdateSupplierInput
  ): Promise<any> {
    const supplier = await Supplier.findOneAndUpdate(
      {
        _id: new mongoose.Types.ObjectId(supplierId),
        tenantId: new mongoose.Types.ObjectId(tenantId),
      },
      { $set: input },
      { new: true, runValidators: true }
    );

    if (!supplier) {
      throw new NotFoundError('Supplier');
    }
    return supplier;
  }

  async deleteSupplier(tenantId: string, supplierId: string): Promise<void> {
    const supplier = await Supplier.findOneAndUpdate(
      {
        _id: new mongoose.Types.ObjectId(supplierId),
        tenantId: new mongoose.Types.ObjectId(tenantId),
      },
      { $set: { isActive: false } },
      { new: true }
    );

    if (!supplier) {
      throw new NotFoundError('Supplier');
    }
  }

  async getSupplierPurchaseOrders(
    tenantId: string,
    supplierId: string,
    params: { page: number; pageSize: number; search?: string; sortBy?: string; sortOrder?: 'asc' | 'desc' }
  ): Promise<PaginatedResponse<any>> {
    await this.getSupplierById(tenantId, supplierId);

    const query: any = { supplierId: new mongoose.Types.ObjectId(supplierId) };
    
    if (params.search) {
      query.$or = [
        { orderNumber: { $regex: params.search, $options: 'i' } },
      ];
    }

    const options = buildQueryOptions(params);
    const [orders, total] = await Promise.all([
      PurchaseOrder.find(query)
        .populate('warehouseId', 'name code')
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
}

export const suppliersService = new SuppliersService();