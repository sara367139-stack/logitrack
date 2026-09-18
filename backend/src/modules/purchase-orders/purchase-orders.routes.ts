import { Router } from 'express';
import { purchaseOrdersController } from './purchase-orders.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateBody, validateParams, validateQuery } from '../../common/validation/middleware';
import { paginationSchema, purchaseOrderSchema, objectIdSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

router.get('/', requirePermission(PERMISSIONS.PURCHASE_ORDERS_READ), validateQuery(paginationSchema), purchaseOrdersController.getPurchaseOrders);
router.post('/', requirePermission(PERMISSIONS.PURCHASE_ORDERS_MANAGE), validateBody(purchaseOrderSchema), purchaseOrdersController.createPurchaseOrder);
router.get('/:id', requirePermission(PERMISSIONS.PURCHASE_ORDERS_READ), validateParams(objectIdSchema), purchaseOrdersController.getPurchaseOrderById);
router.patch('/:id', requirePermission(PERMISSIONS.PURCHASE_ORDERS_MANAGE), validateParams(objectIdSchema), validateBody(purchaseOrderSchema), purchaseOrdersController.updatePurchaseOrder);
router.post('/:id/submit', requirePermission(PERMISSIONS.PURCHASE_ORDERS_MANAGE), validateParams(objectIdSchema), purchaseOrdersController.submitPurchaseOrder);
router.post('/:id/approve', requirePermission(PERMISSIONS.PURCHASE_ORDERS_MANAGE), validateParams(objectIdSchema), purchaseOrdersController.approvePurchaseOrder);
router.post('/:id/cancel', requirePermission(PERMISSIONS.PURCHASE_ORDERS_MANAGE), validateParams(objectIdSchema), purchaseOrdersController.cancelPurchaseOrder);
router.post('/:id/receive', requirePermission(PERMISSIONS.INVENTORY_RECEIVE), validateParams(objectIdSchema), purchaseOrdersController.receivePurchaseOrder);

export default router;