import mongoose, { Document, Schema } from 'mongoose';

export interface ISupplier extends Document {
  tenantId: mongoose.Types.ObjectId;
  name: string;
  contactName?: string;
  email?: string;
  phone?: string;
  address?: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const SupplierSchema = new Schema<ISupplier>(
  {
    tenantId: { type: Schema.Types.ObjectId, ref: 'Tenant', required: true },
    name: { type: String, required: true, maxlength: 160 },
    contactName: { type: String, maxlength: 120 },
    email: { type: String, maxlength: 255 },
    phone: { type: String, maxlength: 40 },
    address: { type: String },
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

SupplierSchema.index({ tenantId: 1, isActive: 1 });
SupplierSchema.index({ tenantId: 1, name: 1 });

export const Supplier = mongoose.model<ISupplier>('Supplier', SupplierSchema);
export default Supplier;