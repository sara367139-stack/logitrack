import { Router } from 'express';
import { notificationsController } from './notifications.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateParams, validateQuery } from '../../common/validation/middleware';
import { paginationSchema, objectIdSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

router.get('/', requirePermission(PERMISSIONS.NOTIFICATIONS_READ), validateQuery(paginationSchema), notificationsController.getNotifications);
router.patch('/:id/read', requirePermission(PERMISSIONS.NOTIFICATIONS_READ), validateParams(objectIdSchema), notificationsController.markAsRead);
router.post('/read-all', requirePermission(PERMISSIONS.NOTIFICATIONS_READ), notificationsController.markAllAsRead);

export default router;