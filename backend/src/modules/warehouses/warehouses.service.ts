import { Warehouse, IWarehouse, Location, ILocation, LocationType } from '../../models';
import { NotFoundError, ConflictError } from '../../common/errors';
import { buildQueryOptions, PaginatedResponse } from '../../common/pagination';
import mongoose from 'mongoose';

export interface CreateWarehouseInput {
  name: string;
  code: string;
  addressLine1?: string;
  city?: string;
  country?: string;
}

export interface UpdateWarehouseInput {
  name?: string;
  code?: string;
  addressLine1?: string;
  city?: string;
  country?: string;
  isActive?: boolean;
}

export interface CreateLocationInput {
  warehouseId: string;
  parentId?: string;
  name: string;
  code: string;
  type: LocationType;
  capacity?: number;
}

export interface UpdateLocationInput {
  name?: string;
  code?: string;
  type?: LocationType;
  capacity?: number;
  isActive?: boolean;
}

export class WarehousesService {
  async getWarehouses(
    tenantId: string,
    params: { page: number; pageSize: number; search?: string; sortBy?: string; sortOrder?: 'asc' | 'desc' }
  ): Promise<PaginatedResponse<any>> {
    const query: any = { tenantId: new mongoose.Types.ObjectId(tenantId) };
    
    if (params.search) {
      query.$or = [
        { name: { $regex: params.search, $options: 'i' } },
        { code: { $regex: params.search, $options: 'i' } },
      ];
    }

    const options = buildQueryOptions(params);
    const [warehouses, total] = await Promise.all([
      Warehouse.find(query)
        .sort(options.sort)
        .skip(options.skip)
        .limit(options.limit),
      Warehouse.countDocuments(query),
    ]);

    return {
      data: warehouses,
      meta: {
        page: params.page,
        pageSize: params.pageSize,
        total,
        totalPages: Math.ceil(total / params.pageSize),
      },
    };
  }

  async getWarehouseById(tenantId: string, warehouseId: string): Promise<any> {
    const warehouse = await Warehouse.findOne({
      _id: new mongoose.Types.ObjectId(warehouseId),
      tenantId: new mongoose.Types.ObjectId(tenantId),
    });

    if (!warehouse) {
      throw new NotFoundError('Warehouse');
    }
    return warehouse;
  }

  async createWarehouse(tenantId: string, input: CreateWarehouseInput): Promise<any> {
    const existing = await Warehouse.findOne({
      tenantId: new mongoose.Types.ObjectId(tenantId),
      code: input.code.toUpperCase(),
    });

    if (existing) {
      throw new ConflictError('Warehouse code already exists');
    }

    const warehouse = await Warehouse.create({
      tenantId: new mongoose.Types.ObjectId(tenantId),
      ...input,
      code: input.code.toUpperCase(),
    });

    return warehouse;
  }

  async updateWarehouse(
    tenantId: string,
    warehouseId: string,
    input: UpdateWarehouseInput
  ): Promise<any> {
    if (input.code) {
      const existing = await Warehouse.findOne({
        tenantId: new mongoose.Types.ObjectId(tenantId),
        code: input.code.toUpperCase(),
        _id: { $ne: new mongoose.Types.ObjectId(warehouseId) },
      });

      if (existing) {
        throw new ConflictError('Warehouse code already exists');
      }
      input.code = input.code.toUpperCase();
    }

    const warehouse = await Warehouse.findOneAndUpdate(
      {
        _id: new mongoose.Types.ObjectId(warehouseId),
        tenantId: new mongoose.Types.ObjectId(tenantId),
      },
      { $set: input },
      { new: true, runValidators: true }
    );

    if (!warehouse) {
      throw new NotFoundError('Warehouse');
    }
    return warehouse;
  }

  async getLocations(
    tenantId: string,
    warehouseId: string,
    params: { page: number; pageSize: number; search?: string; sortBy?: string; sortOrder?: 'asc' | 'desc' }
  ): Promise<PaginatedResponse<any>> {
    await this.getWarehouseById(tenantId, warehouseId);

    const query: any = { warehouseId: new mongoose.Types.ObjectId(warehouseId) };
    
    if (params.search) {
      query.$or = [
        { name: { $regex: params.search, $options: 'i' } },
        { code: { $regex: params.search, $options: 'i' } },
      ];
    }

    const options = buildQueryOptions(params);
    const [locations, total] = await Promise.all([
      Location.find(query)
        .sort(options.sort)
        .skip(options.skip)
        .limit(options.limit),
      Location.countDocuments(query),
    ]);

    return {
      data: locations,
      meta: {
        page: params.page,
        pageSize: params.pageSize,
        total,
        totalPages: Math.ceil(total / params.pageSize),
      },
    };
  }

  async createLocation(tenantId: string, warehouseId: string, input: CreateLocationInput): Promise<any> {
    await this.getWarehouseById(tenantId, warehouseId);

    const existing = await Location.findOne({
      warehouseId: new mongoose.Types.ObjectId(warehouseId),
      code: input.code.toUpperCase(),
    });

    if (existing) {
      throw new ConflictError('Location code already exists in this warehouse');
    }

    if (input.parentId) {
      const parent = await Location.findOne({
        _id: new mongoose.Types.ObjectId(input.parentId),
        warehouseId: new mongoose.Types.ObjectId(warehouseId),
      });
      if (!parent) {
        throw new NotFoundError('Parent location');
      }
    }

    const { warehouseId: _warehouseId, ...locationInput } = input;
    const location = await Location.create({
      warehouseId: new mongoose.Types.ObjectId(warehouseId),
      ...locationInput,
      code: input.code.toUpperCase(),
    });

    return location;
  }

  async updateLocation(
    tenantId: string,
    locationId: string,
    input: UpdateLocationInput
  ): Promise<any> {
    if (input.code) {
      const location = await Location.findById(locationId);
      if (!location) {
        throw new NotFoundError('Location');
      }

      const existing = await Location.findOne({
        warehouseId: location.warehouseId,
        code: input.code.toUpperCase(),
        _id: { $ne: new mongoose.Types.ObjectId(locationId) },
      });

      if (existing) {
        throw new ConflictError('Location code already exists in this warehouse');
      }
      input.code = input.code.toUpperCase();
    }

    const location = await Location.findByIdAndUpdate(
      locationId,
      { $set: input },
      { new: true, runValidators: true }
    );

    if (!location) {
      throw new NotFoundError('Location');
    }
    return location;
  }

  async deleteLocation(tenantId: string, locationId: string): Promise<void> {
    const location = await Location.findById(locationId);
    if (!location) {
      throw new NotFoundError('Location');
    }

    const { InventoryBalance } = await import('../../models');
    const hasStock = await InventoryBalance.exists({
      locationId: new mongoose.Types.ObjectId(locationId),
      quantity: { $gt: 0 },
    });

    if (hasStock) {
      throw new ConflictError('Cannot delete location with non-zero stock. Move stock first or deactivate.');
    }

    await Location.findByIdAndDelete(locationId);
  }
}

export const warehousesService = new WarehousesService();