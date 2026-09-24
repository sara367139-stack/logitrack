const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/auth.routes');
const productRoutes = require('./routes/product.routes');
const { ok } = require('./utils/responses');
const { notFound, errorHandler } = require('./middleware/errors');

const app = express();

app.use(cors({ origin: process.env.CLIENT_ORIGIN || '*', credentials: true }));
app.use(express.json({ limit: '1mb' }));

app.get('/health', (req, res) => ok(res, {
  status: 'ok',
  service: 'logitrack-backend',
  timestamp: new Date().toISOString(),
}));
app.get('/api/v1', (req, res) => ok(res, {
  name: 'LogiTrack API',
  version: '2.0.0',
  endpoints: ['/api/v1/auth', '/api/v1/products'],
}));

app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/products', productRoutes);
app.use(notFound);
app.use(errorHandler);

module.exports = app;
