import mongoose, { Document, Schema } from 'mongoose';

export interface IProduct extends Document {
  tenantId: mongoose.Types.ObjectId;
  sku: string;
  barcode?: string;
  name: string;
  description?: string;
  category?: string;
  unit: string;
  costPrice: number;
  sellingPrice: number;
  reorderLevel: number;
  reorderQuantity: number;
  imageUrl?: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const ProductSchema = new Schema<IProduct>(
  {
    tenantId: { type: Schema.Types.ObjectId, ref: 'Tenant', required: true },
    sku: { type: String, required: true, maxlength: 100 },
    barcode: { type: String, maxlength: 120 },
    name: { type: String, required: true, maxlength: 200 },
    description: { type: String },
    category: { type: String, maxlength: 100 },
    unit: { type: String, default: 'unit', maxlength: 30 },
    costPrice: { type: Number, default: 0, min: 0 },
    sellingPrice: { type: Number, default: 0, min: 0 },
    reorderLevel: { type: Number, default: 0, min: 0 },
    reorderQuantity: { type: Number, default: 0, min: 0 },
    imageUrl: { type: String },
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

ProductSchema.index({ tenantId: 1, sku: 1 }, { unique: true });
ProductSchema.index({ tenantId: 1, barcode: 1 }, { unique: true, sparse: true });
ProductSchema.index({ tenantId: 1, isActive: 1 });
ProductSchema.index({ tenantId: 1, category: 1 });

export const Product = mongoose.model<IProduct>('Product', ProductSchema);
export default Product;