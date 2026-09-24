require('dotenv').config();

const app = require('./src/app');
const prisma = require('./src/config/prisma');

const port = Number(process.env.PORT || 3000);
const server = app.listen(port, '0.0.0.0', () => {
  console.log(`LogiTrack backend running on http://0.0.0.0:${port}`);
});

const shutdown = async (signal) => {
  console.log(`${signal}: shutting down`);
  server.close(async () => {
    await prisma.$disconnect();
    process.exit(0);
  });
};

process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));
