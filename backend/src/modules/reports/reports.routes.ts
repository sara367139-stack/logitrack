import { Router } from 'express';
import { reportsController } from './reports.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateQuery } from '../../common/validation/middleware';
import { paginationSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

router.get('/inventory-value', requirePermission(PERMISSIONS.REPORTS_READ), reportsController.getInventoryValue);
router.get('/stock-movement', requirePermission(PERMISSIONS.REPORTS_READ), reportsController.getStockMovement);
router.get('/receiving', requirePermission(PERMISSIONS.REPORTS_READ), reportsController.getReceivingReport);
router.get('/dispatch', requirePermission(PERMISSIONS.REPORTS_READ), reportsController.getDispatchReport);
router.get('/slow-moving', requirePermission(PERMISSIONS.REPORTS_READ), reportsController.getSlowMoving);
router.get('/export.csv', requirePermission(PERMISSIONS.REPORTS_READ), reportsController.exportInventoryCSV);

export default router;