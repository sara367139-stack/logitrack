import { Router } from 'express';
import { productsController } from './products.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateBody, validateParams, validateQuery } from '../../common/validation/middleware';
import { paginationSchema, productSchema, objectIdSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

/**
 * @swagger
 * /api/v1/products:
 *   get:
 *     tags: [Products]
 *     summary: List products
 *     description: Returns a paginated product catalog.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }, { $ref: '#/components/parameters/Search' }]
 *     responses:
 *       200: { description: Products returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 *   post:
 *     tags: [Products]
 *     summary: Create a product
 *     description: Adds a product to the tenant catalog.
 *     security: [{ bearerAuth: [] }]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/ProductRequest' }
 *     responses:
 *       201: { description: Product created, content: { application/json: { schema: { $ref: '#/components/schemas/Product' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/', requirePermission(PERMISSIONS.PRODUCTS_READ), validateQuery(paginationSchema), productsController.getProducts);
router.post('/', requirePermission(PERMISSIONS.PRODUCTS_MANAGE), validateBody(productSchema), productsController.createProduct);

/**
 * @swagger
 * /api/v1/products/low-stock:
 *   get:
 *     tags: [Products]
 *     summary: List low-stock products
 *     description: Returns products at or below their reorder level.
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Low-stock products returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/low-stock', requirePermission(PERMISSIONS.INVENTORY_READ), productsController.getLowStockProducts);

/**
 * @swagger
 * /api/v1/products/by-barcode/{barcode}:
 *   get:
 *     tags: [Products]
 *     summary: Find a product by barcode
 *     description: Returns product details and stock locations for a barcode.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Barcode' }]
 *     responses:
 *       200: { description: Product returned, content: { application/json: { schema: { $ref: '#/components/schemas/ProductWithStock' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/by-barcode/:barcode', requirePermission(PERMISSIONS.PRODUCTS_READ), validateParams(objectIdSchema), productsController.getProductByBarcode);

/**
 * @swagger
 * /api/v1/products/{id}:
 *   get:
 *     tags: [Products]
 *     summary: Get a product
 *     description: Returns a product by ID.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     responses:
 *       200: { description: Product returned, content: { application/json: { schema: { $ref: '#/components/schemas/Product' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 *   patch:
 *     tags: [Products]
 *     summary: Update a product
 *     description: Updates product catalog fields.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/ProductRequest' }
 *     responses:
 *       200: { description: Product updated, content: { application/json: { schema: { $ref: '#/components/schemas/Product' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 *   delete:
 *     tags: [Products]
 *     summary: Deactivate a product
 *     description: Marks a product inactive without removing its history.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     responses:
 *       200: { description: Product deactivated, content: { application/json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/:id', requirePermission(PERMISSIONS.PRODUCTS_READ), validateParams(objectIdSchema), productsController.getProductById);
router.patch('/:id', requirePermission(PERMISSIONS.PRODUCTS_MANAGE), validateParams(objectIdSchema), validateBody(productSchema), productsController.updateProduct);
router.delete('/:id', requirePermission(PERMISSIONS.PRODUCTS_MANAGE), validateParams(objectIdSchema), productsController.deleteProduct);

/**
 * @swagger
 * /api/v1/products/{id}/stock:
 *   get:
 *     tags: [Products]
 *     summary: Get product stock
 *     description: Returns aggregate stock and quantities by location.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     responses:
 *       200: { description: Stock returned, content: { application/json: { schema: { $ref: '#/components/schemas/InventoryBalance' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/:id/stock', requirePermission(PERMISSIONS.INVENTORY_READ), validateParams(objectIdSchema), productsController.getProductStock);

export default router;