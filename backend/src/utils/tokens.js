const jwt = require('jsonwebtoken');
const env = require('../config/env');

const signAccessToken = (user) => jwt.sign(
  { sub: user.id, tenantId: user.tenantId, role: user.role },
  env.accessSecret,
  { expiresIn: env.accessTtl },
);

const signRefreshToken = (user) => jwt.sign(
  { sub: user.id, tenantId: user.tenantId, type: 'refresh' },
  env.refreshSecret,
  { expiresIn: env.refreshTtl },
);

const verifyAccessToken = (token) => jwt.verify(token, env.accessSecret);
const verifyRefreshToken = (token) => jwt.verify(token, env.refreshSecret);

module.exports = {
  signAccessToken,
  signRefreshToken,
  verifyAccessToken,
  verifyRefreshToken,
};
