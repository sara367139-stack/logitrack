# LogiTrack Backend API

A comprehensive warehouse and inventory management backend API built with Node.js, TypeScript, Express, and MongoDB Atlas. Designed for the LogiTrack Flutter application.

## Features

- **Multi-tenant Architecture**: Complete data isolation between companies
- **Role-Based Access Control**: Owner, Admin, Manager, Operator, Viewer roles
- **JWT Authentication**: Access tokens (15 min) + Refresh tokens (30 days)
- **Inventory Management**: Real-time stock tracking with transactions
- **Purchase Orders**: Full lifecycle from draft to received
- **Barcode Scanning**: Product lookup by barcode
- **Dashboard & Reports**: Summary stats, low-stock alerts, CSV exports
- **Audit Logging**: Complete action history
- **Notifications**: Low-stock, receiving, and system alerts
- **Swagger Documentation**: Interactive API docs at `/api/docs`

## Tech Stack

- **Runtime**: Node.js 20+
- **Language**: TypeScript 5+
- **Framework**: Express.js
- **Database**: MongoDB Atlas (Mongoose ODM)
- **Authentication**: Argon2id password hashing, JWT tokens
- **Validation**: Zod schema validation
- **Documentation**: Swagger/OpenAPI 3.0
- **Security**: Helmet, CORS, Rate limiting, Request ID tracking

## Quick Start

### Prerequisites

- Node.js 20+
- MongoDB Atlas account (or local MongoDB)
- npm or yarn

### Installation

```bash
cd backend
npm install
```

### Configuration

```bash
cp .env.example .env
```

Edit `.env` with your configuration:

```env
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/logitrack
JWT_ACCESS_SECRET=your-super-secret-access-key-min-32-chars
JWT_REFRESH_SECRET=your-super-secret-refresh-key-min-32-chars
ACCESS_TOKEN_MINUTES=15
REFRESH_TOKEN_DAYS=30
FRONTEND_URL=http://localhost:8080
```

### Database Setup

```bash
# Run seed data (creates demo tenant, users, warehouse, products, etc.)
npm run seed
```

### Development

```bash
npm run dev
```

Server starts at `http://localhost:3000`
- API Base: `http://localhost:3000/api/v1`
- Swagger Docs: `http://localhost:3000/api/docs`
- Health Check: `http://localhost:3000/health`

### Production Build

```bash
npm run build
npm start
```

## API Endpoints

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/register` | Register new tenant & owner |
| POST | `/auth/login` | Login & get tokens |
| POST | `/auth/refresh` | Refresh access token |
| POST | `/auth/logout` | Logout (revoke refresh token) |
| POST | `/auth/forgot-password` | Request password reset |
| POST | `/auth/reset-password` | Reset password with token |
| GET | `/auth/me` | Get current user |
| PATCH | `/auth/me` | Update current user |

### Dashboard
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/dashboard/summary` | Dashboard stats |
| GET | `/dashboard/activity` | Recent activity |
| GET | `/dashboard/stock-alerts` | Low stock alerts |

### Products
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/products` | List products (paginated) |
| POST | `/products` | Create product |
| GET | `/products/:id` | Get product |
| PATCH | `/products/:id` | Update product |
| DELETE | `/products/:id` | Deactivate product |
| GET | `/products/by-barcode/:barcode` | Lookup by barcode |
| GET | `/products/:id/stock` | Get stock across locations |
| GET | `/products/low-stock` | Low stock products |

### Warehouses & Locations
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/warehouses` | List warehouses |
| POST | `/warehouses` | Create warehouse |
| GET | `/warehouses/:id` | Get warehouse |
| PATCH | `/warehouses/:id` | Update warehouse |
| GET | `/warehouses/:id/locations` | List locations |
| POST | `/warehouses/:id/locations` | Create location |
| PATCH | `/locations/:id` | Update location |
| DELETE | `/locations/:id` | Delete location |

### Inventory
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/inventory` | List inventory balances |
| GET | `/inventory/low-stock` | Low stock items |
| GET | `/inventory/product/:productId` | Stock by product |
| GET | `/inventory/location/:locationId` | Stock by location |
| POST | `/inventory/receive` | Receive stock (PO) |
| POST | `/inventory/move` | Move stock between locations |
| POST | `/inventory/dispatch` | Dispatch stock |
| POST | `/inventory/adjust` | Adjust stock (manager+) |
| GET | `/inventory/transactions` | Transaction history |

### Suppliers
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/suppliers` | List suppliers |
| POST | `/suppliers` | Create supplier |
| GET | `/suppliers/:id` | Get supplier |
| PATCH | `/suppliers/:id` | Update supplier |
| DELETE | `/suppliers/:id` | Deactivate supplier |
| GET | `/suppliers/:id/purchase-orders` | Supplier's POs |

