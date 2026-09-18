import dotenv from 'dotenv';

dotenv.config();

export const config = {
  env: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT || '3000', 10),

  mongodb: {
    uri: process.env.MONGODB_URI || 'mongodb://localhost:27017/logitrack',
  },

  jwt: {
    accessSecret: process.env.JWT_ACCESS_SECRET || 'dev-access-secret-change-in-production',
    refreshSecret: process.env.JWT_REFRESH_SECRET || 'dev-refresh-secret-change-in-production',
    accessTokenMinutes: parseInt(process.env.ACCESS_TOKEN_MINUTES || '15', 10),
    refreshTokenDays: parseInt(process.env.REFRESH_TOKEN_DAYS || '30', 10),
  },

  cors: {
    origin: process.env.FRONTEND_URL || 'http://localhost:8080',
    credentials: true,
  },

  rateLimit: {
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS || '900000', 10),
    maxRequests: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS || '100', 10),
  },

  email: {
    from: process.env.EMAIL_FROM || 'no-reply@logitrack.com',
    apiKey: process.env.EMAIL_API_KEY || '',
    provider: process.env.EMAIL_PROVIDER || 'sendgrid',
  },

  storage: {
    bucket: process.env.STORAGE_BUCKET || 'logitrack-files',
    endpoint: process.env.STORAGE_ENDPOINT || '',
    accessKey: process.env.STORAGE_ACCESS_KEY || '',
    secretKey: process.env.STORAGE_SECRET_KEY || '',
  },
};

export default config;