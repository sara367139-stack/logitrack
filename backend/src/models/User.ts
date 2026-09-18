import mongoose, { Document, Schema } from 'mongoose';

export type UserRole = 'owner' | 'admin' | 'manager' | 'operator' | 'viewer';

export interface IUser extends Document {
  tenantId: mongoose.Types.ObjectId;
  email: string;
  passwordHash: string;
  firstName: string;
  lastName: string;
  phone?: string;
  role: UserRole;
  avatarUrl?: string;
  isActive: boolean;
  lastLoginAt?: Date;
  resetPasswordToken?: string;
  resetPasswordExpires?: Date;
  createdAt: Date;
  updatedAt: Date;
}

const UserSchema = new Schema<IUser>(
  {
    tenantId: { type: Schema.Types.ObjectId, ref: 'Tenant', required: true },
    email: { type: String, required: true, unique: true, maxlength: 255 },
    passwordHash: { type: String, required: true },
    firstName: { type: String, required: true, maxlength: 80 },
    lastName: { type: String, required: true, maxlength: 80 },
    phone: { type: String, maxlength: 40 },
    role: {
      type: String,
      required: true,
      enum: ['owner', 'admin', 'manager', 'operator', 'viewer'],
    },
    avatarUrl: { type: String },
    isActive: { type: Boolean, default: true },
    lastLoginAt: { type: Date },
    resetPasswordToken: { type: String },
    resetPasswordExpires: { type: Date },
  },
  { timestamps: true }
);

UserSchema.index({ tenantId: 1, email: 1 }, { unique: true });
UserSchema.index({ tenantId: 1, isActive: 1 });

export const User = mongoose.model<IUser>('User', UserSchema);
export default User;