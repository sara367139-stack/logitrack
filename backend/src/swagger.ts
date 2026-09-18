import swaggerJsdoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';
import { Express } from 'express';
import path from 'path';
import config from './config';

const options: swaggerJsdoc.Options = {
  definition: {
    openapi: '3.0.3',
    info: {
      title: 'LogiTrack API',
      version: '1.0.0',
      description: 'Warehouse & Inventory Management API for LogiTrack Flutter Application',
      contact: {
        name: 'LogiTrack Team',
        email: 'support@logitrack.com',
      },
      license: {
        name: 'MIT',
        url: 'https://opensource.org/licenses/MIT',
      },
    },
    servers: [
      {
        url: `http://localhost:${config.port}/api/v1`,
        description: 'Development server',
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
      schemas: {
        Error: {
          type: 'object',
          properties: {
            error: {
              type: 'object',
              properties: {
                code: { type: 'string', example: 'VALIDATION_ERROR' },
                message: { type: 'string', example: 'The request is invalid.' },
                fields: {
                  type: 'object',
                  additionalProperties: { type: 'string' },
                  example: { sku: 'SKU is required.' },
                },
                requestId: { type: 'string', example: 'req_123' },
              },
            },
          },
        },
        SuccessResponse: {
          type: 'object',
          properties: {
            data: { type: 'object' },
            meta: {
              type: 'object',
              properties: {
                page: { type: 'integer', example: 1 },
                pageSize: { type: 'integer', example: 20 },
                total: { type: 'integer', example: 100 },
                totalPages: { type: 'integer', example: 5 },
              },
            },
          },
        },
        PaginationParams: {
          type: 'object',
          properties: {
            page: { type: 'integer', minimum: 1, default: 1 },
            pageSize: { type: 'integer', minimum: 1, maximum: 100, default: 20 },
            search: { type: 'string' },
            sortBy: { type: 'string' },
            sortOrder: { type: 'string', enum: ['asc', 'desc'] },
          },
        },
        Tenant: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            name: { type: 'string', example: 'Acme Logistics' },
            slug: { type: 'string', example: 'acme-logistics' },
            logoUrl: { type: 'string', format: 'uri' },
            defaultCurrency: { type: 'string', example: 'USD' },
            timezone: { type: 'string', example: 'UTC' },
            createdAt: { type: 'string', format: 'date-time' },
            updatedAt: { type: 'string', format: 'date-time' },
          },
        },
        User: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            tenantId: { type: 'string', format: 'uuid' },
            email: { type: 'string', format: 'email', example: 'alex@example.com' },
            firstName: { type: 'string', example: 'Alex' },
            lastName: { type: 'string', example: 'Khan' },
            phone: { type: 'string', example: '+1234567890' },
            role: { type: 'string', enum: ['owner', 'admin', 'manager', 'operator', 'viewer'] },
            avatarUrl: { type: 'string', format: 'uri' },
            isActive: { type: 'boolean', example: true },
            lastLoginAt: { type: 'string', format: 'date-time' },
            createdAt: { type: 'string', format: 'date-time' },
            updatedAt: { type: 'string', format: 'date-time' },
          },
        },
        Warehouse: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            tenantId: { type: 'string', format: 'uuid' },
            name: { type: 'string', example: 'Main Distribution Center' },
            code: { type: 'string', example: 'MDC' },
            addressLine1: { type: 'string', example: '123 Warehouse St' },
            city: { type: 'string', example: 'New York' },
            country: { type: 'string', example: 'USA' },
            isActive: { type: 'boolean', example: true },
            createdAt: { type: 'string', format: 'date-time' },
            updatedAt: { type: 'string', format: 'date-time' },
          },
        },
        Location: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            warehouseId: { type: 'string', format: 'uuid' },
            parentId: { type: 'string', format: 'uuid' },
            name: { type: 'string', example: 'Zone A / Shelf 02' },
            code: { type: 'string', example: 'ZONE-A-02' },
            type: { type: 'string', enum: ['receiving', 'zone', 'aisle', 'shelf', 'bin', 'dispatch'] },
            capacity: { type: 'number' },
            isActive: { type: 'boolean', example: true },
            createdAt: { type: 'string', format: 'date-time' },
            updatedAt: { type: 'string', format: 'date-time' },
          },
        },
        Product: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            tenantId: { type: 'string', format: 'uuid' },
            sku: { type: 'string', example: 'BOLT-001' },
            barcode: { type: 'string', example: '6291234567890' },
            name: { type: 'string', example: 'Steel Bolt M8x50' },
            description: { type: 'string', example: 'High-grade steel bolt' },
            category: { type: 'string', example: 'Fasteners' },
            unit: { type: 'string', example: 'unit' },
            costPrice: { type: 'number', example: 0.50 },
            sellingPrice: { type: 'number', example: 1.20 },
            reorderLevel: { type: 'integer', example: 100 },
            reorderQuantity: { type: 'integer', example: 500 },
            imageUrl: { type: 'string', format: 'uri' },
            isActive: { type: 'boolean', example: true },
            createdAt: { type: 'string', format: 'date-time' },
            updatedAt: { type: 'string', format: 'date-time' },
          },
        },
        ProductWithStock: {
          allOf: [
            { $ref: '#/components/schemas/Product' },
            {
              type: 'object',
              properties: {
                totalQuantity: { type: 'integer', example: 80 },
                locations: {
                  type: 'array',
                  items: {
                    type: 'object',
                    properties: {
                      locationId: { type: 'string', format: 'uuid' },
                      locationName: { type: 'string', example: 'Zone A / Shelf 02' },
                      quantity: { type: 'integer', example: 80 },
                    },
                  },
                },
              },
            },
          ],
        },
        Supplier: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            tenantId: { type: 'string', format: 'uuid' },
            name: { type: 'string', example: 'Fastener Supply Co' },
            contactName: { type: 'string', example: 'John Smith' },
            email: { type: 'string', format: 'email', example: 'john@fastener.com' },
            phone: { type: 'string', example: '+1234567890' },
            address: { type: 'string', example: '456 Industrial Ave' },
            isActive: { type: 'boolean', example: true },
            createdAt: { type: 'string', format: 'date-time' },
            updatedAt: { type: 'string', format: 'date-time' },
          },
        },
        PurchaseOrderItem: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            purchaseOrderId: { type: 'string', format: 'uuid' },
            productId: { type: 'string', format: 'uuid' },
            orderedQuantity: { type: 'integer', example: 100 },
            receivedQuantity: { type: 'integer', example: 0 },
            unitCost: { type: 'number', example: 0.45 },
          },
        },
        PurchaseOrder: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            tenantId: { type: 'string', format: 'uuid' },
            supplierId: { type: 'string', format: 'uuid' },
            warehouseId: { type: 'string', format: 'uuid' },
            orderNumber: { type: 'string', example: 'PO-2026-001' },
            status: { type: 'string', enum: ['draft', 'submitted', 'partial', 'received', 'cancelled'] },
            expectedDate: { type: 'string', format: 'date' },
            notes: { type: 'string' },
            createdBy: { type: 'string', format: 'uuid' },
            approvedBy: { type: 'string', format: 'uuid' },
            createdAt: { type: 'string', format: 'date-time' },
            updatedAt: { type: 'string', format: 'date-time' },
            items: { type: 'array', items: { $ref: '#/components/schemas/PurchaseOrderItem' } },
          },
        },
        InventoryBalance: {
          type: 'object',
          properties: {
            productId: { type: 'string', format: 'uuid' },
            locationId: { type: 'string', format: 'uuid' },
            quantity: { type: 'integer', example: 100 },
            reservedQuantity: { type: 'integer', example: 10 },
            availableQuantity: { type: 'integer', example: 90 },
            product: {
              type: 'object',
              properties: {
                sku: { type: 'string' },
                name: { type: 'string' },
                barcode: { type: 'string' },
                unit: { type: 'string' },
              },
            },
            location: {
              type: 'object',
              properties: {
                name: { type: 'string' },
                code: { type: 'string' },
                type: { type: 'string' },
              },
            },
            warehouse: {
              type: 'object',
              properties: {
                name: { type: 'string' },
                code: { type: 'string' },
              },
            },
          },
        },
        InventoryTransaction: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            tenantId: { type: 'string', format: 'uuid' },
            productId: { type: 'string', format: 'uuid' },
            fromLocationId: { type: 'string', format: 'uuid' },
            toLocationId: { type: 'string', format: 'uuid' },
            quantity: { type: 'integer', example: 10 },
            type: { type: 'string', enum: ['receive', 'move', 'dispatch', 'adjustment', 'return'] },
            referenceType: { type: 'string' },
            referenceId: { type: 'string', format: 'uuid' },
            reason: { type: 'string' },
            performedBy: { type: 'string', format: 'uuid' },
            createdAt: { type: 'string', format: 'date-time' },
          },
        },
        Notification: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            tenantId: { type: 'string', format: 'uuid' },
            userId: { type: 'string', format: 'uuid' },
            type: { type: 'string', example: 'low_stock' },
            title: { type: 'string', example: 'Low Stock Alert' },
            message: { type: 'string', example: 'Steel Bolt (BOLT-001) has reached reorder level' },
            data: { type: 'object' },
            readAt: { type: 'string', format: 'date-time' },
            createdAt: { type: 'string', format: 'date-time' },
          },
        },
        DashboardSummary: {
          type: 'object',
          properties: {
            totalItems: { type: 'integer', example: 1248 },
            openOrders: { type: 'integer', example: 24 },
            lowStockItems: { type: 'integer', example: 7 },
            warehouseCount: { type: 'integer', example: 3 },
            stockValue: { type: 'number', example: 85420.50 },
            receivedToday: { type: 'integer', example: 18 },
            dispatchedToday: { type: 'integer', example: 42 },
          },
        },
        AuthRegisterRequest: {
          type: 'object',
          required: ['companyName', 'firstName', 'lastName', 'email', 'password'],
          properties: {
            companyName: { type: 'string', example: 'Acme Logistics' },
            firstName: { type: 'string', example: 'Alex' },
            lastName: { type: 'string', example: 'Khan' },
            email: { type: 'string', format: 'email', example: 'alex@example.com' },
            password: { type: 'string', format: 'password', example: 'securePassword123' },
          },
        },
        AuthLoginRequest: {
          type: 'object',
          required: ['email', 'password'],
          properties: {
            email: { type: 'string', format: 'email', example: 'alex@example.com' },
            password: { type: 'string', format: 'password', example: 'securePassword123' },
          },
        },
        AuthResponse: {
          type: 'object',
          properties: {
            user: { $ref: '#/components/schemas/User' },
            accessToken: { type: 'string', example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' },
            refreshToken: { type: 'string', example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' },
          },
        },
      },
      responses: {
        UnauthorizedError: {
          description: 'Authentication required',
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/Error' },
              example: {
                error: { code: 'UNAUTHORIZED', message: 'Invalid email or password', requestId: 'req_123' },
              },
            },
          },
        },
        ForbiddenError: {
          description: 'Insufficient permissions',
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/Error' },
              example: {
                error: { code: 'FORBIDDEN', message: 'Insufficient permissions', requestId: 'req_123' },
              },
            },
          },
        },
        NotFoundError: {
          description: 'Resource not found',
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/Error' },
              example: {
                error: { code: 'NOT_FOUND', message: 'Product not found', requestId: 'req_123' },
              },
            },
          },
        },
        ValidationError: {
          description: 'Validation failed',
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/Error' },
              example: {
                error: { code: 'VALIDATION_ERROR', message: 'The request is invalid.', fields: { sku: 'SKU is required.' }, requestId: 'req_123' },
              },
            },
          },
        },
        ConflictError: {
          description: 'Resource conflict',
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/Error' },
              example: {
                error: { code: 'CONFLICT', message: 'SKU already exists', requestId: 'req_123' },
              },
            },
            InternalServerError: {
              description: 'Unexpected server error',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/Error' },
                  example: {
                    error: { code: 'INTERNAL_ERROR', message: 'An unexpected error occurred', requestId: 'req_123' },
                  },
                },
              },
            },
          },
        },
      },
    },
    security: [{ bearerAuth: [] }],
    tags: [
      { name: 'Authentication', description: 'User authentication and authorization' },
      { name: 'Users', description: 'User management' },
      { name: 'Warehouses', description: 'Warehouse and location management' },
      { name: 'Products', description: 'Product catalog management' },
      { name: 'Suppliers', description: 'Supplier management' },
      { name: 'Purchase Orders', description: 'Purchase order management' },
      { name: 'Inventory', description: 'Inventory operations' },
      { name: 'Dashboard', description: 'Dashboard summaries and alerts' },
      { name: 'Reports', description: 'Reports and analytics' },
      { name: 'Notifications', description: 'User notifications' },
      { name: 'Audit', description: 'Audit logs' },
    ],
  },
  apis: [
    path.join(__dirname, 'modules/**/*.routes.ts'),
    path.join(__dirname, 'modules/**/*.controller.ts'),
    path.join(__dirname, 'modules/**/*.docs.ts'),
    path.join(__dirname, 'modules/**/*.routes.js'),
    path.join(__dirname, 'modules/**/*.controller.js'),
    path.join(__dirname, 'modules/**/*.docs.js'),
  ],
};

const swaggerSpec = swaggerJsdoc(options);

export function setupSwagger(app: Express): void {
  app.use('/api/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec, {
    customCss: '.swagger-ui .topbar { display: none }',
    customSiteTitle: 'LogiTrack API Documentation',
  }));

  app.get('/api/docs.json', (req, res) => {
    res.setHeader('Content-Type', 'application/json');
    res.send(swaggerSpec);
  });
}

export default swaggerSpec;