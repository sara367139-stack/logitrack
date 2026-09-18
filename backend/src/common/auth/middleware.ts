import { Request, Response, NextFunction } from 'express';
import { verifyAccessToken, JwtPayload } from '../../common/auth';
import { AuthenticationError, AuthorizationError } from '../../common/errors';
import { User, IUser } from '../../models';

declare global {
  namespace Express {
    interface Request {
      user?: JwtPayload & { userDoc?: IUser };
      tenantId?: string;
    }
  }
}

export function authMiddleware(
  req: Request,
  res: Response,
  next: NextFunction
): void {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new AuthenticationError('Authorization header required');
    }

    const token = authHeader.substring(7);
    const payload = verifyAccessToken(token);
    
    req.user = payload;
    req.tenantId = payload.tenantId;
    
    next();
  } catch (error) {
    next(error);
  }
}

export function optionalAuthMiddleware(
  req: Request,
  res: Response,
  next: NextFunction
): void {
  try {
    const authHeader = req.headers.authorization;
    
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.substring(7);
      const payload = verifyAccessToken(token);
      req.user = payload;
      req.tenantId = payload.tenantId;
    }
    
    next();
  } catch (error) {
    next();
  }
}

export function requireRole(...allowedRoles: string[]) {
  return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    if (!req.user) {
      throw new AuthenticationError('Authentication required');
    }

    if (!allowedRoles.includes(req.user.role)) {
      throw new AuthorizationError(`Role ${req.user.role} not authorized`);
    }

    next();
  };
}

export function requirePermission(permission: string) {
  return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    if (!req.user) {
      throw new AuthenticationError('Authentication required');
    }

    const { hasPermission } = await import('../../common/auth');
    
    if (!hasPermission(req.user.role, permission as any)) {
      throw new AuthorizationError(`Permission required: ${permission}`);
    }

    next();
  };
}

export async function attachUserDoc(
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> {
  if (req.user) {
    const user = await User.findById(req.user.userId).select('-passwordHash');
    if (user && user.isActive) {
      req.user.userDoc = user;
    } else if (user && !user.isActive) {
      throw new AuthenticationError('Account deactivated');
    }
  }
  next();
}

export function tenantMiddleware(
  req: Request,
  res: Response,
  next: NextFunction
): void {
  if (!req.tenantId) {
    throw new AuthenticationError('Tenant context required');
  }
  next();
}