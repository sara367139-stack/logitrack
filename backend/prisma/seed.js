require('dotenv').config();
const bcrypt = require('bcryptjs');
const prisma = require('../src/config/prisma');

async function main() {
  const passwordHash = await bcrypt.hash('123456', 12);
  const tenant = await prisma.tenant.upsert({
    where: { slug: 'demo-logitrack' },
    update: {},
    create: { name: 'Demo Logistics', slug: 'demo-logitrack' },
  });

  const user = await prisma.user.upsert({
    where: { tenantId_email: { tenantId: tenant.id, email: 'alex@example.com' } },
    update: { passwordHash },
    create: {
      tenantId: tenant.id,
      email: 'alex@example.com',
      passwordHash,
      firstName: 'Alex',
      lastName: 'Khan',
      role: 'OWNER',
    },
  });

  const warehouse = await prisma.warehouse.upsert({
    where: { tenantId_code: { tenantId: tenant.id, code: 'NBH' } },
    update: {},
    create: { tenantId: tenant.id, name: 'North Bay Hub', code: 'NBH', city: 'New York', country: 'USA' },
  });
  const location = await prisma.location.upsert({
    where: { warehouseId_code: { warehouseId: warehouse.id, code: 'ZONE-A' } },
    update: {},
    create: { warehouseId: warehouse.id, name: 'Zone A', code: 'ZONE-A', type: 'zone', capacity: 1200 },
  });
  const product = await prisma.product.upsert({
    where: { tenantId_sku: { tenantId: tenant.id, sku: 'BOLT-001' } },
    update: {},
    create: {
      tenantId: tenant.id,
      sku: 'BOLT-001',
      barcode: '6291234567890',
      name: 'Steel Bolt M8x50',
      category: 'Fasteners',
      unit: 'unit',
      costPrice: 0.5,
      sellingPrice: 1.2,
      reorderLevel: 100,
      reorderQuantity: 500,
    },
  });
  await prisma.inventoryBalance.upsert({
    where: { productId_locationId: { productId: product.id, locationId: location.id } },
    update: { quantity: 220 },
    create: { productId: product.id, warehouseId: warehouse.id, locationId: location.id, quantity: 220 },
  });

  console.log(`Seeded ${user.email} / 123456`);
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(() => prisma.$disconnect());
