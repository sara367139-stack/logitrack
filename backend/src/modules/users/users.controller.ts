import { Request, Response, NextFunction } from 'express';
import { usersService } from './users.service';
import { PaginationParams } from '../../common/pagination';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { PERMISSIONS } from '../../common/auth';

export class UsersController {
  async getUsers(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await usersService.getUsers(
        req.tenantId!,
        req.query as unknown as PaginationParams,
        req.user!.role
      );
      res.json({ data: result.data, meta: result.meta });
    } catch (error) {
      next(error);
    }
  }

  async getUserById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const user = await usersService.getUserById(req.tenantId!, req.params.id);
      res.json({ data: user });
    } catch (error) {
      next(error);
    }
  }

  async inviteUser(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const user = await usersService.inviteUser(
        req.tenantId!,
        req.body,
        req.user!.role
      );
      res.status(201).json({ data: user });
    } catch (error) {
      next(error);
    }
  }

  async updateUserRole(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const user = await usersService.updateUserRole(
        req.tenantId!,
        req.params.id,
        req.body.role,
        req.user!.role,
        req.user!.userId
      );
      res.json({ data: user });
    } catch (error) {
      next(error);
    }
  }

  async deactivateUser(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      await usersService.deactivateUser(
        req.tenantId!,
        req.params.id,
        req.user!.role,
        req.user!.userId
      );
      res.json({ data: { message: 'User deactivated successfully' } });
    } catch (error) {
      next(error);
    }
  }
}

export const usersController = new UsersController();