const required = ['JWT_ACCESS_SECRET', 'JWT_REFRESH_SECRET'];

for (const key of required) {
  if (!process.env[key]) {
    throw new Error(`${key} is required. Copy .env.example to .env and configure it.`);
  }
}

module.exports = {
  accessSecret: process.env.JWT_ACCESS_SECRET,
  refreshSecret: process.env.JWT_REFRESH_SECRET,
  accessTtl: process.env.JWT_ACCESS_TTL || '15m',
  refreshTtl: process.env.JWT_REFRESH_TTL || '30d',
};
