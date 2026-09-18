import { Request, Response, NextFunction } from 'express';
import { ZodError, ZodObject, ZodTypeAny } from 'zod';
import { AppError } from '../errors';

export function validate(schema: ZodObject<any> | ZodTypeAny) {
  return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      if (schema instanceof ZodObject) {
        await schema.parseAsync({
          body: req.body,
          query: req.query,
          params: req.params,
        });
      } else {
        await schema.parseAsync(req.params);
      }
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        const fields: Record<string, string> = {};
        error.errors.forEach((err) => {
          const path = err.path.join('.');
          fields[path] = err.message;
        });
        throw new AppError('Validation failed', 400, 'VALIDATION_ERROR', fields);
      }
      next(error);
    }
  };
}

export function validateParams(schema: ZodTypeAny) {
  return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      await schema.parseAsync(req.params);
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        const fields: Record<string, string> = {};
        error.errors.forEach((err) => {
          const path = err.path.join('.');
          fields[path] = err.message;
        });
        throw new AppError('Validation failed', 400, 'VALIDATION_ERROR', fields);
      }
      next(error);
    }
  };
}

export function validateQuery(schema: ZodTypeAny) {
  return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      await schema.parseAsync(req.query);
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        const fields: Record<string, string> = {};
        error.errors.forEach((err) => {
          const path = err.path.join('.');
          fields[path] = err.message;
        });
        throw new AppError('Validation failed', 400, 'VALIDATION_ERROR', fields);
      }
      next(error);
    }
  };
}

export function validateBody(schema: ZodTypeAny) {
  return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      await schema.parseAsync(req.body);
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        const fields: Record<string, string> = {};
        error.errors.forEach((err) => {
          const path = err.path.join('.');
          fields[path] = err.message;
        });
        throw new AppError('Validation failed', 400, 'VALIDATION_ERROR', fields);
      }
      next(error);
    }
  };
}