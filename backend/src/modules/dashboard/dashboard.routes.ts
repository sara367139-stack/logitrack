import { Router } from 'express';
import { dashboardController } from './dashboard.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

router.get('/summary', requirePermission(PERMISSIONS.INVENTORY_READ), dashboardController.getSummary);
router.get('/activity', requirePermission(PERMISSIONS.INVENTORY_READ), dashboardController.getActivity);
router.get('/stock-alerts', requirePermission(PERMISSIONS.INVENTORY_READ), dashboardController.getStockAlerts);

export default router;