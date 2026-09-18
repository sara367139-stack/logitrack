import { z } from 'zod';

export const objectIdSchema = z.string().regex(/^[0-9a-fA-F]{24}$/, 'Invalid ID format');

export const paginationSchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  pageSize: z.coerce.number().int().min(1).max(100).default(20),
  search: z.string().optional(),
  sortBy: z.string().optional(),
  sortOrder: z.enum(['asc', 'desc']).optional(),
});

export type PaginationParams = z.infer<typeof paginationSchema>;

export const registerSchema = z.object({
  companyName: z.string().min(2).max(160),
  firstName: z.string().min(1).max(80),
  lastName: z.string().min(1).max(80),
  email: z.string().email(),
  password: z.string().min(8).max(128),
});

export const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
});

export const refreshTokenSchema = z.object({
  refreshToken: z.string().min(1),
});

export const forgotPasswordSchema = z.object({
  email: z.string().email(),
});

export const resetPasswordSchema = z.object({
  token: z.string().min(1),
  password: z.string().min(8).max(128),
});

export const warehouseSchema = z.object({
  name: z.string().min(1).max(160),
  code: z.string().min(1).max(40),
  addressLine1: z.string().max(200).optional(),
  city: z.string().max(100).optional(),
  country: z.string().max(100).optional(),
});

export const locationSchema = z.object({
  warehouseId: objectIdSchema,
  parentId: objectIdSchema.optional(),
  name: z.string().min(1).max(120),
  code: z.string().min(1).max(60),
  type: z.enum(['receiving', 'zone', 'aisle', 'shelf', 'bin', 'dispatch']),
  capacity: z.number().optional(),
});

export const productSchema = z.object({
  sku: z.string().min(1).max(100),
  barcode: z.string().max(120).optional(),
  name: z.string().min(1).max(200),
  description: z.string().optional(),
  category: z.string().max(100).optional(),
  unit: z.string().max(30).default('unit'),
  costPrice: z.number().min(0).default(0),
  sellingPrice: z.number().min(0).default(0),
  reorderLevel: z.number().int().min(0).default(0),
  reorderQuantity: z.number().int().min(0).default(0),
  imageUrl: z.string().url().optional(),
});

export const supplierSchema = z.object({
  name: z.string().min(1).max(160),
  contactName: z.string().max(120).optional(),
  email: z.string().email().optional(),
  phone: z.string().max(40).optional(),
  address: z.string().optional(),
});

export const purchaseOrderSchema = z.object({
  supplierId: objectIdSchema,
  warehouseId: objectIdSchema,
  orderNumber: z.string().min(1).max(50),
  expectedDate: z.string().optional(),
  notes: z.string().optional(),
  items: z.array(z.object({
    productId: objectIdSchema,
    orderedQuantity: z.number().int().min(1),
    unitCost: z.number().min(0),
  })).min(1),
});

export const receiveInventorySchema = z.object({
  purchaseOrderId: objectIdSchema,
  warehouseId: objectIdSchema,
  locationId: objectIdSchema,
  items: z.array(z.object({
    productId: objectIdSchema,
    quantity: z.number().int().min(1),
    unitCost: z.number().min(0),
  })).min(1),
  note: z.string().optional(),
});

export const moveInventorySchema = z.object({
  fromLocationId: objectIdSchema,
  toLocationId: objectIdSchema,
  items: z.array(z.object({
    productId: objectIdSchema,
    quantity: z.number().int().min(1),
  })).min(1),
  note: z.string().optional(),
});

export const dispatchInventorySchema = z.object({
  locationId: objectIdSchema,
  items: z.array(z.object({
    productId: objectIdSchema,
    quantity: z.number().int().min(1),
  })).min(1),
  reference: z.string().optional(),
});

export const adjustInventorySchema = z.object({
  productId: objectIdSchema,
  locationId: objectIdSchema,
  newQuantity: z.number().int().min(0),
  reason: z.string().min(1),
});

export const userInviteSchema = z.object({
  email: z.string().email(),
  firstName: z.string().min(1).max(80),
  lastName: z.string().min(1).max(80),
  role: z.enum(['owner', 'admin', 'manager', 'operator', 'viewer']),
});

export const updateUserRoleSchema = z.object({
  role: z.enum(['owner', 'admin', 'manager', 'operator', 'viewer']),
});

export function validate<T>(schema: z.ZodSchema<T>, data: unknown): T {
  const result = schema.safeParse(data);
  if (!result.success) {
    const fields: Record<string, string> = {};
    result.error.errors.forEach((err) => {
      const path = err.path.join('.');
      fields[path] = err.message;
    });
    throw new Error(JSON.stringify({ code: 'VALIDATION_ERROR', fields }));
  }
  return result.data;
}