import { User, IUser, UserRole } from '../../models';
import { NotFoundError, ConflictError, AuthorizationError } from '../../common/errors';
import { hasPermission, PERMISSIONS } from '../../common/auth';
import { buildQueryOptions, PaginatedResponse } from '../../common/pagination';
import mongoose from 'mongoose';

export interface InviteUserInput {
  email: string;
  firstName: string;
  lastName: string;
  role: UserRole;
}

export interface UpdateUserRoleInput {
  role: UserRole;
}

export class UsersService {
  async getUsers(
    tenantId: string,
    params: { page: number; pageSize: number; search?: string; sortBy?: string; sortOrder?: 'asc' | 'desc' },
    currentUserRole: string
  ): Promise<PaginatedResponse<any>> {
    const query: any = { tenantId: new mongoose.Types.ObjectId(tenantId) };
    
    if (params.search) {
      query.$or = [
        { firstName: { $regex: params.search, $options: 'i' } },
        { lastName: { $regex: params.search, $options: 'i' } },
        { email: { $regex: params.search, $options: 'i' } },
      ];
    }

    const options = buildQueryOptions(params);
    const [users, total] = await Promise.all([
      User.find(query)
        .select('-passwordHash')
        .sort(options.sort)
        .skip(options.skip)
        .limit(options.limit),
      User.countDocuments(query),
    ]);

    return {
      data: users,
      meta: {
        page: params.page,
        pageSize: params.pageSize,
        total,
        totalPages: Math.ceil(total / params.pageSize),
      },
    };
  }

  async getUserById(tenantId: string, userId: string): Promise<any> {
    const user = await User.findOne({
      _id: new mongoose.Types.ObjectId(userId),
      tenantId: new mongoose.Types.ObjectId(tenantId),
    }).select('-passwordHash');

    if (!user) {
      throw new NotFoundError('User');
    }
    return user;
  }

  async inviteUser(
    tenantId: string,
    input: InviteUserInput,
    invitedByRole: string
  ): Promise<any> {
    if (!hasPermission(invitedByRole, PERMISSIONS.USERS_MANAGE)) {
      throw new AuthorizationError('Insufficient permissions to invite users');
    }

    if (input.role === 'owner') {
      throw new AuthorizationError('Cannot invite owner role');
    }

    const existingUser = await User.findOne({
      email: input.email.toLowerCase(),
      tenantId: new mongoose.Types.ObjectId(tenantId),
    });

    if (existingUser) {
      throw new ConflictError('User with this email already exists in this tenant');
    }

    const crypto = require('crypto');
    const tempPassword = crypto.randomBytes(16).toString('hex');
    const argon2 = require('argon2');
    const passwordHash = await argon2.hash(tempPassword);

    const user = await User.create({
      tenantId: new mongoose.Types.ObjectId(tenantId),
      email: input.email.toLowerCase(),
      passwordHash,
      firstName: input.firstName,
      lastName: input.lastName,
      role: input.role,
      isActive: true,
    });

    const userObj = user.toObject() as any;
    delete userObj.passwordHash;

    return {
      ...userObj,
      temporaryPassword: tempPassword,
    };
  }

  async updateUserRole(
    tenantId: string,
    userId: string,
    role: UserRole,
    currentUserRole: string,
    currentUserId: string
  ): Promise<any> {
    if (!hasPermission(currentUserRole, PERMISSIONS.USERS_MANAGE)) {
      throw new AuthorizationError('Insufficient permissions to update user roles');
    }

    if (userId === currentUserId) {
      throw new AuthorizationError('Cannot change your own role');
    }

    if (role === 'owner') {
      throw new AuthorizationError('Cannot assign owner role');
    }

    const targetUser = await User.findOne({
      _id: new mongoose.Types.ObjectId(userId),
      tenantId: new mongoose.Types.ObjectId(tenantId),
    });

    if (!targetUser) {
      throw new NotFoundError('User');
    }

    if (targetUser.role === 'owner') {
      throw new AuthorizationError('Cannot change owner role');
    }

    targetUser.role = role;
    await targetUser.save();

    const userObj = targetUser.toObject() as any;
    delete userObj.passwordHash;
    return userObj;
  }

  async deactivateUser(
    tenantId: string,
    userId: string,
    currentUserRole: string,
    currentUserId: string
  ): Promise<void> {
    if (!hasPermission(currentUserRole, PERMISSIONS.USERS_MANAGE)) {
      throw new AuthorizationError('Insufficient permissions to deactivate users');
    }

    if (userId === currentUserId) {
      throw new AuthorizationError('Cannot deactivate yourself');
    }

    const user = await User.findOne({
      _id: new mongoose.Types.ObjectId(userId),
      tenantId: new mongoose.Types.ObjectId(tenantId),
    });

    if (!user) {
      throw new NotFoundError('User');
    }

    if (user.role === 'owner') {
      throw new AuthorizationError('Cannot deactivate owner');
    }

    user.isActive = false;
    await user.save();
  }
}

export const usersService = new UsersService();