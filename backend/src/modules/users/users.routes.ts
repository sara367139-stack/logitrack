import { Router } from 'express';
import { usersController } from './users.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateBody, validateParams, validateQuery } from '../../common/validation/middleware';
import { paginationSchema, userInviteSchema, updateUserRoleSchema, objectIdSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

router.get('/', requirePermission(PERMISSIONS.USERS_READ), validateQuery(paginationSchema), usersController.getUsers);
router.get('/:id', requirePermission(PERMISSIONS.USERS_READ), validateParams(objectIdSchema), usersController.getUserById);
router.post('/invite', requirePermission(PERMISSIONS.USERS_MANAGE), validateBody(userInviteSchema), usersController.inviteUser);
router.patch('/:id/role', requirePermission(PERMISSIONS.USERS_MANAGE), validateParams(objectIdSchema), validateBody(updateUserRoleSchema), usersController.updateUserRole);
router.patch('/:id/deactivate', requirePermission(PERMISSIONS.USERS_MANAGE), validateParams(objectIdSchema), usersController.deactivateUser);

export default router;