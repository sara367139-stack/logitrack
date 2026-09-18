import { Router } from 'express';
import { productsController } from './products.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateBody, validateParams, validateQuery } from '../../common/validation/middleware';
import { paginationSchema, productSchema, objectIdSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

router.get('/', requirePermission(PERMISSIONS.PRODUCTS_READ), validateQuery(paginationSchema), productsController.getProducts);
router.get('/low-stock', requirePermission(PERMISSIONS.INVENTORY_READ), productsController.getLowStockProducts);
router.get('/by-barcode/:barcode', requirePermission(PERMISSIONS.PRODUCTS_READ), validateParams(objectIdSchema), productsController.getProductByBarcode);
router.post('/', requirePermission(PERMISSIONS.PRODUCTS_MANAGE), validateBody(productSchema), productsController.createProduct);
router.get('/:id', requirePermission(PERMISSIONS.PRODUCTS_READ), validateParams(objectIdSchema), productsController.getProductById);
router.patch('/:id', requirePermission(PERMISSIONS.PRODUCTS_MANAGE), validateParams(objectIdSchema), validateBody(productSchema), productsController.updateProduct);
router.delete('/:id', requirePermission(PERMISSIONS.PRODUCTS_MANAGE), validateParams(objectIdSchema), productsController.deleteProduct);
router.get('/:id/stock', requirePermission(PERMISSIONS.INVENTORY_READ), validateParams(objectIdSchema), productsController.getProductStock);

export default router;