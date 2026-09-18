import { Router } from 'express';
import { inventoryController } from './inventory.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateBody, validateParams, validateQuery } from '../../common/validation/middleware';
import { paginationSchema, moveInventorySchema, dispatchInventorySchema, adjustInventorySchema, objectIdSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

/**
 * @swagger
 * /api/v1/inventory:
 *   get:
 *     tags: [Inventory]
 *     summary: List inventory balances
 *     description: Returns paginated inventory balances with optional product and location filters.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }, { $ref: '#/components/parameters/Search' }]
 *     responses:
 *       200: { description: Inventory returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/', requirePermission(PERMISSIONS.INVENTORY_READ), validateQuery(paginationSchema), inventoryController.getInventory);

/**
 * @swagger
 * /api/v1/inventory/low-stock:
 *   get:
 *     tags: [Inventory]
 *     summary: List low-stock inventory
 *     description: Returns products below their reorder threshold.
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Low-stock inventory returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/low-stock', requirePermission(PERMISSIONS.INVENTORY_READ), inventoryController.getLowStock);

/**
 * @swagger
 * /api/v1/inventory/product/{productId}:
 *   get:
 *     tags: [Inventory]
 *     summary: Get inventory for a product
 *     description: Returns aggregate quantities and location balances for a product.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/ProductId' }]
 *     responses:
 *       200: { description: Product inventory returned, content: { application/json: { schema: { $ref: '#/components/schemas/InventoryBalance' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/product/:productId', requirePermission(PERMISSIONS.INVENTORY_READ), validateParams(objectIdSchema), inventoryController.getInventoryByProduct);

/**
 * @swagger
 * /api/v1/inventory/location/{locationId}:
 *   get:
 *     tags: [Inventory]
 *     summary: List inventory at a location
 *     description: Returns paginated inventory balances for a location.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/LocationId' }, { $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }]
 *     responses:
 *       200: { description: Location inventory returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/location/:locationId', requirePermission(PERMISSIONS.INVENTORY_READ), validateParams(objectIdSchema), validateQuery(paginationSchema), inventoryController.getInventoryByLocation);

/**
 * @swagger
 * /api/v1/inventory/move:
 *   post:
 *     tags: [Inventory]
 *     summary: Move inventory
 *     description: Moves stock between warehouse locations.
 *     security: [{ bearerAuth: [] }]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/MoveInventoryRequest' }
 *     responses:
 *       200: { description: Stock moved, content: { application/json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.post('/move', requirePermission(PERMISSIONS.INVENTORY_MOVE), validateBody(moveInventorySchema), inventoryController.moveInventory);

/**
 * @swagger
 * /api/v1/inventory/dispatch:
 *   post:
 *     tags: [Inventory]
 *     summary: Dispatch inventory
 *     description: Removes stock from a location for dispatch.
 *     security: [{ bearerAuth: [] }]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/DispatchInventoryRequest' }
 *     responses:
 *       200: { description: Stock dispatched, content: { application/json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.post('/dispatch', requirePermission(PERMISSIONS.INVENTORY_DISPATCH), validateBody(dispatchInventorySchema), inventoryController.dispatchInventory);

/**
 * @swagger
 * /api/v1/inventory/adjust:
 *   post:
 *     tags: [Inventory]
 *     summary: Adjust inventory
 *     description: Sets the counted quantity for a product at a location.
 *     security: [{ bearerAuth: [] }]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/AdjustInventoryRequest' }
 *     responses:
 *       200: { description: Inventory adjusted, content: { application/json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.post('/adjust', requirePermission(PERMISSIONS.INVENTORY_ADJUST), validateBody(adjustInventorySchema), inventoryController.adjustInventory);

/**
 * @swagger
 * /api/v1/inventory/transactions:
 *   get:
 *     tags: [Inventory]
 *     summary: List inventory transactions
 *     description: Returns a paginated inventory movement history.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }, { $ref: '#/components/parameters/Search' }]
 *     responses:
 *       200: { description: Transactions returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/transactions', requirePermission(PERMISSIONS.INVENTORY_READ), validateQuery(paginationSchema), inventoryController.getTransactionHistory);

export default router;