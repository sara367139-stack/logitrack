import mongoose, { Document, Schema } from 'mongoose';

export interface INotification extends Document {
  tenantId: mongoose.Types.ObjectId;
  userId?: mongoose.Types.ObjectId;
  type: string;
  title: string;
  message: string;
  data?: Record<string, unknown>;
  readAt?: Date;
  createdAt: Date;
}

const NotificationSchema = new Schema<INotification>(
  {
    tenantId: { type: Schema.Types.ObjectId, ref: 'Tenant', required: true },
    userId: { type: Schema.Types.ObjectId, ref: 'User' },
    type: { type: String, required: true, maxlength: 40 },
    title: { type: String, required: true, maxlength: 180 },
    message: { type: String, required: true },
    data: { type: Schema.Types.Mixed },
    readAt: { type: Date },
  },
  { timestamps: { createdAt: true, updatedAt: false } }
);

NotificationSchema.index({ tenantId: 1, userId: 1, readAt: 1, createdAt: -1 });
NotificationSchema.index({ tenantId: 1, type: 1 });
NotificationSchema.index({ userId: 1, readAt: 1 });

export const Notification = mongoose.model<INotification>('Notification', NotificationSchema);
export default Notification;