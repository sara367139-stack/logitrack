# LogiTrack Backend

Express + PostgreSQL + Prisma backend for the LogiTrack Flutter app.

## Local setup

1. Copy `.env.example` to `.env` and replace both JWT secrets.
2. Start PostgreSQL:

```bash
docker compose up -d postgres
```

3. Install dependencies and create the schema:

```bash
npm install
npm run prisma:generate
npx prisma migrate dev --name init
npm run prisma:seed
```

4. Start the API:

```bash
npm start
```

The API is available at `http://localhost:3000`, and health checks are available at `/health`.

The seeded development account is `alex@example.com` with password `123456`. Change it before sharing the environment.

## Architecture

- `src/routes`: HTTP route definitions
- `src/controllers`: request/response orchestration
- `src/middleware`: JWT authentication and error handling
- `src/config`: Prisma and environment configuration
- `prisma/schema.prisma`: PostgreSQL data model

Access tokens expire after 15 minutes by default. Use the refresh endpoint to obtain a new access token.
