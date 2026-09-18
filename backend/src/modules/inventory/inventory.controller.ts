import { Request, Response, NextFunction } from 'express';
import { inventoryService } from './inventory.service';
import { PaginationParams } from '../../common/pagination';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { PERMISSIONS } from '../../common/auth';

export class InventoryController {
  async getInventory(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await inventoryService.getInventory(req.tenantId!, req.query as unknown as PaginationParams & { locationId?: string; productId?: string });
      res.json({ data: result.data, meta: result.meta });
    } catch (error) {
      next(error);
    }
  }

  async getLowStock(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const items = await inventoryService.getLowStock(req.tenantId!);
      res.json({ data: items });
    } catch (error) {
      next(error);
    }
  }

  async getInventoryByProduct(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const stock = await inventoryService.getInventoryByProduct(req.tenantId!, req.params.productId);
      res.json({ data: stock });
    } catch (error) {
      next(error);
    }
  }

  async getInventoryByLocation(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await inventoryService.getInventoryByLocation(req.tenantId!, req.params.locationId, req.query as unknown as PaginationParams);
      res.json({ data: result.data, meta: result.meta });
    } catch (error) {
      next(error);
    }
  }

  async moveInventory(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await inventoryService.moveInventory(req.tenantId!, req.user!.userId, req.body);
      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async dispatchInventory(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await inventoryService.dispatchInventory(req.tenantId!, req.user!.userId, req.body);
      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async adjustInventory(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await inventoryService.adjustInventory(req.tenantId!, req.user!.userId, req.body);
      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async getTransactionHistory(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await inventoryService.getTransactionHistory(req.tenantId!, req.query as unknown as PaginationParams & { productId?: string; locationId?: string; type?: string; fromDate?: string; toDate?: string });
      res.json({ data: result.data, meta: result.meta });
    } catch (error) {
      next(error);
    }
  }
}

export const inventoryController = new InventoryController();