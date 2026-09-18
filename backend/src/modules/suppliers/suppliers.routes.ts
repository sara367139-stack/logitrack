import { Router } from 'express';
import { suppliersController } from './suppliers.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateBody, validateParams, validateQuery } from '../../common/validation/middleware';
import { paginationSchema, supplierSchema, objectIdSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

/**
 * @swagger
 * /api/v1/suppliers:
 *   get:
 *     tags: [Suppliers]
 *     summary: List suppliers
 *     description: Returns a paginated list of suppliers.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }, { $ref: '#/components/parameters/Search' }]
 *     responses:
 *       200: { description: Suppliers returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 *   post:
 *     tags: [Suppliers]
 *     summary: Create a supplier
 *     description: Adds a supplier to the tenant catalog.
 *     security: [{ bearerAuth: [] }]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/SupplierRequest' }
 *     responses:
 *       201: { description: Supplier created, content: { application/json: { schema: { $ref: '#/components/schemas/Supplier' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/', requirePermission(PERMISSIONS.SUPPLIERS_READ), validateQuery(paginationSchema), suppliersController.getSuppliers);
router.post('/', requirePermission(PERMISSIONS.SUPPLIERS_MANAGE), validateBody(supplierSchema), suppliersController.createSupplier);

/**
 * @swagger
 * /api/v1/suppliers/{id}:
 *   get:
 *     tags: [Suppliers]
 *     summary: Get a supplier
 *     description: Returns one supplier by ID.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     responses:
 *       200: { description: Supplier returned, content: { application/json: { schema: { $ref: '#/components/schemas/Supplier' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 *   patch:
 *     tags: [Suppliers]
 *     summary: Update a supplier
 *     description: Updates supplier details.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/SupplierRequest' }
 *     responses:
 *       200: { description: Supplier updated, content: { application/json: { schema: { $ref: '#/components/schemas/Supplier' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 *   delete:
 *     tags: [Suppliers]
 *     summary: Delete a supplier
 *     description: Deactivates a supplier.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     responses:
 *       200: { description: Supplier deleted, content: { application/json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/:id', requirePermission(PERMISSIONS.SUPPLIERS_READ), validateParams(objectIdSchema), suppliersController.getSupplierById);
router.patch('/:id', requirePermission(PERMISSIONS.SUPPLIERS_MANAGE), validateParams(objectIdSchema), validateBody(supplierSchema), suppliersController.updateSupplier);
router.delete('/:id', requirePermission(PERMISSIONS.SUPPLIERS_MANAGE), validateParams(objectIdSchema), suppliersController.deleteSupplier);

/**
 * @swagger
 * /api/v1/suppliers/{id}/purchase-orders:
 *   get:
 *     tags: [Suppliers]
 *     summary: List supplier purchase orders
 *     description: Returns purchase orders for a supplier.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }, { $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }]
 *     responses:
 *       200: { description: Purchase orders returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/:id/purchase-orders', requirePermission(PERMISSIONS.PURCHASE_ORDERS_READ), validateParams(objectIdSchema), validateQuery(paginationSchema), suppliersController.getSupplierPurchaseOrders);

export default router;