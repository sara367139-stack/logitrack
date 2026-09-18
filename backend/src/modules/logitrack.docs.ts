/**
 * @swagger
 * components:
 *   schemas:
 *     MessageResponse:
 *       type: object
 *       properties:
 *         data:
 *           type: object
 *           properties:
 *             message: { type: string }
 *     RefreshTokenRequest:
 *       type: object
 *       required: [refreshToken]
 *       properties:
 *         refreshToken: { type: string }
 *     ForgotPasswordRequest:
 *       type: object
 *       required: [email]
 *       properties:
 *         email: { type: string, format: email }
 *     ResetPasswordRequest:
 *       type: object
 *       required: [token, password]
 *       properties:
 *         token: { type: string }
 *         password: { type: string, format: password, minLength: 8 }
 *     ProfileUpdateRequest:
 *       type: object
 *       properties:
 *         firstName: { type: string }
 *         lastName: { type: string }
 *         phone: { type: string }
 *     UserInviteRequest:
 *       type: object
 *       required: [email, firstName, lastName, role]
 *       properties:
 *         email: { type: string, format: email }
 *         firstName: { type: string }
 *         lastName: { type: string }
 *         role: { type: string, enum: [owner, admin, manager, operator, viewer] }
 *     UserRoleRequest:
 *       type: object
 *       required: [role]
 *       properties:
 *         role: { type: string, enum: [owner, admin, manager, operator, viewer] }
 *     WarehouseRequest:
 *       type: object
 *       required: [name, code]
 *       properties:
 *         name: { type: string }
 *         code: { type: string }
 *         addressLine1: { type: string }
 *         city: { type: string }
 *         country: { type: string }
 *     LocationRequest:
 *       type: object
 *       required: [warehouseId, name, code, type]
 *       properties:
 *         warehouseId: { type: string, format: uuid }
 *         parentId: { type: string, format: uuid }
 *         name: { type: string }
 *         code: { type: string }
 *         type: { type: string, enum: [receiving, zone, aisle, shelf, bin, dispatch] }
 *         capacity: { type: number }
 *     ProductRequest:
 *       type: object
 *       required: [sku, name]
 *       properties:
 *         sku: { type: string }
 *         barcode: { type: string }
 *         name: { type: string }
 *         description: { type: string }
 *         category: { type: string }
 *         unit: { type: string, default: unit }
 *         costPrice: { type: number, minimum: 0 }
 *         sellingPrice: { type: number, minimum: 0 }
 *         reorderLevel: { type: integer, minimum: 0 }
 *         reorderQuantity: { type: integer, minimum: 0 }
 *         imageUrl: { type: string, format: uri }
 *     SupplierRequest:
 *       type: object
 *       required: [name]
 *       properties:
 *         name: { type: string }
 *         contactName: { type: string }
 *         email: { type: string, format: email }
 *         phone: { type: string }
 *         address: { type: string }
 *     PurchaseOrderRequest:
 *       type: object
 *       required: [supplierId, warehouseId, orderNumber, items]
 *       properties:
 *         supplierId: { type: string, format: uuid }
 *         warehouseId: { type: string, format: uuid }
 *         orderNumber: { type: string }
 *         expectedDate: { type: string }
 *         notes: { type: string }
 *         items:
 *           type: array
 *           minItems: 1
 *           items:
 *             type: object
 *             required: [productId, orderedQuantity, unitCost]
 *             properties:
 *               productId: { type: string, format: uuid }
 *               orderedQuantity: { type: integer, minimum: 1 }
 *               unitCost: { type: number, minimum: 0 }
 *     MoveInventoryRequest:
 *       type: object
 *       required: [fromLocationId, toLocationId, items]
 *       properties:
 *         fromLocationId: { type: string, format: uuid }
 *         toLocationId: { type: string, format: uuid }
 *         items: { type: array, items: { type: object } }
 *         note: { type: string }
 *     DispatchInventoryRequest:
 *       type: object
 *       required: [locationId, items]
 *       properties:
 *         locationId: { type: string, format: uuid }
 *         items: { type: array, items: { type: object } }
 *         reference: { type: string }
 *     AdjustInventoryRequest:
 *       type: object
 *       required: [productId, locationId, newQuantity, reason]
 *       properties:
 *         productId: { type: string, format: uuid }
 *         locationId: { type: string, format: uuid }
 *         newQuantity: { type: integer, minimum: 0 }
 *         reason: { type: string }
 *     ReceivePurchaseOrderRequest:
 *       type: object
 *       required: [items, locationId]
 *       properties:
 *         items: { type: array, items: { type: object } }
 *         locationId: { type: string, format: uuid }
 *         note: { type: string }
 *   parameters:
 *     Id:
 *       name: id
 *       in: path
 *       required: true
 *       schema: { type: string, format: uuid }
 *     ProductId:
 *       name: productId
 *       in: path
 *       required: true
 *       schema: { type: string, format: uuid }
 *     LocationId:
 *       name: locationId
 *       in: path
 *       required: true
 *       schema: { type: string, format: uuid }
 *     Barcode:
 *       name: barcode
 *       in: path
 *       required: true
 *       schema: { type: string }
 *     Page:
 *       name: page
 *       in: query
 *       schema: { type: integer, minimum: 1, default: 1 }
 *     PageSize:
 *       name: pageSize
 *       in: query
 *       schema: { type: integer, minimum: 1, maximum: 100, default: 20 }
 *     Search:
 *       name: search
 *       in: query
 *       schema: { type: string }
 *     From:
 *       name: from
 *       in: query
 *       schema: { type: string, format: date }
 *     To:
 *       name: to
 *       in: query
 *       schema: { type: string, format: date }
 *   responses:
 *     StandardErrors:
 *       description: Standard API errors
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/Error' }
 *     CsvResponse:
 *       description: CSV export
 *       content:
 *         text/csv:
 *           schema: { type: string, format: binary }
 *
 * @swagger
 * /api/v1/auth/register:
 *   post:
 *     tags: [Authentication]
 *     summary: Register a company and owner
 *     description: Creates a tenant and its first owner account.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema: { $ref: '#/components/schemas/AuthRegisterRequest' }
 *     responses:
 *       201: { description: Registration successful, content: { application/json: { schema: { $ref: '#/components/schemas/AuthResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 */
 *
 * /api/v1 / notifications:
 * get:
 * tags: [Notifications]
   * summary: List notifications
      * description: Returns the authenticated user's paginated notifications.
         * security: [{ bearerAuth: [] }]
            * parameters: [{ $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }, { $ref: '#/components/parameters/Search' }]
               * responses:
 * 200: { description: Notifications returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / notifications / { id } / read:
 * patch:
 * tags: [Notifications]
   * summary: Mark a notification as read
      * description: Marks one notification as read for the authenticated user.
 * security: [{ bearerAuth: [] }]
      * parameters: [{ $ref: '#/components/parameters/Id' }]
         * responses:
 * 200: { description: Notification marked read, content: { application / json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / notifications / read - all:
 * post:
 * tags: [Notifications]
   * summary: Mark all notifications as read
      * description: Marks every notification for the authenticated user as read.
 * security: [{ bearerAuth: [] }]
      * responses:
 * 200: { description: Notifications marked read, content: { application / json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / audit:
 * get:
 * tags: [Audit]
   * summary: List audit logs
      * description: Returns a paginated audit history for the tenant.
 * security: [{ bearerAuth: [] }]
      * parameters: [{ $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }, { $ref: '#/components/parameters/Search' }, { name: entityType, in: query, schema: { type: string } }, { name: action, in: query, schema: { type: string } }, { name: userId, in: query, schema: { type: string, format: uuid } }, { name: fromDate, in: query, schema: { type: string, format: date - time } }, { name: toDate, in: query, schema: { type: string, format: date - time } }]
         * responses:
 * 200: { description: Audit logs returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 *
 * /api/v1 / dashboard / summary:
 * get:
 * tags: [Dashboard]
   * summary: Get dashboard summary
      * description: Returns the key inventory and order metrics for the tenant.
 * security: [{ bearerAuth: [] }]
      * responses:
 * 200: { description: Summary returned, content: { application / json: { schema: { $ref: '#/components/schemas/DashboardSummary' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / dashboard / activity:
 * get:
 * tags: [Dashboard]
   * summary: Get recent activity
      * description: Returns recent inventory and order activity.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ name: limit, in: query, schema: { type: integer, minimum: 1, default: 20 } }]
      * responses:
 * 200: { description: Activity returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / dashboard / stock - alerts:
 * get:
 * tags: [Dashboard]
   * summary: Get stock alerts
      * description: Returns current low - stock alerts.
 * security: [{ bearerAuth: [] }]
   * responses:
 * 200: { description: Alerts returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / reports / inventory - value:
 * get:
 * tags: [Reports]
   * summary: Get inventory value report
      * description: Calculates inventory value for an optional date range.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/From' }, { $ref: '#/components/parameters/To' }]
      * responses:
 * 200: { description: Report returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / reports / stock - movement:
 * get:
 * tags: [Reports]
   * summary: Get stock movement report
      * description: Returns stock movement grouped for an optional date range.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/From' }, { $ref: '#/components/parameters/To' }]
      * responses:
 * 200: { description: Report returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / reports / receiving:
 * get:
 * tags: [Reports]
   * summary: Get receiving report
      * description: Returns receiving activity grouped for an optional date range.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/From' }, { $ref: '#/components/parameters/To' }]
      * responses:
 * 200: { description: Report returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / reports / dispatch:
 * get:
 * tags: [Reports]
   * summary: Get dispatch report
      * description: Returns dispatch activity grouped for an optional date range.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/From' }, { $ref: '#/components/parameters/To' }]
      * responses:
 * 200: { description: Report returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / reports / slow - moving:
 * get:
 * tags: [Reports]
   * summary: Get slow - moving products report
      * description: Returns products with low movement over a configurable period.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ name: days, in: query, schema: { type: integer, minimum: 1, default: 90 } }]
      * responses:
 * 200: { description: Report returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / reports /export.csv:
 * get:
 * tags: [Reports]
   * summary: Export inventory as CSV
      * description: Downloads the inventory report as a CSV attachment.
 * security: [{ bearerAuth: [] }]
   * responses:
 * 200: { $ref: '#/components/responses/CsvResponse' }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / purchase - orders:
 * get:
 * tags: [Purchase Orders]
   * summary: List purchase orders
      * description: Returns a paginated purchase order list.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }, { $ref: '#/components/parameters/Search' }]
      * responses:
 * 200: { description: Purchase orders returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * post:
 * tags: [Purchase Orders]
   * summary: Create a purchase order
      * description: Creates a draft purchase order with line items.
 * security: [{ bearerAuth: [] }]
   * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/PurchaseOrderRequest' } } } }
 * responses:
 * 201: { description: Purchase order created, content: { application / json: { schema: { $ref: '#/components/schemas/PurchaseOrder' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / purchase - orders / { id }:
 * get:
 * tags: [Purchase Orders]
   * summary: Get a purchase order
      * description: Returns a purchase order and its items.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Id' }]
      * responses:
 * 200: { description: Purchase order returned, content: { application / json: { schema: { $ref: '#/components/schemas/PurchaseOrder' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * patch:
 * tags: [Purchase Orders]
   * summary: Update a purchase order
      * description: Updates an editable purchase order.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Id' }]
      * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/PurchaseOrderRequest' } } } }
 * responses:
 * 200: { description: Purchase order updated, content: { application / json: { schema: { $ref: '#/components/schemas/PurchaseOrder' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / purchase - orders / { id } / submit:
 * post:
 * tags: [Purchase Orders]
   * summary: Submit a purchase order
      * description: Moves a draft purchase order to submitted status.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Id' }]
      * responses:
 * 200: { description: Purchase order submitted, content: { application / json: { schema: { $ref: '#/components/schemas/PurchaseOrder' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / purchase - orders / { id } / approve:
 * post:
 * tags: [Purchase Orders]
   * summary: Approve a purchase order
      * description: Approves a submitted purchase order.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Id' }]
      * responses:
 * 200: { description: Purchase order approved, content: { application / json: { schema: { $ref: '#/components/schemas/PurchaseOrder' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / purchase - orders / { id } / cancel:
 * post:
 * tags: [Purchase Orders]
   * summary: Cancel a purchase order
      * description: Cancels a purchase order that has not been fully received.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Id' }]
      * responses:
 * 200: { description: Purchase order cancelled, content: { application / json: { schema: { $ref: '#/components/schemas/PurchaseOrder' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / purchase - orders / { id } / receive:
 * post:
 * tags: [Purchase Orders]
   * summary: Receive a purchase order
      * description: Records received line items into a warehouse location.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Id' }]
      * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/ReceivePurchaseOrderRequest' } } } }
 * responses:
 * 200: { description: Receipt recorded, content: { application / json: { schema: { $ref: '#/components/schemas/PurchaseOrder' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / inventory:
 * get:
 * tags: [Inventory]
   * summary: List inventory balances
      * description: Returns paginated inventory balances with optional product and location filters.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }, { $ref: '#/components/parameters/Search' }]
      * responses:
 * 200: { description: Inventory returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / inventory / low - stock:
 * get:
 * tags: [Inventory]
   * summary: List low - stock inventory
      * description: Returns products below their reorder threshold.
 * security: [{ bearerAuth: [] }]
   * responses:
 * 200: { description: Low - stock inventory returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / inventory / product / { productId }:
 * get:
 * tags: [Inventory]
   * summary: Get inventory for a product
      * description: Returns aggregate quantities and location balances for a product.
 * security: [{ bearerAuth: [] }]
      * parameters: [{ $ref: '#/components/parameters/ProductId' }]
         * responses:
 * 200: { description: Product inventory returned, content: { application / json: { schema: { $ref: '#/components/schemas/InventoryBalance' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / inventory / location / { locationId }:
 * get:
 * tags: [Inventory]
   * summary: List inventory at a location
      * description: Returns paginated inventory balances for a location.
 * security: [{ bearerAuth: [] }]
      * parameters: [{ $ref: '#/components/parameters/LocationId' }, { $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }]
         * responses:
 * 200: { description: Location inventory returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / inventory / move:
 * post:
 * tags: [Inventory]
   * summary: Move inventory
      * description: Moves stock between warehouse locations.
 * security: [{ bearerAuth: [] }]
   * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/MoveInventoryRequest' } } } }
 * responses:
 * 200: { description: Stock moved, content: { application / json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / inventory / dispatch:
 * post:
 * tags: [Inventory]
   * summary: Dispatch inventory
      * description: Removes stock from a location for dispatch.
 * security: [{ bearerAuth: [] }]
      * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/DispatchInventoryRequest' } } } }
 * responses:
 * 200: { description: Stock dispatched, content: { application / json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / inventory / adjust:
 * post:
 * tags: [Inventory]
   * summary: Adjust inventory
      * description: Sets the counted quantity for a product at a location.
 * security: [{ bearerAuth: [] }]
   * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/AdjustInventoryRequest' } } } }
 * responses:
 * 200: { description: Inventory adjusted, content: { application / json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / inventory / transactions:
 * get:
 * tags: [Inventory]
   * summary: List inventory transactions
      * description: Returns a paginated inventory movement history.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }, { $ref: '#/components/parameters/Search' }]
      * responses:
 * 200: { description: Transactions returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / auth / login:
 * post:
 * tags: [Authentication]
   * summary: Authenticate a user
      * description: Returns access and refresh tokens for valid credentials.
 * requestBody:
 * required: true
   * content:
 * application / json:
 * schema: { $ref: '#/components/schemas/AuthLoginRequest' }
 * responses:
 * 200: { description: Login successful, content: { application / json: { schema: { $ref: '#/components/schemas/AuthResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / auth / refresh:
 * post:
 * tags: [Authentication]
   * summary: Refresh access tokens
      * description: Exchanges a valid refresh token for a new token pair.
 * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/RefreshTokenRequest' } } } }
 * responses:
 * 200: { description: Tokens refreshed, content: { application / json: { schema: { $ref: '#/components/schemas/AuthResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / auth / logout:
 * post:
 * tags: [Authentication]
   * summary: Log out a user
      * description: Revokes the supplied refresh token.
 * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/RefreshTokenRequest' } } } }
 * responses:
 * 200: { description: Logout successful, content: { application / json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / auth / forgot - password:
 * post:
 * tags: [Authentication]
   * summary: Request a password reset
      * description: Sends a password reset instruction for the email address.
 * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/ForgotPasswordRequest' } } } }
 * responses:
 * 200: { description: Reset requested, content: { application / json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / auth / reset - password:
 * post:
 * tags: [Authentication]
   * summary: Reset a password
      * description: Sets a new password using a reset token.
 * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/ResetPasswordRequest' } } } }
 * responses:
 * 200: { description: Password reset, content: { application / json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / auth / me:
 * get:
 * tags: [Authentication]
   * summary: Get the current user
      * description: Returns the authenticated user's profile.
         * security: [{ bearerAuth: [] }]
            * responses:
 * 200: { description: Current user, content: { application / json: { schema: { $ref: '#/components/schemas/User' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / auth / me:
 * patch:
 * tags: [Authentication]
   * summary: Update the current user
      * description: Updates editable profile fields for the authenticated user.
 * security: [{ bearerAuth: [] }]
      * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/ProfileUpdateRequest' } } } }
 * responses:
 * 200: { description: User updated, content: { application / json: { schema: { $ref: '#/components/schemas/User' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / users:
 * get:
 * tags: [Users]
   * summary: List users
      * description: Returns a paginated list of tenant users.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }, { $ref: '#/components/parameters/Search' }]
      * responses:
 * 200: { description: Users returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / users / { id }:
 * get:
 * tags: [Users]
   * summary: Get a user
      * description: Returns one user by ID.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Id' }]
      * responses:
 * 200: { description: User returned, content: { application / json: { schema: { $ref: '#/components/schemas/User' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / users / invite:
 * post:
 * tags: [Users]
   * summary: Invite a user
      * description: Creates an invited user with a temporary password.
 * security: [{ bearerAuth: [] }]
   * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/UserInviteRequest' } } } }
 * responses:
 * 201: { description: User invited, content: { application / json: { schema: { $ref: '#/components/schemas/User' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / users / { id } / role:
 * patch:
 * tags: [Users]
   * summary: Update a user's role
      * description: Changes the role assigned to a tenant user.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Id' }]
      * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/UserRoleRequest' } } } }
 * responses:
 * 200: { description: Role updated, content: { application / json: { schema: { $ref: '#/components/schemas/User' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / users / { id } / deactivate:
 * patch:
 * tags: [Users]
   * summary: Deactivate a user
      * description: Marks a tenant user as inactive.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Id' }]
      * responses:
 * 200: { description: User deactivated, content: { application / json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / warehouses:
 * get:
 * tags: [Warehouses]
   * summary: List warehouses
      * description: Returns a paginated list of warehouses.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }, { $ref: '#/components/parameters/Search' }]
      * responses:
 * 200: { description: Warehouses returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * post:
 * tags: [Warehouses]
   * summary: Create a warehouse
      * description: Creates an active warehouse for the tenant.
 * security: [{ bearerAuth: [] }]
      * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/WarehouseRequest' } } } }
 * responses:
 * 201: { description: Warehouse created, content: { application / json: { schema: { $ref: '#/components/schemas/Warehouse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / warehouses / { id }:
 * get:
 * tags: [Warehouses]
   * summary: Get a warehouse
      * description: Returns one warehouse by ID.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Id' }]
      * responses:
 * 200: { description: Warehouse returned, content: { application / json: { schema: { $ref: '#/components/schemas/Warehouse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * patch:
 * tags: [Warehouses]
   * summary: Update a warehouse
      * description: Updates warehouse details.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Id' }]
      * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/WarehouseRequest' } } } }
 * responses:
 * 200: { description: Warehouse updated, content: { application / json: { schema: { $ref: '#/components/schemas/Warehouse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / warehouses / { id } / locations:
 * get:
 * tags: [Warehouses]
   * summary: List warehouse locations
      * description: Returns locations belonging to a warehouse.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Id' }, { $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }]
      * responses:
 * 200: { description: Locations returned, content: { application / json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * post:
 * tags: [Warehouses]
   * summary: Create a warehouse location
      * description: Adds a location under a warehouse.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/Id' }]
      * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/LocationRequest' } } } }
 * responses:
 * 201: { description: Location created, content: { application / json: { schema: { $ref: '#/components/schemas/Location' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1 / warehouses / locations / { locationId }:
 * patch:
 * tags: [Warehouses]
   * summary: Update a location
      * description: Updates warehouse location details.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/LocationId' }]
      * requestBody: { required: true, content: { application / json: { schema: { $ref: '#/components/schemas/LocationRequest' } } } }
 * responses:
 * 200: { description: Location updated, content: { application / json: { schema: { $ref: '#/components/schemas/Location' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 * delete:
 * tags: [Warehouses]
   * summary: Delete a location
      * description: Deactivates a warehouse location.
 * security: [{ bearerAuth: [] }]
   * parameters: [{ $ref: '#/components/parameters/LocationId' }]
      * responses:
 * 200: { description: Location deleted, content: { application / json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 * 400: { $ref: '#/components/responses/ValidationError' }
 * 401: { $ref: '#/components/responses/UnauthorizedError' }
 * 403: { $ref: '#/components/responses/ForbiddenError' }
 * 404: { $ref: '#/components/responses/NotFoundError' }
 * 500: { $ref: '#/components/responses/InternalServerError' }
 */

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
 *     requestBody: { required: true, content: { application/json: { schema: { $ref: '#/components/schemas/ProductRequest' } } } }
 *     responses:
 *       201: { description: Product created, content: { application/json: { schema: { $ref: '#/components/schemas/Product' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
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
 *     requestBody: { required: true, content: { application/json: { schema: { $ref: '#/components/schemas/ProductRequest' } } } }
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
 * /api/v1/suppliers:
 *   get:
 *     tags: [Suppliers]
 *     summary: List suppliers
 *     description: Returns a paginated supplier list.
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
 *     description: Adds a supplier to the tenant.
 *     security: [{ bearerAuth: [] }]
 *     requestBody: { required: true, content: { application/json: { schema: { $ref: '#/components/schemas/SupplierRequest' } } } }
 *     responses:
 *       201: { description: Supplier created, content: { application/json: { schema: { $ref: '#/components/schemas/Supplier' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1/suppliers/{id}:
 *   get:
 *     tags: [Suppliers]
 *     summary: Get a supplier
 *     description: Returns a supplier by ID.
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
 *     requestBody: { required: true, content: { application/json: { schema: { $ref: '#/components/schemas/SupplierRequest' } } } }
 *     responses:
 *       200: { description: Supplier updated, content: { application/json: { schema: { $ref: '#/components/schemas/Supplier' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 *   delete:
 *     tags: [Suppliers]
 *     summary: Deactivate a supplier
 *     description: Marks a supplier inactive.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }]
 *     responses:
 *       200: { description: Supplier deactivated, content: { application/json: { schema: { $ref: '#/components/schemas/MessageResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
 * /api/v1/suppliers/{id}/purchase-orders:
 *   get:
 *     tags: [Suppliers]
 *     summary: List supplier purchase orders
 *     description: Returns purchase orders associated with a supplier.
 *     security: [{ bearerAuth: [] }]
 *     parameters: [{ $ref: '#/components/parameters/Id' }, { $ref: '#/components/parameters/Page' }, { $ref: '#/components/parameters/PageSize' }]
 *     responses:
 *       200: { description: Purchase orders returned, content: { application/json: { schema: { $ref: '#/components/schemas/SuccessResponse' } } } }
 *       400: { $ref: '#/components/responses/ValidationError' }
 *       401: { $ref: '#/components/responses/UnauthorizedError' }
 *       403: { $ref: '#/components/responses/ForbiddenError' }
 *       404: { $ref: '#/components/responses/NotFoundError' }
 *       500: { $ref: '#/components/responses/InternalServerError' }
