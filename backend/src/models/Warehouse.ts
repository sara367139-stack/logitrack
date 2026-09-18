import mongoose, { Document, Schema } from 'mongoose';

export interface IWarehouse extends Document {
  tenantId: mongoose.Types.ObjectId;
  name: string;
  code: string;
  addressLine1?: string;
  city?: string;
  country?: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const WarehouseSchema = new Schema<IWarehouse>(
  {
    tenantId: { type: Schema.Types.ObjectId, ref: 'Tenant', required: true },
    name: { type: String, required: true, maxlength: 160 },
    code: { type: String, required: true, maxlength: 40 },
    addressLine1: { type: String, maxlength: 200 },
    city: { type: String, maxlength: 100 },
    country: { type: String, maxlength: 100 },
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

WarehouseSchema.index({ tenantId: 1, code: 1 }, { unique: true });
WarehouseSchema.index({ tenantId: 1, isActive: 1 });

export const Warehouse = mongoose.model<IWarehouse>('Warehouse', WarehouseSchema);
export default Warehouse;