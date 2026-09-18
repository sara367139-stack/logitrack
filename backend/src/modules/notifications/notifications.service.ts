import { Notification } from '../../models';
import { buildQueryOptions, PaginatedResponse } from '../../common/pagination';
import mongoose from 'mongoose';

export class NotificationsService {
  async getNotifications(
    tenantId: string,
    userId: string,
    params: { page: number; pageSize: number; sortBy?: string; sortOrder?: 'asc' | 'desc' }
  ): Promise<PaginatedResponse<any>> {
    const query: any = {
      tenantId: new mongoose.Types.ObjectId(tenantId),
      $or: [
        { userId: new mongoose.Types.ObjectId(userId) },
        { userId: { $exists: false } },
      ],
    };

    const options = buildQueryOptions(params);
    const [notifications, total] = await Promise.all([
      Notification.find(query)
        .sort(options.sort)
        .skip(options.skip)
        .limit(options.limit),
      Notification.countDocuments(query),
    ]);

    return {
      data: notifications,
      meta: {
        page: params.page,
        pageSize: params.pageSize,
        total,
        totalPages: Math.ceil(total / params.pageSize),
      },
    };
  }

  async markAsRead(tenantId: string, userId: string, notificationId: string): Promise<void> {
    const notification = await Notification.findOneAndUpdate(
      {
        _id: new mongoose.Types.ObjectId(notificationId),
        tenantId: new mongoose.Types.ObjectId(tenantId),
        $or: [
          { userId: new mongoose.Types.ObjectId(userId) },
          { userId: { $exists: false } },
        ],
      },
      { $set: { readAt: new Date() } },
      { new: true }
    );

    if (!notification) {
      throw new Error('Notification not found');
    }
  }

  async markAllAsRead(tenantId: string, userId: string): Promise<void> {
    await Notification.updateMany(
      {
        tenantId: new mongoose.Types.ObjectId(tenantId),
        $or: [
          { userId: new mongoose.Types.ObjectId(userId) },
          { userId: { $exists: false } },
        ],
        readAt: { $exists: false },
      },
      { $set: { readAt: new Date() } }
    );
  }

  async getUnreadCount(tenantId: string, userId: string): Promise<number> {
    return Notification.countDocuments({
      tenantId: new mongoose.Types.ObjectId(tenantId),
      $or: [
        { userId: new mongoose.Types.ObjectId(userId) },
        { userId: { $exists: false } },
      ],
      readAt: { $exists: false },
    });
  }
}

export const notificationsService = new NotificationsService();