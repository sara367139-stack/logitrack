import { Router } from 'express';
import { warehousesController } from './warehouses.controller';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { validateBody, validateParams, validateQuery } from '../../common/validation/middleware';
import { paginationSchema, warehouseSchema, locationSchema, objectIdSchema } from '../../common/validation';
import { PERMISSIONS } from '../../common/auth';

const router = Router();

router.use(authMiddleware);
router.use(attachUserDoc);

router.get('/', requirePermission(PERMISSIONS.WAREHOUSES_READ), validateQuery(paginationSchema), warehousesController.getWarehouses);
router.post('/', requirePermission(PERMISSIONS.WAREHOUSES_MANAGE), validateBody(warehouseSchema), warehousesController.createWarehouse);
router.get('/:id', requirePermission(PERMISSIONS.WAREHOUSES_READ), validateParams(objectIdSchema), warehousesController.getWarehouseById);
router.patch('/:id', requirePermission(PERMISSIONS.WAREHOUSES_MANAGE), validateParams(objectIdSchema), validateBody(warehouseSchema), warehousesController.updateWarehouse);

router.get('/:id/locations', requirePermission(PERMISSIONS.WAREHOUSES_READ), validateParams(objectIdSchema), validateQuery(paginationSchema), warehousesController.getLocations);
router.post('/:id/locations', requirePermission(PERMISSIONS.WAREHOUSES_MANAGE), validateParams(objectIdSchema), validateBody(locationSchema), warehousesController.createLocation);
router.patch('/locations/:locationId', requirePermission(PERMISSIONS.WAREHOUSES_MANAGE), validateParams(objectIdSchema), validateBody(locationSchema), warehousesController.updateLocation);
router.delete('/locations/:locationId', requirePermission(PERMISSIONS.WAREHOUSES_MANAGE), validateParams(objectIdSchema), warehousesController.deleteLocation);

export default router;