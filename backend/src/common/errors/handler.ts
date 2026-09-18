import { Request, Response, NextFunction } from 'express';
import { v4 as uuidv4 } from 'uuid';
import { AppError, isAppError, formatErrorResponse } from '../errors';
import { ZodError } from 'zod';

export function errorHandler(
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
): void {
  const requestId = req.headers['x-request-id'] as string || uuidv4();
  
  console.error(`[${requestId}] Error:`, err);

  if (isAppError(err)) {
    res.status(err.statusCode).json(formatErrorResponse({
      ...err,
      requestId,
    }));
    return;
  }

  if (err instanceof ZodError) {
    const fields: Record<string, string> = {};
    err.errors.forEach((e) => {
      fields[e.path.join('.')] = e.message;
    });
    res.status(400).json({
      error: {
        code: 'VALIDATION_ERROR',
        message: 'Validation failed',
        fields,
        requestId,
      },
    });
    return;
  }

  if (err.name === 'ValidationError') {
    const fields: Record<string, string> = {};
    const mongooseError = err as any;
    Object.keys(mongooseError.errors).forEach((key) => {
      fields[key] = mongooseError.errors[key].message;
    });
    res.status(400).json({
      error: {
        code: 'VALIDATION_ERROR',
        message: 'Validation failed',
        fields,
        requestId,
      },
    });
    return;
  }

  if (err.name === 'MongoServerError' && (err as any).code === 11000) {
    const field = Object.keys((err as any).keyValue)[0];
    res.status(409).json({
      error: {
        code: 'CONFLICT',
        message: `${field} already exists`,
        fields: { [field]: `${field} already exists` },
        requestId,
      },
    });
    return;
  }

  if (err.name === 'JsonWebTokenError') {
    res.status(401).json({
      error: {
        code: 'UNAUTHORIZED',
        message: 'Invalid token',
        requestId,
      },
    });
    return;
  }

  if (err.name === 'TokenExpiredError') {
    res.status(401).json({
      error: {
        code: 'UNAUTHORIZED',
        message: 'Token expired',
        requestId,
      },
    });
    return;
  }

  res.status(500).json({
    error: {
      code: 'INTERNAL_ERROR',
      message: 'An unexpected error occurred',
      requestId,
    },
  });
}

export function notFoundHandler(req: Request, res: Response): void {
  res.status(404).json({
    error: {
      code: 'NOT_FOUND',
      message: `Route ${req.method} ${req.path} not found`,
      requestId: req.headers['x-request-id'] as string || uuidv4(),
    },
  });
}