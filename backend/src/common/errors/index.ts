export class AppError extends Error {
  public readonly statusCode: number;
  public readonly code: string;
  public readonly fields?: Record<string, string>;
  public readonly requestId?: string;
  public readonly isOperational: boolean;

  constructor(
    message: string,
    statusCode: number = 500,
    code: string = 'INTERNAL_ERROR',
    fields?: Record<string, string>,
    requestId?: string
  ) {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
    this.fields = fields;
    this.requestId = requestId;
    this.isOperational = true;

    Object.setPrototypeOf(this, AppError.prototype);
    Error.captureStackTrace(this, this.constructor);
  }
}

export class ValidationError extends AppError {
  constructor(message: string, fields: Record<string, string>, requestId?: string) {
    super(message, 400, 'VALIDATION_ERROR', fields, requestId);
    Object.setPrototypeOf(this, ValidationError.prototype);
  }
}

export class AuthenticationError extends AppError {
  constructor(message: string = 'Authentication required', requestId?: string) {
    super(message, 401, 'UNAUTHORIZED', undefined, requestId);
    Object.setPrototypeOf(this, AuthenticationError.prototype);
  }
}

export class AuthorizationError extends AppError {
  constructor(message: string = 'Insufficient permissions', requestId?: string) {
    super(message, 403, 'FORBIDDEN', undefined, requestId);
    Object.setPrototypeOf(this, AuthorizationError.prototype);
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string = 'Resource', requestId?: string) {
    super(`${resource} not found`, 404, 'NOT_FOUND', undefined, requestId);
    Object.setPrototypeOf(this, NotFoundError.prototype);
  }
}

export class ConflictError extends AppError {
  constructor(message: string, requestId?: string) {
    super(message, 409, 'CONFLICT', undefined, requestId);
    Object.setPrototypeOf(this, ConflictError.prototype);
  }
}

export class RateLimitError extends AppError {
  constructor(message: string = 'Too many requests', requestId?: string) {
    super(message, 429, 'RATE_LIMIT_EXCEEDED', undefined, requestId);
    Object.setPrototypeOf(this, RateLimitError.prototype);
  }
}

export function isAppError(error: unknown): error is AppError {
  return error instanceof AppError;
}

export function formatErrorResponse(error: AppError): object {
  return {
    error: {
      code: error.code,
      message: error.message,
      fields: error.fields,
      requestId: error.requestId,
    },
  };
}