### Purchase Orders
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/purchase-orders` | List POs |
| POST | `/purchase-orders` | Create PO |
| GET | `/purchase-orders/:id` | Get PO with items |
| PATCH | `/purchase-orders/:id` | Update PO (draft only) |
| POST | `/purchase-orders/:id/submit` | Submit for approval |
| POST | `/purchase-orders/:id/approve` | Approve PO |
| POST | `/purchase-orders/:id/cancel` | Cancel PO |
| POST | `/purchase-orders/:id/receive` | Receive PO items |

### Reports
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/reports/inventory-value` | Total inventory value |
| GET | `/reports/stock-movement` | Stock movement history |
| GET | `/reports/receiving` | Receiving report |
| GET | `/reports/dispatch` | Dispatch report |
| GET | `/reports/slow-moving` | Slow moving items |
| GET | `/reports/export.csv` | Export inventory CSV |

### Notifications
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/notifications` | List notifications |
| PATCH | `/notifications/:id/read` | Mark as read |
| POST | `/notifications/read-all` | Mark all as read |

### Users (Admin/Owner)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/users` | List users |
| GET | `/users/:id` | Get user |
| POST | `/users/invite` | Invite new user |
| PATCH | `/users/:id/role` | Update user role |
| PATCH | `/users/:id/deactivate` | Deactivate user |

### Audit
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/audit` | List audit logs (paginated, filterable) |

## Permission Matrix

| Permission | Owner | Admin | Manager | Operator | Viewer |
|------------|-------|-------|---------|----------|--------|
| users.read | ✅ | ✅ | ✅ | ✅ | ✅ |
| users.manage | ✅ | ✅ | ❌ | ❌ | ❌ |
| warehouses.read | ✅ | ✅ | ✅ | ✅ | ✅ |
| warehouses.manage | ✅ | ✅ | ✅ | ❌ | ❌ |
| products.read | ✅ | ✅ | ✅ | ✅ | ✅ |
| products.manage | ✅ | ✅ | ✅ | ❌ | ❌ |
| suppliers.read | ✅ | ✅ | ✅ | ❌ | ✅ |
| suppliers.manage | ✅ | ✅ | ✅ | ❌ | ❌ |
| purchase_orders.read | ✅ | ✅ | ✅ | ❌ | ✅ |
| purchase_orders.manage | ✅ | ✅ | ✅ | ❌ | ❌ |
| inventory.read | ✅ | ✅ | ✅ | ✅ | ✅ |
| inventory.receive | ✅ | ✅ | ✅ | ✅ | ❌ |
| inventory.move | ✅ | ✅ | ✅ | ✅ | ❌ |
| inventory.dispatch | ✅ | ✅ | ✅ | ✅ | ❌ |
| inventory.adjust | ✅ | ✅ | ✅ | ❌ | ❌ |
| reports.read | ✅ | ✅ | ✅ | ❌ | ✅ |
| notifications.read | ✅ | ✅ | ✅ | ✅ | ✅ |

## Inventory Transaction Rules

All inventory operations follow ACID principles using MongoDB transactions:

1. **Receiving**: Increases balance, creates transaction, updates PO
2. **Moving**: Locks source, validates availability, transfers atomically
3. **Dispatching**: Locks source, validates, decreases, creates low-stock alerts
4. **Adjusting**: Requires reason + manager permission, logs before/after

## Response Format

### Success
```json
{
  "data": {},
  "meta": { "page": 1, "pageSize": 20, "total": 100, "totalPages": 5 }
}
```

### Error
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "The request is invalid.",
    "fields": { "sku": "SKU is required." },
    "requestId": "req_123"
  }
}
```

## Development Credentials (after seed)

```
Tenant: Demo Logistics
Owner:    owner@logitrack.demo / LogiTrack@2026!
Manager:  manager@logitrack.demo / LogiTrack@2026!
Operator: operator@logitrack.demo / LogiTrack@2026!
Viewer:   viewer@logitrack.demo / LogiTrack@2026!
```

⚠️ **Never use these credentials in production!**

## Production Checklist

- [ ] Strong JWT secrets (64+ chars)
- [ ] HTTPS + CORS configured
- [ ] MongoDB Atlas IP whitelist
- [ ] Database backups enabled
- [ ] Error monitoring (Sentry)
- [ ] Rate limiting tuned
- [ ] File storage permissions
- [ ] Role permissions verified
- [ ] Inventory totals validated

## Project Structure

```
backend/
├── src/
│   ├── config/          # Configuration & DB connection
│   ├── common/          # Shared utilities
│   │   ├── auth/        # JWT, permissions, middleware
│   │   ├── errors/      # Error classes & handler
│   │   ├── validation/  # Zod schemas & middleware
│   │   └── pagination/  # Pagination helpers
│   ├── models/          # Mongoose models
│   ├── modules/         # Feature modules
│   │   ├── auth/
│   │   ├── users/
│   │   ├── warehouses/
│   │   ├── products/
│   │   ├── inventory/
│   │   ├── suppliers/
│   │   ├── purchase-orders/
│   │   ├── dashboard/
│   │   ├── reports/
│   │   ├── notifications/
│   │   └── audit/
│   ├── swagger.ts       # OpenAPI documentation
│   ├── app.ts           # Express app factory
│   └── main.ts          # Entry point
├── prisma/seed.ts       # Database seed script
├── tests/               # Test files
├── .env.example
├── package.json
└── tsconfig.json
```

## License

MIT