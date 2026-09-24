const prisma = require('../config/prisma');
const { verifyAccessToken } = require('../utils/tokens');
const { fail } = require('../utils/responses');

const authenticate = async (req, res, next) => {
  const header = req.headers.authorization || '';
  if (!header.startsWith('Bearer ')) {
    return fail(res, 401, 'UNAUTHORIZED', 'Authentication required');
  }

  try {
    const payload = verifyAccessToken(header.slice(7));
    const user = await prisma.user.findUnique({ where: { id: payload.sub } });
    if (!user || !user.isActive || user.tenantId !== payload.tenantId) {
      return fail(res, 401, 'UNAUTHORIZED', 'Invalid or expired access token');
    }
    req.user = user;
    return next();
  } catch (error) {
    return fail(res, 401, 'UNAUTHORIZED', 'Invalid or expired access token');
  }
};

const authorize = (...roles) => (req, res, next) => {
  if (!roles.includes(req.user.role)) {
    return fail(res, 403, 'FORBIDDEN', 'Insufficient permissions');
  }
  return next();
};

module.exports = { authenticate, authorize };
