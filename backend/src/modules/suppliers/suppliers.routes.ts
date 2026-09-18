import { Router } from 'express';
import { suppliersController } from './suppliers.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateBody, validateParams, validateQuery } from '../../common/validation/middleware';
import { paginationSchema, supplierSchema, objectIdSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

router.get('/', requirePermission(PERMISSIONS.SUPPLIERS_READ), validateQuery(paginationSchema), suppliersController.getSuppliers);
router.post('/', requirePermission(PERMISSIONS.SUPPLIERS_MANAGE), validateBody(supplierSchema), suppliersController.createSupplier);
router.get('/:id', requirePermission(PERMISSIONS.SUPPLIERS_READ), validateParams(objectIdSchema), suppliersController.getSupplierById);
router.patch('/:id', requirePermission(PERMISSIONS.SUPPLIERS_MANAGE), validateParams(objectIdSchema), validateBody(supplierSchema), suppliersController.updateSupplier);
router.delete('/:id', requirePermission(PERMISSIONS.SUPPLIERS_MANAGE), validateParams(objectIdSchema), suppliersController.deleteSupplier);
router.get('/:id/purchase-orders', requirePermission(PERMISSIONS.PURCHASE_ORDERS_READ), validateParams(objectIdSchema), validateQuery(paginationSchema), suppliersController.getSupplierPurchaseOrders);

export default router;