import argon2 from 'argon2';
import { v4 as uuidv4 } from 'uuid';
import { User, ITenant, Tenant, RefreshToken, Warehouse, Location } from '../../models';
import { generateTokens, hashToken, verifyRefreshToken } from '../../common/auth';
import { AuthenticationError, ConflictError, NotFoundError } from '../../common/errors';
import { config } from '../../config';
import mongoose from 'mongoose';

export interface RegisterInput {
  companyName: string;
  firstName: string;
  lastName: string;
  email: string;
  password: string;
}

export interface LoginInput {
  email: string;
  password: string;
}

export interface AuthResult {
  user: {
    id: string;
    tenantId: string;
    email: string;
    firstName: string;
    lastName: string;
    role: string;
  };
  accessToken: string;
  refreshToken: string;
}

export class AuthService {
  async register(input: RegisterInput): Promise<AuthResult> {
    const existingUser = await User.findOne({ email: input.email.toLowerCase() });
    if (existingUser) {
      throw new ConflictError('Email already registered');
    }

    const slug = input.companyName
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/(^-|-$)/g, '')
      .substring(0, 100);

    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      const tenant = await Tenant.create([{
        name: input.companyName,
        slug: `${slug}-${uuidv4().substring(0, 8)}`,
      }], { session });

      const passwordHash = await argon2.hash(input.password);

      const user = await User.create([{
        tenantId: tenant[0]._id,
        email: input.email.toLowerCase(),
        passwordHash,
        firstName: input.firstName,
        lastName: input.lastName,
        role: 'owner',
      }], { session });

      const warehouse = await Warehouse.create([{
        tenantId: tenant[0]._id,
        name: 'Main Warehouse',
        code: 'MAIN',
        isActive: true,
      }], { session });

      await Location.create([{
        warehouseId: warehouse[0]._id,
        name: 'Receiving Dock',
        code: 'RECV',
        type: 'receiving',
        isActive: true,
      }, {
        warehouseId: warehouse[0]._id,
        name: 'Zone A',
        code: 'ZONE-A',
        type: 'zone',
        isActive: true,
      }, {
        warehouseId: warehouse[0]._id,
        name: 'Zone B',
        code: 'ZONE-B',
        type: 'zone',
        isActive: true,
      }, {
        warehouseId: warehouse[0]._id,
        name: 'Dispatch Area',
        code: 'DISPATCH',
        type: 'dispatch',
        isActive: true,
      }], { session });

      await session.commitTransaction();

      const tokens = generateTokens({
        userId: user[0]._id.toString(),
        tenantId: tenant[0]._id.toString(),
        email: user[0].email,
        role: user[0].role,
      });

      await this.storeRefreshToken(user[0]._id, tokens.refreshToken);

      return {
        user: {
          id: user[0]._id.toString(),
          tenantId: tenant[0]._id.toString(),
          email: user[0].email,
          firstName: user[0].firstName,
          lastName: user[0].lastName,
          role: user[0].role,
        },
        ...tokens,
      };
    } catch (error) {
      await session.abortTransaction();
      throw error;
    } finally {
      await session.endSession();
    }
  }

  async login(input: LoginInput): Promise<AuthResult> {
    const user = await User.findOne({ email: input.email.toLowerCase() })
      .populate('tenantId');
    
    if (!user) {
      throw new AuthenticationError('Invalid email or password');
    }

    if (!user.isActive) {
      throw new AuthenticationError('Account deactivated');
    }

    const valid = await argon2.verify(user.passwordHash, input.password);
    if (!valid) {
      throw new AuthenticationError('Invalid email or password');
    }

    user.lastLoginAt = new Date();
    await user.save();

    const tokens = generateTokens({
      userId: user._id.toString(),
      tenantId: user.tenantId.toString(),
      email: user.email,
      role: user.role,
    });

    await this.storeRefreshToken(user._id, tokens.refreshToken);

    return {
      user: {
        id: user._id.toString(),
        tenantId: user.tenantId.toString(),
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
      },
      ...tokens,
    };
  }

  async refresh(refreshToken: string): Promise<{ accessToken: string; refreshToken: string }> {
    const payload = verifyRefreshToken(refreshToken);
    const tokenHash = hashToken(refreshToken);

    const storedToken = await RefreshToken.findOne({
      userId: payload.userId,
      tokenHash,
      revokedAt: null,
      expiresAt: { $gt: new Date() },
    });

    if (!storedToken) {
      throw new AuthenticationError('Invalid or revoked refresh token');
    }

    const user = await User.findById(payload.userId);
    if (!user || !user.isActive) {
      throw new AuthenticationError('User not found or deactivated');
    }

    storedToken.revokedAt = new Date();
    await storedToken.save();

    const tokens = generateTokens({
      userId: user._id.toString(),
      tenantId: user.tenantId.toString(),
      email: user.email,
      role: user.role,
    });

    await this.storeRefreshToken(user._id, tokens.refreshToken);

    return tokens;
  }

  async logout(refreshToken: string): Promise<void> {
    const tokenHash = hashToken(refreshToken);
    await RefreshToken.updateOne(
      { tokenHash },
      { revokedAt: new Date() }
    );
  }

  async logoutAll(userId: string): Promise<void> {
    await RefreshToken.updateMany(
      { userId, revokedAt: null },
      { revokedAt: new Date() }
    );
  }

  async forgotPassword(email: string): Promise<void> {
    const user = await User.findOne({ email: email.toLowerCase() });
    if (!user) {
      return;
    }
  }

  async resetPassword(token: string, password: string): Promise<void> {
    const crypto = require('crypto');
    const tokenHash = crypto.createHash('sha256').update(token).digest('hex');
    
    const user = await User.findOne({
      resetPasswordToken: tokenHash,
      resetPasswordExpires: { $gt: new Date() },
    });

    if (!user) {
      throw new AuthenticationError('Invalid or expired reset token');
    }

    user.passwordHash = await argon2.hash(password);
    user.resetPasswordToken = undefined;
    user.resetPasswordExpires = undefined;
    await user.save();

    await this.logoutAll(user._id.toString());
  }

  async getCurrentUser(userId: string): Promise<any> {
    const user = await User.findById(userId).select('-passwordHash');
    if (!user) {
      throw new NotFoundError('User');
    }
    return user;
  }

  async updateCurrentUser(userId: string, data: Partial<Pick<typeof User.prototype, 'firstName' | 'lastName' | 'phone'>>): Promise<any> {
    const user = await User.findByIdAndUpdate(
      userId,
      { $set: data },
      { new: true, runValidators: true }
    ).select('-passwordHash');
    
    if (!user) {
      throw new NotFoundError('User');
    }
    return user;
  }

  private async storeRefreshToken(userId: mongoose.Types.ObjectId, refreshToken: string): Promise<void> {
    const tokenHash = hashToken(refreshToken);
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + config.jwt.refreshTokenDays);

    await RefreshToken.create({
      userId,
      tokenHash,
      expiresAt,
    });
  }
}

export const authService = new AuthService();