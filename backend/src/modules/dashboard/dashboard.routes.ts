import { Router } from 'express';
import { dashboardController } from './dashboard.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

/**
 * @swagger
 * /api/v1/dashboard/summary:
 *   get:
 *     tags: [Dashboard]
 *     summary: Get dashboard summary
 *     description: Returns the key inventory and order metrics for the tenant.
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Summary returned, content: { application/json: { schema: { $ref: '#/components/schemas/DashboardSummary' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/summary', requirePermission(PERMISSIONS.INVENTORY_READ), dashboardController.getSummary);

/**
 * @swagger
 * /api/v1/dashboard/activity:
 *   get:
 *     tags: [Dashboard]
 *     summary: Get recent activity
 *     description: Returns recent inventory and order activity.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ name: limit, in: query, schema: { type: integer, minimum: 1, default: 20 } }]
 *     responses:
 *       200: { description: Activity returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/activity', requirePermission(PERMISSIONS.INVENTORY_READ), dashboardController.getActivity);

/**
 * @swagger
 * /api/v1/dashboard/stock-alerts:
 *   get:
 *     tags: [Dashboard]
 *     summary: Get stock alerts
 *     description: Returns current low-stock alerts.
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Alerts returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/stock-alerts', requirePermission(PERMISSIONS.INVENTORY_READ), dashboardController.getStockAlerts);

export default router;