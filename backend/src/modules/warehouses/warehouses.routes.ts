import { Router } from 'express';
import { warehousesController } from './warehouses.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateBody, validateParams, validateQuery } from '../../common/validation/middleware';
import { paginationSchema, warehouseSchema, locationSchema, objectIdSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

/**
 * @swagger
 * /api/v1/warehouses:
 *   get:
 *     tags: [Warehouses]
 *     summary: List warehouses
 *     description: Returns a paginated list of warehouses.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }, { $ref: '#/components/parameters/Search' }]
 *     responses:
 *       200: { description: Warehouses returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 *   post:
 *     tags: [Warehouses]
 *     summary: Create a warehouse
 *     description: Creates an active warehouse for the tenant.
 *     security: [{ bearerAuth: [] }]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/WarehouseRequest' }
 *     responses:
 *       201: { description: Warehouse created, content: { application/json: { schema: { $ref: '#/components/schemas/Warehouse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/', requirePermission(PERMISSIONS.WAREHOUSES_READ), validateQuery(paginationSchema), warehousesController.getWarehouses);
router.post('/', requirePermission(PERMISSIONS.WAREHOUSES_MANAGE), validateBody(warehouseSchema), warehousesController.createWarehouse);

/**
 * @swagger
 * /api/v1/warehouses/{id}:
 *   get:
 *     tags: [Warehouses]
 *     summary: Get a warehouse
 *     description: Returns one warehouse by ID.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     responses:
 *       200: { description: Warehouse returned, content: { application/json: { schema: { $ref: '#/components/schemas/Warehouse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 *   patch:
 *     tags: [Warehouses]
 *     summary: Update a warehouse
 *     description: Updates warehouse details.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/WarehouseRequest' }
 *     responses:
 *       200: { description: Warehouse updated, content: { application/json: { schema: { $ref: '#/components/schemas/Warehouse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/:id', requirePermission(PERMISSIONS.WAREHOUSES_READ), validateParams(objectIdSchema), warehousesController.getWarehouseById);
router.patch('/:id', requirePermission(PERMISSIONS.WAREHOUSES_MANAGE), validateParams(objectIdSchema), validateBody(warehouseSchema), warehousesController.updateWarehouse);

/**
 * @swagger
 * /api/v1/warehouses/{id}/locations:
 *   get:
 *     tags: [Warehouses]
 *     summary: List warehouse locations
 *     description: Returns locations belonging to a warehouse.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }, { $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }]
 *     responses:
 *       200: { description: Locations returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 *   post:
 *     tags: [Warehouses]
 *     summary: Create a warehouse location
 *     description: Adds a location under a warehouse.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/LocationRequest' }
 *     responses:
 *       201: { description: Location created, content: { application/json: { schema: { $ref: '#/components/schemas/Location' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.get('/:id/locations', requirePermission(PERMISSIONS.WAREHOUSES_READ), validateParams(objectIdSchema), validateQuery(paginationSchema), warehousesController.getLocations);
router.post('/:id/locations', requirePermission(PERMISSIONS.WAREHOUSES_MANAGE), validateParams(objectIdSchema), validateBody(locationSchema), warehousesController.createLocation);

/**
 * @swagger
 * /api/v1/warehouses/locations/{locationId}:
 *   patch:
 *     tags: [Warehouses]
 *     summary: Update a location
 *     description: Updates warehouse location details.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/LocationId' }]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/LocationRequest' }
 *     responses:
 *       200: { description: Location updated, content: { application/json: { schema: { $ref: '#/components/schemas/Location' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 *   delete:
 *     tags: [Warehouses]
 *     summary: Delete a location
 *     description: Deactivates a warehouse location.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/LocationId' }]
 *     responses:
 *       200: { description: Location deleted, content: { application/json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
router.patch('/locations/:locationId', requirePermission(PERMISSIONS.WAREHOUSES_MANAGE), validateParams(objectIdSchema), validateBody(locationSchema), warehousesController.updateLocation);
router.delete('/locations/:locationId', requirePermission(PERMISSIONS.WAREHOUSES_MANAGE), validateParams(objectIdSchema), warehousesController.deleteLocation);

export default router;