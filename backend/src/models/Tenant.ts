import mongoose, { Document, Schema } from 'mongoose';

export interface ITenant extends Document {
  name: string;
  slug: string;
  logoUrl?: string;
  defaultCurrency: string;
  timezone: string;
  createdAt: Date;
  updatedAt: Date;
}

const TenantSchema = new Schema<ITenant>(
  {
    name: { type: String, required: true, maxlength: 160 },
    slug: { type: String, required: true, unique: true, maxlength: 100 },
    logoUrl: { type: String },
    defaultCurrency: { type: String, default: 'USD', maxlength: 3 },
    timezone: { type: String, default: 'UTC', maxlength: 80 },
  },
  { timestamps: true }
);

TenantSchema.index({ slug: 1 }, { unique: true });

export const Tenant = mongoose.model<ITenant>('Tenant', TenantSchema);
export default Tenant;