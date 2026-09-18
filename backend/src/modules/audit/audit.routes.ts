import { Router } from 'express';
import { auditController } from './audit.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateQuery } from '../../common/validation/middleware';
import { paginationSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

router.get('/', requirePermission(PERMISSIONS.USERS_READ), validateQuery(paginationSchema), auditController.getAuditLogs);

export default router;