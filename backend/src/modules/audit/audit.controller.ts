import { Request, Response, NextFunction } from 'express';
import { auditService } from './audit.service';
import { PaginationParams } from '../../common/pagination';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { PERMISSIONS } from '../../common/auth';

export class AuditController {
  async getAuditLogs(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await auditService.getAuditLogs(req.tenantId!, req.query as unknown as PaginationParams & { entityType?: string; action?: string; userId?: string; fromDate?: string; toDate?: string });
      res.json({ data: result.data, meta: result.meta });
    } catch (error) {
      next(error);
    }
  }
}

export const auditController = new AuditController();