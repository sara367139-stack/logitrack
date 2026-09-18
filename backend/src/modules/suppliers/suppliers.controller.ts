import { Request, Response, NextFunction } from 'express';
import { suppliersService } from './suppliers.service';
import { PaginationParams } from '../../common/pagination';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { PERMISSIONS } from '../../common/auth';

export class SuppliersController {
  async getSuppliers(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await suppliersService.getSuppliers(req.tenantId!, req.query as unknown as PaginationParams);
      res.json({ data: result.data, meta: result.meta });
    } catch (error) {
      next(error);
    }
  }

  async getSupplierById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const supplier = await suppliersService.getSupplierById(req.tenantId!, req.params.id);
      res.json({ data: supplier });
    } catch (error) {
      next(error);
    }
  }

  async createSupplier(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const supplier = await suppliersService.createSupplier(req.tenantId!, req.body);
      res.status(201).json({ data: supplier });
    } catch (error) {
      next(error);
    }
  }

  async updateSupplier(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const supplier = await suppliersService.updateSupplier(req.tenantId!, req.params.id, req.body);
      res.json({ data: supplier });
    } catch (error) {
      next(error);
    }
  }

  async deleteSupplier(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      await suppliersService.deleteSupplier(req.tenantId!, req.params.id);
      res.json({ data: { message: 'Supplier deactivated successfully' } });
    } catch (error) {
      next(error);
    }
  }

  async getSupplierPurchaseOrders(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await suppliersService.getSupplierPurchaseOrders(req.tenantId!, req.params.id, req.query as unknown as PaginationParams);
      res.json({ data: result.data, meta: result.meta });
    } catch (error) {
      next(error);
    }
  }
}

export const suppliersController = new SuppliersController();