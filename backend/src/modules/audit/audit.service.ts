import { AuditLog } from '../../models';
import { buildQueryOptions, PaginatedResponse } from '../../common/pagination';
import mongoose from 'mongoose';

export class AuditService {
  async getAuditLogs(
    tenantId: string,
    params: { 
      page: number; 
      pageSize: number; 
      search?: string; 
      sortBy?: string; 
      sortOrder?: 'asc' | 'desc';
      entityType?: string;
      action?: string;
      userId?: string;
      fromDate?: string;
      toDate?: string;
    }
  ): Promise<PaginatedResponse<any>> {
    const query: any = { tenantId: new mongoose.Types.ObjectId(tenantId) };
    
    if (params.entityType) {
      query.entityType = params.entityType;
    }
    if (params.action) {
      query.action = params.action;
    }
    if (params.userId) {
      query.userId = new mongoose.Types.ObjectId(params.userId);
    }
    if (params.fromDate || params.toDate) {
      query.createdAt = {};
      if (params.fromDate) query.createdAt.$gte = new Date(params.fromDate);
      if (params.toDate) query.createdAt.$lte = new Date(params.toDate);
    }

    const options = buildQueryOptions(params);
    const [logs, total] = await Promise.all([
      AuditLog.find(query)
        .populate('userId', 'firstName lastName email')
        .sort(options.sort)
        .skip(options.skip)
        .limit(options.limit),
      AuditLog.countDocuments(query),
    ]);

    return {
      data: logs,
      meta: {
        page: params.page,
        pageSize: params.pageSize,
        total,
        totalPages: Math.ceil(total / params.pageSize),
      },
    };
  }
}

export const auditService = new AuditService();