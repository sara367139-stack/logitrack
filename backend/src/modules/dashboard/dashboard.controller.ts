import { Request, Response, NextFunction } from 'express';
import { dashboardService } from './dashboard.service';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { PERMISSIONS } from '../../common/auth';

export class DashboardController {
  async getSummary(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const summary = await dashboardService.getSummary(req.tenantId!);
      res.json({ data: summary });
    } catch (error) {
      next(error);
    }
  }

  async getActivity(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const limit = parseInt(req.query.limit as string) || 20;
      const activity = await dashboardService.getActivity(req.tenantId!, limit);
      res.json({ data: activity });
    } catch (error) {
      next(error);
    }
  }

  async getStockAlerts(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const alerts = await dashboardService.getStockAlerts(req.tenantId!);
      res.json({ data: alerts });
    } catch (error) {
      next(error);
    }
  }
}

export const dashboardController = new DashboardController();