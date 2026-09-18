import mongoose, { Document, Schema } from 'mongoose';

export interface IAuditLog extends Document {
  tenantId: mongoose.Types.ObjectId;
  userId?: mongoose.Types.ObjectId;
  action: string;
  entityType: string;
  entityId?: mongoose.Types.ObjectId;
  beforeData?: Record<string, unknown>;
  afterData?: Record<string, unknown>;
  ipAddress?: string;
  createdAt: Date;
}

const AuditLogSchema = new Schema<IAuditLog>(
  {
    tenantId: { type: Schema.Types.ObjectId, ref: 'Tenant', required: true },
    userId: { type: Schema.Types.ObjectId, ref: 'User' },
    action: { type: String, required: true, maxlength: 80 },
    entityType: { type: String, required: true, maxlength: 80 },
    entityId: { type: Schema.Types.ObjectId },
    beforeData: { type: Schema.Types.Mixed },
    afterData: { type: Schema.Types.Mixed },
    ipAddress: { type: String, maxlength: 64 },
  },
  { timestamps: { createdAt: true, updatedAt: false } }
);

AuditLogSchema.index({ tenantId: 1, createdAt: -1 });
AuditLogSchema.index({ tenantId: 1, entityType: 1, entityId: 1 });
AuditLogSchema.index({ userId: 1, createdAt: -1 });
AuditLogSchema.index({ action: 1 });

export const AuditLog = mongoose.model<IAuditLog>('AuditLog', AuditLogSchema);
export default AuditLog;