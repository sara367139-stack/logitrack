import { Request, Response, NextFunction } from 'express';
import { productsService } from './products.service';
import { PaginationParams } from '../../common/pagination';
import { authMiddleware, attachUserDoc, requirePermission } from '../../common/auth/middleware';
import { PERMISSIONS } from '../../common/auth';

export class ProductsController {
  async getProducts(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await productsService.getProducts(req.tenantId!, req.query as unknown as PaginationParams);
      res.json({ data: result.data, meta: result.meta });
    } catch (error) {
      next(error);
    }
  }

  async getProductById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const product = await productsService.getProductById(req.tenantId!, req.params.id);
      res.json({ data: product });
    } catch (error) {
      next(error);
    }
  }

  async getProductByBarcode(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const product = await productsService.getProductByBarcode(req.tenantId!, req.params.barcode);
      res.json({ data: product });
    } catch (error) {
      next(error);
    }
  }

  async createProduct(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const product = await productsService.createProduct(req.tenantId!, req.body);
      res.status(201).json({ data: product });
    } catch (error) {
      next(error);
    }
  }

  async updateProduct(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const product = await productsService.updateProduct(req.tenantId!, req.params.id, req.body);
      res.json({ data: product });
    } catch (error) {
      next(error);
    }
  }

  async deleteProduct(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      await productsService.deleteProduct(req.tenantId!, req.params.id);
      res.json({ data: { message: 'Product deactivated successfully' } });
    } catch (error) {
      next(error);
    }
  }

  async getProductStock(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const stock = await productsService.getProductStock(req.tenantId!, req.params.id);
      res.json({ data: stock });
    } catch (error) {
      next(error);
    }
  }

  async getLowStockProducts(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const products = await productsService.getLowStockProducts(req.tenantId!);
      res.json({ data: products });
    } catch (error) {
      next(error);
    }
  }
}

export const productsController = new ProductsController();