import { Request, Response, NextFunction } from 'express';
import { reportsService } from './reports.service';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { PERMISSIONS } from '../../common/auth';

export class ReportsController {
  async getInventoryValue(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await reportsService.getInventoryValue(req.tenantId!, req.query as { from?: string; to?: string });
      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async getStockMovement(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await reportsService.getStockMovement(req.tenantId!, req.query as { from?: string; to?: string });
      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async getReceivingReport(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await reportsService.getReceivingReport(req.tenantId!, req.query as { from?: string; to?: string });
      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async getDispatchReport(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await reportsService.getDispatchReport(req.tenantId!, req.query as { from?: string; to?: string });
      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async getSlowMoving(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const days = parseInt(req.query.days as string) || 90;
      const result = await reportsService.getSlowMoving(req.tenantId!, days);
      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async exportInventoryCSV(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const csv = await reportsService.exportInventoryCSV(req.tenantId!);
      res.setHeader('Content-Type', 'text/csv');
      res.setHeader('Content-Disposition', 'attachment; filename="inventory-export.csv"');
      res.send(csv);
    } catch (error) {
      next(error);
    }
  }
}

export const reportsController = new ReportsController();