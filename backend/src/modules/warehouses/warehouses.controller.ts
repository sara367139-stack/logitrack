import { Request, Response, NextFunction } from 'express';
import { warehousesService } from './warehouses.service';
import { PaginationParams } from '../../common/pagination';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { PERMISSIONS } from '../../common/auth';

export class WarehousesController {
  async getWarehouses(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await warehousesService.getWarehouses(req.tenantId!, req.query as unknown as PaginationParams);
      res.json({ data: result.data, meta: result.meta });
    } catch (error) {
      next(error);
    }
  }

  async getWarehouseById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const warehouse = await warehousesService.getWarehouseById(req.tenantId!, req.params.id);
      res.json({ data: warehouse });
    } catch (error) {
      next(error);
    }
  }

  async createWarehouse(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const warehouse = await warehousesService.createWarehouse(req.tenantId!, req.body);
      res.status(201).json({ data: warehouse });
    } catch (error) {
      next(error);
    }
  }

  async updateWarehouse(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const warehouse = await warehousesService.updateWarehouse(req.tenantId!, req.params.id, req.body);
      res.json({ data: warehouse });
    } catch (error) {
      next(error);
    }
  }

  async getLocations(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await warehousesService.getLocations(req.tenantId!, req.params.id, req.query as unknown as PaginationParams);
      res.json({ data: result.data, meta: result.meta });
    } catch (error) {
      next(error);
    }
  }

  async createLocation(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const location = await warehousesService.createLocation(req.tenantId!, req.params.id, req.body);
      res.status(201).json({ data: location });
    } catch (error) {
      next(error);
    }
  }

  async updateLocation(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const location = await warehousesService.updateLocation(req.tenantId!, req.params.locationId, req.body);
      res.json({ data: location });
    } catch (error) {
      next(error);
    }
  }

  async deleteLocation(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      await warehousesService.deleteLocation(req.tenantId!, req.params.locationId);
      res.json({ data: { message: 'Location deleted successfully' } });
    } catch (error) {
      next(error);
    }
  }
}

export const warehousesController = new WarehousesController();