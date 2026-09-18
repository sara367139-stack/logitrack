import { Router } from 'express';
import { inventoryController } from './inventory.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateBody, validateParams, validateQuery } from '../../common/validation/middleware';
import { paginationSchema, moveInventorySchema, dispatchInventorySchema, adjustInventorySchema, objectIdSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

router.get('/', requirePermission(PERMISSIONS.INVENTORY_READ), validateQuery(paginationSchema), inventoryController.getInventory);
router.get('/low-stock', requirePermission(PERMISSIONS.INVENTORY_READ), inventoryController.getLowStock);
router.get('/product/:productId', requirePermission(PERMISSIONS.INVENTORY_READ), validateParams(objectIdSchema), inventoryController.getInventoryByProduct);
router.get('/location/:locationId', requirePermission(PERMISSIONS.INVENTORY_READ), validateParams(objectIdSchema), validateQuery(paginationSchema), inventoryController.getInventoryByLocation);
router.post('/move', requirePermission(PERMISSIONS.INVENTORY_MOVE), validateBody(moveInventorySchema), inventoryController.moveInventory);
router.post('/dispatch', requirePermission(PERMISSIONS.INVENTORY_DISPATCH), validateBody(dispatchInventorySchema), inventoryController.dispatchInventory);
router.post('/adjust', requirePermission(PERMISSIONS.INVENTORY_ADJUST), validateBody(adjustInventorySchema), inventoryController.adjustInventory);
router.get('/transactions', requirePermission(PERMISSIONS.INVENTORY_READ), validateQuery(paginationSchema), inventoryController.getTransactionHistory);

export default router;