import mongoose, { Document, Schema } from 'mongoose';
import { PurchaseOrderStatus } from './PurchaseOrderItem';

export interface IPurchaseOrder extends Document {
  tenantId: mongoose.Types.ObjectId;
  supplierId: mongoose.Types.ObjectId;
  warehouseId: mongoose.Types.ObjectId;
  orderNumber: string;
  status: PurchaseOrderStatus;
  expectedDate?: Date;
  notes?: string;
  createdBy: mongoose.Types.ObjectId;
  approvedBy?: mongoose.Types.ObjectId;
  createdAt: Date;
  updatedAt: Date;
}

const PurchaseOrderSchema = new Schema<IPurchaseOrder>(
  {
    tenantId: { type: Schema.Types.ObjectId, ref: 'Tenant', required: true },
    supplierId: { type: Schema.Types.ObjectId, ref: 'Supplier', required: true },
    warehouseId: { type: Schema.Types.ObjectId, ref: 'Warehouse', required: true },
    orderNumber: { type: String, required: true, maxlength: 50 },
    status: {
      type: String,
      required: true,
      enum: ['draft', 'submitted', 'partial', 'received', 'cancelled'],
      default: 'draft',
    },
    expectedDate: { type: Date },
    notes: { type: String },
    createdBy: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    approvedBy: { type: Schema.Types.ObjectId, ref: 'User' },
  },
  { timestamps: true }
);

PurchaseOrderSchema.index({ tenantId: 1, orderNumber: 1 }, { unique: true });
PurchaseOrderSchema.index({ tenantId: 1, status: 1 });
PurchaseOrderSchema.index({ supplierId: 1 });
PurchaseOrderSchema.index({ warehouseId: 1 });
PurchaseOrderSchema.index({ createdBy: 1 });

export const PurchaseOrder = mongoose.model<IPurchaseOrder>('PurchaseOrder', PurchaseOrderSchema);
export default PurchaseOrder;