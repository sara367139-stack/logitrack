import { Request, Response, NextFunction } from 'express';
import { purchaseOrdersService } from './purchase-orders.service';
import { PaginationParams } from '../../common/pagination';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { PERMISSIONS } from '../../common/auth';

export class PurchaseOrdersController {
  async getPurchaseOrders(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await purchaseOrdersService.getPurchaseOrders(req.tenantId!, req.query as unknown as PaginationParams & { status?: string });
      res.json({ data: result.data, meta: result.meta });
    } catch (error) {
      next(error);
    }
  }

  async getPurchaseOrderById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const order = await purchaseOrdersService.getPurchaseOrderById(req.tenantId!, req.params.id);
      res.json({ data: order });
    } catch (error) {
      next(error);
    }
  }

  async createPurchaseOrder(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const order = await purchaseOrdersService.createPurchaseOrder(req.tenantId!, req.user!.userId, req.body);
      res.status(201).json({ data: order });
    } catch (error) {
      next(error);
    }
  }

  async updatePurchaseOrder(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const order = await purchaseOrdersService.updatePurchaseOrder(req.tenantId!, req.params.id, req.body, req.user!.role);
      res.json({ data: order });
    } catch (error) {
      next(error);
    }
  }

  async submitPurchaseOrder(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const order = await purchaseOrdersService.submitPurchaseOrder(req.tenantId!, req.params.id);
      res.json({ data: order });
    } catch (error) {
      next(error);
    }
  }

  async approvePurchaseOrder(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const order = await purchaseOrdersService.approvePurchaseOrder(req.tenantId!, req.params.id, req.user!.userId);
      res.json({ data: order });
    } catch (error) {
      next(error);
    }
  }

  async cancelPurchaseOrder(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const order = await purchaseOrdersService.cancelPurchaseOrder(req.tenantId!, req.params.id);
      res.json({ data: order });
    } catch (error) {
      next(error);
    }
  }

  async receivePurchaseOrder(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { items, locationId, note } = req.body;
      const order = await purchaseOrdersService.receivePurchaseOrder(
        req.tenantId!,
        req.params.id,
        req.user!.userId,
        items,
        locationId,
        note
      );
      res.json({ data: order });
    } catch (error) {
      next(error);
    }
  }
}

export const purchaseOrdersController = new PurchaseOrdersController();