import request from 'supertest';
import express from 'express';
import { createApp } from '../src/app';

const app = createApp();

describe('Health Check', () => {
  it('should return OK', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body.status).toBe('ok');
  });
});

describe('Authentication', () => {
  it('should reject login without credentials', async () => {
    const res = await request(app)
      .post('/api/v1/auth/login')
      .send({});
    expect(res.status).toBe(400);
    expect(res.body.error.code).toBe('VALIDATION_ERROR');
  });

  it('should reject register without required fields', async () => {
    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({});
    expect(res.status).toBe(400);
    expect(res.body.error.code).toBe('VALIDATION_ERROR');
  });
});

describe('Protected Routes', () => {
  it('should require authentication', async () => {
    const res = await request(app).get('/api/v1/users');
    expect(res.status).toBe(401);
    expect(res.body.error.code).toBe('UNAUTHORIZED');
  });
});