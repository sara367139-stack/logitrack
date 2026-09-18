import { Router } from 'express';
import { auditController } from './audit.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateQuery } from '../../common/validation/middleware';
import { paginationSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

/**
 * @swagger
 * /api/v1/audit:
 *   get:
 *     tags: [Audit]
 *     summary: List audit logs
 *     description: Returns a paginated audit history for the tenant.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }, { $ref: '#/components/parameters/Search' }, { name: entityType, in: query, schema: { type: string } }, { name: action, in: query, schema: { type: string } }, { name: userId, in: query, schema: { type: string, format: uuid } }, { name: fromDate, in: query, schema: { type: string, format: date-time } }, { name: toDate, in: query, schema: { type: string, format: date-time } }]
 *     responses:
 *       200: { description: Audit logs returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/', requirePermission(PERMISSIONS.USERS_READ), validateQuery(paginationSchema), auditController.getAuditLogs);

export default router;