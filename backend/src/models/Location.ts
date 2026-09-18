import mongoose, { Document, Schema } from 'mongoose';

export type LocationType = 'receiving' | 'zone' | 'aisle' | 'shelf' | 'bin' | 'dispatch';

export interface ILocation extends Document {
  warehouseId: mongoose.Types.ObjectId;
  parentId?: mongoose.Types.ObjectId;
  name: string;
  code: string;
  type: LocationType;
  capacity?: number;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const LocationSchema = new Schema<ILocation>(
  {
    warehouseId: { type: Schema.Types.ObjectId, ref: 'Warehouse', required: true },
    parentId: { type: Schema.Types.ObjectId, ref: 'Location' },
    name: { type: String, required: true, maxlength: 120 },
    code: { type: String, required: true, maxlength: 60 },
    type: {
      type: String,
      required: true,
      enum: ['receiving', 'zone', 'aisle', 'shelf', 'bin', 'dispatch'],
    },
    capacity: { type: Number },
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

LocationSchema.index({ warehouseId: 1, code: 1 }, { unique: true });
LocationSchema.index({ warehouseId: 1, isActive: 1 });
LocationSchema.index({ parentId: 1 });

export const Location = mongoose.model<ILocation>('Location', LocationSchema);
export default Location;