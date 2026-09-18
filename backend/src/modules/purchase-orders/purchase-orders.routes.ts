import { Router } from 'express';
import { purchaseOrdersController } from './purchase-orders.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateBody, validateParams, validateQuery } from '../../common/validation/middleware';
import { paginationSchema, purchaseOrderSchema, objectIdSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

/**
 * @swagger
 * /api/v1/purchase-orders:
 *   get:
 *     tags: [Purchase Orders]
 *     summary: List purchase orders
 *     description: Returns a paginated purchase order list.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }, { $ref: '#/components/parameters/Search' }]
 *     responses:
 *       200: { description: Purchase orders returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 *   post:
 *     tags: [Purchase Orders]
 *     summary: Create a purchase order
 *     description: Creates a draft purchase order with line items.
 *     security: [{ bearerAuth: [] }]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/PurchaseOrderRequest' }
 *     responses:
 *       201: { description: Purchase order created, content: { application/json: { schema: { $ref: '#/components/schemas/PurchaseOrder' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/', requirePermission(PERMISSIONS.PURCHASE_ORDERS_READ), validateQuery(paginationSchema), purchaseOrdersController.getPurchaseOrders);
router.post('/', requirePermission(PERMISSIONS.PURCHASE_ORDERS_MANAGE), validateBody(purchaseOrderSchema), purchaseOrdersController.createPurchaseOrder);

/**
 * @swagger
 * /api/v1/purchase-orders/{id}:
 *   get:
 *     tags: [Purchase Orders]
 *     summary: Get a purchase order
 *     description: Returns a purchase order and its items.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     responses:
 *       200: { description: Purchase order returned, content: { application/json: { schema: { $ref: '#/components/schemas/PurchaseOrder' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 *   patch:
 *     tags: [Purchase Orders]
 *     summary: Update a purchase order
 *     description: Updates an editable purchase order.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/PurchaseOrderRequest' }
 *     responses:
 *       200: { description: Purchase order updated, content: { application/json: { schema: { $ref: '#/components/schemas/PurchaseOrder' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/:id', requirePermission(PERMISSIONS.PURCHASE_ORDERS_READ), validateParams(objectIdSchema), purchaseOrdersController.getPurchaseOrderById);
router.patch('/:id', requirePermission(PERMISSIONS.PURCHASE_ORDERS_MANAGE), validateParams(objectIdSchema), validateBody(purchaseOrderSchema), purchaseOrdersController.updatePurchaseOrder);

/**
 * @swagger
 * /api/v1/purchase-orders/{id}/submit:
 *   post:
 *     tags: [Purchase Orders]
 *     summary: Submit a purchase order
 *     description: Moves a draft purchase order to submitted status.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     responses:
 *       200: { description: Purchase order submitted, content: { application/json: { schema: { $ref: '#/components/schemas/PurchaseOrder' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.post('/:id/submit', requirePermission(PERMISSIONS.PURCHASE_ORDERS_MANAGE), validateParams(objectIdSchema), purchaseOrdersController.submitPurchaseOrder);

/**
 * @swagger
 * /api/v1/purchase-orders/{id}/approve:
 *   post:
 *     tags: [Purchase Orders]
 *     summary: Approve a purchase order
 *     description: Approves a submitted purchase order.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     responses:
 *       200: { description: Purchase order approved, content: { application/json: { schema: { $ref: '#/components/schemas/PurchaseOrder' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.post('/:id/approve', requirePermission(PERMISSIONS.PURCHASE_ORDERS_MANAGE), validateParams(objectIdSchema), purchaseOrdersController.approvePurchaseOrder);

/**
 * @swagger
 * /api/v1/purchase-orders/{id}/cancel:
 *   post:
 *     tags: [Purchase Orders]
 *     summary: Cancel a purchase order
 *     description: Cancels a purchase order that has not been fully received.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     responses:
 *       200: { description: Purchase order cancelled, content: { application/json: { schema: { $ref: '#/components/schemas/PurchaseOrder' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.post('/:id/cancel', requirePermission(PERMISSIONS.PURCHASE_ORDERS_MANAGE), validateParams(objectIdSchema), purchaseOrdersController.cancelPurchaseOrder);

/**
 * @swagger
 * /api/v1/purchase-orders/{id}/receive:
 *   post:
 *     tags: [Purchase Orders]
 *     summary: Receive a purchase order
 *     description: Records received line items into a warehouse location.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/ReceivePurchaseOrderRequest' }
 *     responses:
 *       200: { description: Receipt recorded, content: { application/json: { schema: { $ref: '#/components/schemas/PurchaseOrder' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.post('/:id/receive', requirePermission(PERMISSIONS.INVENTORY_RECEIVE), validateParams(objectIdSchema), purchaseOrdersController.receivePurchaseOrder);

export default router;