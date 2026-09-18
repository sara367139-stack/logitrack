import mongoose, { Document, Schema } from 'mongoose';

export type PurchaseOrderStatus = 'draft' | 'submitted' | 'approved' | 'partial' | 'received' | 'cancelled';

export interface IPurchaseOrderItem extends Document {
  purchaseOrderId: mongoose.Types.ObjectId;
  productId: mongoose.Types.ObjectId;
  orderedQuantity: number;
  receivedQuantity: number;
  unitCost: number;
}

const PurchaseOrderItemSchema = new Schema<IPurchaseOrderItem>(
  {
    purchaseOrderId: { type: Schema.Types.ObjectId, ref: 'PurchaseOrder', required: true },
    productId: { type: Schema.Types.ObjectId, ref: 'Product', required: true },
    orderedQuantity: { type: Number, required: true, min: 1 },
    receivedQuantity: { type: Number, default: 0, min: 0 },
    unitCost: { type: Number, required: true, min: 0 },
  },
  { timestamps: true }
);

PurchaseOrderItemSchema.index({ purchaseOrderId: 1 });
PurchaseOrderItemSchema.index({ productId: 1 });

export const PurchaseOrderItem = mongoose.model<IPurchaseOrderItem>('PurchaseOrderItem', PurchaseOrderItemSchema);
export default PurchaseOrderItem;