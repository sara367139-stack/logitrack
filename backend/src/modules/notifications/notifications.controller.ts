import { Request, Response, NextFunction } from 'express';
import { notificationsService } from './notifications.service';
import { PaginationParams } from '../../common/pagination';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { PERMISSIONS } from '../../common/auth';

export class NotificationsController {
  async getNotifications(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await notificationsService.getNotifications(
        req.tenantId!,
        req.user!.userId,
        req.query as unknown as PaginationParams
      );
      res.json({ data: result.data, meta: result.meta });
    } catch (error) {
      next(error);
    }
  }

  async markAsRead(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      await notificationsService.markAsRead(req.tenantId!, req.user!.userId, req.params.id);
      res.json({ data: { message: 'Notification marked as read' } });
    } catch (error) {
      next(error);
    }
  }

  async markAllAsRead(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      await notificationsService.markAllAsRead(req.tenantId!, req.user!.userId);
      res.json({ data: { message: 'All notifications marked as read' } });
    } catch (error) {
      next(error);
    }
  }
}

export const notificationsController = new NotificationsController();