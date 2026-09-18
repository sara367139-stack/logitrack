import jwt from 'jsonwebtoken';
import config from '../../config';
import { AuthenticationError, AuthorizationError } from '../errors';

export interface JwtPayload {
  userId: string;
  tenantId: string;
  email: string;
  role: string;
  type: 'access' | 'refresh';
}

export interface TokenPair {
  accessToken: string;
  refreshToken: string;
}

export function generateTokens(payload: Omit<JwtPayload, 'type'>): TokenPair {
  const accessToken = jwt.sign(
    { ...payload, type: 'access' },
    config.jwt.accessSecret,
    { expiresIn: `${config.jwt.accessTokenMinutes}m` }
  );

  const refreshToken = jwt.sign(
    { ...payload, type: 'refresh' },
    config.jwt.refreshSecret,
    { expiresIn: `${config.jwt.refreshTokenDays}d` }
  );

  return { accessToken, refreshToken };
}

export function verifyAccessToken(token: string): JwtPayload {
  try {
    return jwt.verify(token, config.jwt.accessSecret) as JwtPayload;
  } catch (error) {
    if (error instanceof jwt.TokenExpiredError) {
      throw new AuthenticationError('Access token expired');
    }
    throw new AuthenticationError('Invalid access token');
  }
}

export function verifyRefreshToken(token: string): JwtPayload {
  try {
    return jwt.verify(token, config.jwt.refreshSecret) as JwtPayload;
  } catch (error) {
    if (error instanceof jwt.TokenExpiredError) {
      throw new AuthenticationError('Refresh token expired');
    }
    throw new AuthenticationError('Invalid refresh token');
  }
}

export function hashToken(token: string): string {
  const crypto = require('crypto');
  return crypto.createHash('sha256').update(token).digest('hex');
}

export const PERMISSIONS = {
  USERS_READ: 'users.read',
  USERS_MANAGE: 'users.manage',
  WAREHOUSES_READ: 'warehouses.read',
  WAREHOUSES_MANAGE: 'warehouses.manage',
  PRODUCTS_READ: 'products.read',
  PRODUCTS_MANAGE: 'products.manage',
  SUPPLIERS_READ: 'suppliers.read',
  SUPPLIERS_MANAGE: 'suppliers.manage',
  PURCHASE_ORDERS_READ: 'purchase_orders.read',
  PURCHASE_ORDERS_MANAGE: 'purchase_orders.manage',
  INVENTORY_READ: 'inventory.read',
  INVENTORY_RECEIVE: 'inventory.receive',
  INVENTORY_MOVE: 'inventory.move',
  INVENTORY_DISPATCH: 'inventory.dispatch',
  INVENTORY_ADJUST: 'inventory.adjust',
  REPORTS_READ: 'reports.read',
  NOTIFICATIONS_READ: 'notifications.read',
} as const;

export type Permission = typeof PERMISSIONS[keyof typeof PERMISSIONS];

export const ROLE_PERMISSIONS: Record<string, Permission[]> = {
  owner: Object.values(PERMISSIONS),
  admin: [
    PERMISSIONS.USERS_READ,
    PERMISSIONS.USERS_MANAGE,
    PERMISSIONS.WAREHOUSES_READ,
    PERMISSIONS.WAREHOUSES_MANAGE,
    PERMISSIONS.PRODUCTS_READ,
    PERMISSIONS.PRODUCTS_MANAGE,
    PERMISSIONS.SUPPLIERS_READ,
    PERMISSIONS.SUPPLIERS_MANAGE,
    PERMISSIONS.PURCHASE_ORDERS_READ,
    PERMISSIONS.PURCHASE_ORDERS_MANAGE,
    PERMISSIONS.INVENTORY_READ,
    PERMISSIONS.INVENTORY_RECEIVE,
    PERMISSIONS.INVENTORY_MOVE,
    PERMISSIONS.INVENTORY_DISPATCH,
    PERMISSIONS.INVENTORY_ADJUST,
    PERMISSIONS.REPORTS_READ,
    PERMISSIONS.NOTIFICATIONS_READ,
  ],
  manager: [
    PERMISSIONS.USERS_READ,
    PERMISSIONS.WAREHOUSES_READ,
    PERMISSIONS.WAREHOUSES_MANAGE,
    PERMISSIONS.PRODUCTS_READ,
    PERMISSIONS.PRODUCTS_MANAGE,
    PERMISSIONS.SUPPLIERS_READ,
    PERMISSIONS.SUPPLIERS_MANAGE,
    PERMISSIONS.PURCHASE_ORDERS_READ,
    PERMISSIONS.PURCHASE_ORDERS_MANAGE,
    PERMISSIONS.INVENTORY_READ,
    PERMISSIONS.INVENTORY_RECEIVE,
    PERMISSIONS.INVENTORY_MOVE,
    PERMISSIONS.INVENTORY_DISPATCH,
    PERMISSIONS.INVENTORY_ADJUST,
    PERMISSIONS.REPORTS_READ,
    PERMISSIONS.NOTIFICATIONS_READ,
  ],
  operator: [
    PERMISSIONS.USERS_READ,
    PERMISSIONS.WAREHOUSES_READ,
    PERMISSIONS.PRODUCTS_READ,
    PERMISSIONS.INVENTORY_READ,
    PERMISSIONS.INVENTORY_RECEIVE,
    PERMISSIONS.INVENTORY_MOVE,
    PERMISSIONS.INVENTORY_DISPATCH,
    PERMISSIONS.NOTIFICATIONS_READ,
  ],
  viewer: [
    PERMISSIONS.USERS_READ,
    PERMISSIONS.WAREHOUSES_READ,
    PERMISSIONS.PRODUCTS_READ,
    PERMISSIONS.INVENTORY_READ,
    PERMISSIONS.REPORTS_READ,
    PERMISSIONS.NOTIFICATIONS_READ,
  ],
};

export function hasPermission(role: string, permission: Permission): boolean {
  const permissions = ROLE_PERMISSIONS[role] || [];
  return permissions.includes(permission);
}

export function requirePermission(role: string, permission: Permission): void {
  if (!hasPermission(role, permission)) {
    throw new AuthorizationError(`Permission required: ${permission}`);
  }
}