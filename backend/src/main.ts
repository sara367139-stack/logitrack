import { startServer } from './app';
import config from './config';

async function main(): Promise<void> {
  try {
    const app = await startServer();
    
    const server = app.listen(config.port, () => {
      console.log(`🚀 LogiTrack API server running on port ${config.port}`);
      console.log(`📝 Environment: ${config.env}`);
      console.log(`🌐 CORS origin: ${config.cors.origin}`);
    });

    const shutdown = async (signal: string) => {
      console.log(`\n${signal} received. Shutting down gracefully...`);
      server.close(async () => {
        console.log('HTTP server closed');
        process.exit(0);
      });
    };

    process.on('SIGTERM', () => shutdown('SIGTERM'));
    process.on('SIGINT', () => shutdown('SIGINT'));
  } catch (error) {
    console.error('❌ Failed to start server:', error);
    process.exit(1);
  }
}

main();