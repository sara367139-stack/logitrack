import mongoose, { Document, Schema } from 'mongoose';

export interface IInventoryBalance extends Document {
  productId: mongoose.Types.ObjectId;
  locationId: mongoose.Types.ObjectId;
  quantity: number;
  reservedQuantity: number;
  updatedAt: Date;
}

const InventoryBalanceSchema = new Schema<IInventoryBalance>(
  {
    productId: { type: Schema.Types.ObjectId, ref: 'Product', required: true },
    locationId: { type: Schema.Types.ObjectId, ref: 'Location', required: true },
    quantity: { type: Number, required: true, default: 0, min: 0 },
    reservedQuantity: { type: Number, required: true, default: 0, min: 0 },
    updatedAt: { type: Date, required: true, default: Date.now },
  },
  { timestamps: true }
);

InventoryBalanceSchema.index({ productId: 1, locationId: 1 }, { unique: true });
InventoryBalanceSchema.index({ locationId: 1 });
InventoryBalanceSchema.index({ productId: 1 });

export const InventoryBalance = mongoose.model<IInventoryBalance>('InventoryBalance', InventoryBalanceSchema);
export default InventoryBalance;