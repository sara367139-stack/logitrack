import mongoose, { Document, Schema } from 'mongoose';

export type TransactionType = 'receive' | 'move' | 'dispatch' | 'adjustment' | 'return';

export interface IInventoryTransaction extends Document {
  tenantId: mongoose.Types.ObjectId;
  productId: mongoose.Types.ObjectId;
  fromLocationId?: mongoose.Types.ObjectId;
  toLocationId?: mongoose.Types.ObjectId;
  quantity: number;
  type: TransactionType;
  referenceType?: string;
  referenceId?: mongoose.Types.ObjectId;
  reason?: string;
  performedBy: mongoose.Types.ObjectId;
  createdAt: Date;
}

const InventoryTransactionSchema = new Schema<IInventoryTransaction>(
  {
    tenantId: { type: Schema.Types.ObjectId, ref: 'Tenant', required: true },
    productId: { type: Schema.Types.ObjectId, ref: 'Product', required: true },
    fromLocationId: { type: Schema.Types.ObjectId, ref: 'Location' },
    toLocationId: { type: Schema.Types.ObjectId, ref: 'Location' },
    quantity: { type: Number, required: true, min: 1 },
    type: {
      type: String,
      required: true,
      enum: ['receive', 'move', 'dispatch', 'adjustment', 'return'],
    },
    referenceType: { type: String, maxlength: 40 },
    referenceId: { type: Schema.Types.ObjectId },
    reason: { type: String },
    performedBy: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  },
  { timestamps: { createdAt: true, updatedAt: false } }
);

InventoryTransactionSchema.index({ tenantId: 1, createdAt: -1 });
InventoryTransactionSchema.index({ tenantId: 1, productId: 1, createdAt: -1 });
InventoryTransactionSchema.index({ tenantId: 1, type: 1 });
InventoryTransactionSchema.index({ tenantId: 1, referenceType: 1, referenceId: 1 });
InventoryTransactionSchema.index({ performedBy: 1 });

export const InventoryTransaction = mongoose.model<IInventoryTransaction>('InventoryTransaction', InventoryTransactionSchema);
export default InventoryTransaction;