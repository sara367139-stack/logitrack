import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import cookieParser from 'cookie-parser';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';
import config from './config';
import { connectDatabase } from './config/database';
import { errorHandler, notFoundHandler } from './common/errors/handler';
import { requestIdMiddleware } from './common/errors/requestId';
import { setupSwagger } from './swagger';
import authRoutes from './modules/auth/auth.routes';
import usersRoutes from './modules/users/users.routes';
import warehousesRoutes from './modules/warehouses/warehouses.routes';
import productsRoutes from './modules/products/products.routes';
import suppliersRoutes from './modules/suppliers/suppliers.routes';
import purchaseOrdersRoutes from './modules/purchase-orders/purchase-orders.routes';
import inventoryRoutes from './modules/inventory/inventory.routes';
import dashboardRoutes from './modules/dashboard/dashboard.routes';
import reportsRoutes from './modules/reports/reports.routes';
import notificationsRoutes from './modules/notifications/notifications.routes';
import auditRoutes from './modules/audit/audit.routes';

export function createApp(): express.Application {
  const app = express();

  app.use(requestIdMiddleware);
  app.use(helmet());
  app.use(cors({
    origin: config.cors.origin,
    credentials: config.cors.credentials,
  }));
  app.use(compression());
  app.use(express.json({ limit: '10mb' }));
  app.use(express.urlencoded({ extended: true }));
  app.use(cookieParser());
  app.use(morgan('combined'));

  const limiter = rateLimit({
    windowMs: config.rateLimit.windowMs,
    max: config.rateLimit.maxRequests,
    message: { error: { code: 'RATE_LIMIT_EXCEEDED', message: 'Too many requests' } },
    standardHeaders: true,
    legacyHeaders: false,
  });
  app.use('/api/', limiter);

  app.get('/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
  });

  setupSwagger(app);

  app.use('/api/v1/auth', authRoutes);
  app.use('/api/v1/users', usersRoutes);
  app.use('/api/v1/warehouses', warehousesRoutes);
  app.use('/api/v1/products', productsRoutes);
  app.use('/api/v1/suppliers', suppliersRoutes);
  app.use('/api/v1/purchase-orders', purchaseOrdersRoutes);
  app.use('/api/v1/inventory', inventoryRoutes);
  app.use('/api/v1/dashboard', dashboardRoutes);
  app.use('/api/v1/reports', reportsRoutes);
  app.use('/api/v1/notifications', notificationsRoutes);
  app.use('/api/v1/audit', auditRoutes);

  app.use(notFoundHandler);
  app.use(errorHandler);

  return app;
}

export async function startServer(): Promise<express.Application> {
  await connectDatabase();
  const app = createApp();
  return app;
}