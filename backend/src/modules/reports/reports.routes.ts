import { Router } from 'express';
import { reportsController } from './reports.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateQuery } from '../../common/validation/middleware';
import { paginationSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

/**
 * @swagger
 * /api/v1/reports/inventory-value:
 *   get:
 *     tags: [Reports]
 *     summary: Get inventory value report
 *     description: Calculates inventory value for an optional date range.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/From' }, { $ref: '#/components/parameters/To' }]
 *     responses:
 *       200: { description: Report returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/inventory-value', requirePermission(PERMISSIONS.REPORTS_READ), reportsController.getInventoryValue);

/**
 * @swagger
 * /api/v1/reports/stock-movement:
 *   get:
 *     tags: [Reports]
 *     summary: Get stock movement report
 *     description: Returns stock movement grouped for an optional date range.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/From' }, { $ref: '#/components/parameters/To' }]
 *     responses:
 *       200: { description: Report returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/stock-movement', requirePermission(PERMISSIONS.REPORTS_READ), reportsController.getStockMovement);

/**
 * @swagger
 * /api/v1/reports/receiving:
 *   get:
 *     tags: [Reports]
 *     summary: Get receiving report
 *     description: Returns receiving activity grouped for an optional date range.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/From' }, { $ref: '#/components/parameters/To' }]
 *     responses:
 *       200: { description: Report returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/receiving', requirePermission(PERMISSIONS.REPORTS_READ), reportsController.getReceivingReport);

/**
 * @swagger
 * /api/v1/reports/dispatch:
 *   get:
 *     tags: [Reports]
 *     summary: Get dispatch report
 *     description: Returns dispatch activity grouped for an optional date range.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/From' }, { $ref: '#/components/parameters/To' }]
 *     responses:
 *       200: { description: Report returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/dispatch', requirePermission(PERMISSIONS.REPORTS_READ), reportsController.getDispatchReport);

/**
 * @swagger
 * /api/v1/reports/slow-moving:
 *   get:
 *     tags: [Reports]
 *     summary: Get slow-moving products report
 *     description: Returns products with low movement over a configurable period.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ name: days, in: query, schema: { type: integer, minimum: 1, default: 90 } }]
 *     responses:
 *       200: { description: Report returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/slow-moving', requirePermission(PERMISSIONS.REPORTS_READ), reportsController.getSlowMoving);

/**
 * @swagger
 * /api/v1/reports/export.csv:
 *   get:
 *     tags: [Reports]
 *     summary: Export inventory as CSV
 *     description: Downloads the inventory report as a CSV attachment.
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { $ref: '#/components/responses/CsvResponse' }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/export.csv', requirePermission(PERMISSIONS.REPORTS_READ), reportsController.exportInventoryCSV);

export default router;