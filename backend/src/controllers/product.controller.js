const prisma = require('../config/prisma');
const { ok, fail, paginate } = require('../utils/responses');

const includeStock = {
  inventory: { select: { locationId: true, warehouseId: true, quantity: true, location: { select: { name: true, code: true } } } },
};

const mapProduct = (product) => ({
  ...product,
  costPrice: Number(product.costPrice),
  sellingPrice: Number(product.sellingPrice),
  totalQuantity: product.inventory.reduce((sum, item) => sum + item.quantity, 0),
  locations: product.inventory.map((item) => ({
    locationId: item.locationId,
    warehouseId: item.warehouseId,
    locationName: item.location.name,
    quantity: item.quantity,
  })),
});

const list = async (req, res) => {
  const search = (req.query.search || '').toString();
  const products = await prisma.product.findMany({
    where: {
      tenantId: req.user.tenantId,
      status: 'ACTIVE',
      ...(search ? { OR: [{ name: { contains: search, mode: 'insensitive' } }, { sku: { contains: search, mode: 'insensitive' } }, { category: { contains: search, mode: 'insensitive' } }] } : {}),
    },
    include: includeStock,
    orderBy: { createdAt: 'desc' },
  });
  const page = paginate(products.map(mapProduct), req.query);
  return ok(res, page.data, page.meta);
};

const getById = async (req, res) => {
  const product = await prisma.product.findFirst({ where: { id: req.params.id, tenantId: req.user.tenantId }, include: includeStock });
  if (!product) return fail(res, 404, 'NOT_FOUND', 'Product not found');
  return ok(res, mapProduct(product));
};

const lowStock = async (req, res) => {
  const products = await prisma.product.findMany({ where: { tenantId: req.user.tenantId, status: 'ACTIVE' }, include: includeStock });
  return ok(res, products.map(mapProduct).filter((product) => product.totalQuantity <= product.reorderLevel));
};

const byBarcode = async (req, res) => {
  const product = await prisma.product.findFirst({ where: { tenantId: req.user.tenantId, barcode: req.params.barcode }, include: includeStock });
  if (!product) return fail(res, 404, 'NOT_FOUND', 'Product not found');
  return ok(res, mapProduct(product));
};

const create = async (req, res) => {
  const body = req.body || {};
  if (!body.sku || !body.name || !body.category) return fail(res, 400, 'VALIDATION_ERROR', 'SKU, name and category are required');
  const product = await prisma.product.create({
    data: {
      tenantId: req.user.tenantId,
      sku: body.sku,
      barcode: body.barcode || null,
      name: body.name,
      description: body.description || null,
      category: body.category,
      unit: body.unit || 'unit',
      costPrice: body.costPrice || 0,
      sellingPrice: body.sellingPrice || 0,
      reorderLevel: Number(body.reorderLevel || 0),
      reorderQuantity: Number(body.reorderQuantity || 0),
      imageUrl: body.imageUrl || null,
    },
    include: includeStock,
  });
  return res.status(201).json({ data: mapProduct(product), meta: {} });
};

module.exports = { list, getById, lowStock, byBarcode, create };
