const bcrypt = require('bcryptjs');
const prisma = require('../config/prisma');
const { signAccessToken, signRefreshToken, verifyRefreshToken } = require('../utils/tokens');
const { ok, fail } = require('../utils/responses');

const publicUser = (user) => {
  const { passwordHash, ...safe } = user;
  return safe;
};

const authPayload = (user) => ({
  user: publicUser(user),
  accessToken: signAccessToken(user),
  refreshToken: signRefreshToken(user),
});

const register = async (req, res) => {
  const { companyName, firstName, lastName, email, password } = req.body || {};
  if (!companyName || !firstName || !lastName || !email || !password || password.length < 6) {
    return fail(res, 400, 'VALIDATION_ERROR', 'Company, name, email and a password of at least 6 characters are required');
  }

  const tenant = await prisma.tenant.create({
    data: {
      name: companyName,
      slug: `${companyName.toLowerCase().replace(/[^a-z0-9]+/g, '-')}-${Date.now()}`,
    },
  });
  const user = await prisma.user.create({
    data: {
      tenantId: tenant.id,
      email: email.toLowerCase(),
      passwordHash: await bcrypt.hash(password, 12),
      firstName,
      lastName,
      role: 'OWNER',
    },
  });
  return res.status(201).json({ data: authPayload(user), meta: {} });
};

const login = async (req, res) => {
  const { email, password } = req.body || {};
  const user = email ? await prisma.user.findFirst({ where: { email: email.toLowerCase() } }) : null;
  if (!user || !user.isActive || !(await bcrypt.compare(password || '', user.passwordHash))) {
    return fail(res, 401, 'UNAUTHORIZED', 'Invalid email or password');
  }
  const updated = await prisma.user.update({
    where: { id: user.id },
    data: { lastLoginAt: new Date() },
  });
  return ok(res, authPayload(updated));
};

const refresh = async (req, res) => {
  try {
    const payload = verifyRefreshToken(req.body?.refreshToken || '');
    const user = await prisma.user.findUnique({ where: { id: payload.sub } });
    if (!user || !user.isActive || user.tenantId !== payload.tenantId) {
      return fail(res, 401, 'UNAUTHORIZED', 'Invalid refresh token');
    }
    return ok(res, authPayload(user));
  } catch (error) {
    return fail(res, 401, 'UNAUTHORIZED', 'Invalid refresh token');
  }
};

const me = async (req, res) => ok(res, { user: publicUser(req.user) });
const logout = async (req, res) => ok(res, { message: 'Logged out successfully' });

module.exports = { register, login, refresh, me, logout };
