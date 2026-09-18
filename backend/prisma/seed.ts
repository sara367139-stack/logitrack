import mongoose from 'mongoose';
import argon2 from 'argon2';
import { config } from '../src/config';
import { connectDatabase } from '../src/config/database';
import { 
  Tenant, User, Warehouse, Location, Supplier, Product, 
  PurchaseOrder, PurchaseOrderItem, InventoryBalance, 
  InventoryTransaction, Notification, AuditLog
} from '../src/models';

const DEV_PASSWORD = 'LogiTrack@2026!';

async function seed(): Promise<void> {
  console.log('🌱 Starting database seed...');
  
  await connectDatabase();
  
  await Promise.all([
    Tenant.deleteMany({}),
    User.deleteMany({}),
    Warehouse.deleteMany({}),
    Location.deleteMany({}),
    Supplier.deleteMany({}),
    Product.deleteMany({}),
    PurchaseOrder.deleteMany({}),
    PurchaseOrderItem.deleteMany({}),
    InventoryBalance.deleteMany({}),
    InventoryTransaction.deleteMany({}),
    Notification.deleteMany({}),
    AuditLog.deleteMany({}),
  ]);

  console.log('🗑️  Cleared existing data');

  const tenant = await Tenant.create({
    name: 'Demo Logistics',
    slug: 'demo-logistics',
    defaultCurrency: 'USD',
    timezone: 'UTC',
  });
  console.log('✅ Created tenant:', tenant.name);

  const passwordHash = await argon2.hash(DEV_PASSWORD);

  const owner = await User.create({
    tenantId: tenant._id,
    email: 'owner@logitrack.demo',
    passwordHash,
    firstName: 'Owner',
    lastName: 'User',
    role: 'owner',
    isActive: true,
  });

  const manager = await User.create({
    tenantId: tenant._id,
    email: 'manager@logitrack.demo',
    passwordHash,
    firstName: 'Manager',
    lastName: 'User',
    role: 'manager',
    isActive: true,
  });

  const operator = await User.create({
    tenantId: tenant._id,
    email: 'operator@logitrack.demo',
    passwordHash,
    firstName: 'Operator',
    lastName: 'User',
    role: 'operator',
    isActive: true,
  });

  const viewer = await User.create({
    tenantId: tenant._id,
    email: 'viewer@logitrack.demo',
    passwordHash,
    firstName: 'Viewer',
    lastName: 'User',
    role: 'viewer',
    isActive: true,
  });
  console.log('✅ Created users:', owner.email, manager.email, operator.email, viewer.email);

  const warehouse = await Warehouse.create({
    tenantId: tenant._id,
    name: 'Main Distribution Center',
    code: 'MDC',
    addressLine1: '123 Logistics Way',
    city: 'Springfield',
    country: 'USA',
    isActive: true,
  });
  console.log('✅ Created warehouse:', warehouse.name);

  const receiving = await Location.create({
    warehouseId: warehouse._id,
    name: 'Receiving Dock',
    code: 'RECV',
    type: 'receiving',
    isActive: true,
  });

  const zoneA = await Location.create({
    warehouseId: warehouse._id,
    name: 'Zone A',
    code: 'ZONE-A',
    type: 'zone',
    isActive: true,
  });

  const zoneB = await Location.create({
    warehouseId: warehouse._id,
    name: 'Zone B',
    code: 'ZONE-B',
    type: 'zone',
    isActive: true,
  });

  const dispatch = await Location.create({
    warehouseId: warehouse._id,
    name: 'Dispatch Area',
    code: 'DISPATCH',
    type: 'dispatch',
    isActive: true,
  });

  const shelfA1 = await Location.create({
    warehouseId: warehouse._id,
    parentId: zoneA._id,
    name: 'Shelf A1',
    code: 'ZONE-A-A1',
    type: 'shelf',
    capacity: 500,
    isActive: true,
  });

  const shelfA2 = await Location.create({
    warehouseId: warehouse._id,
    parentId: zoneA._id,
    name: 'Shelf A2',
    code: 'ZONE-A-A2',
    type: 'shelf',
    capacity: 500,
    isActive: true,
  });

  const shelfB1 = await Location.create({
    warehouseId: warehouse._id,
    parentId: zoneB._id,
    name: 'Shelf B1',
    code: 'ZONE-B-B1',
    type: 'shelf',
    capacity: 500,
    isActive: true,
  });
  console.log('✅ Created locations');

  const supplier1 = await Supplier.create({
    tenantId: tenant._id,
    name: 'Fastener Supply Co',
    contactName: 'John Smith',
    email: 'john@fastenersupply.com',
    phone: '+1-555-0101',
    address: '100 Industrial Blvd, Springfield, USA',
    isActive: true,
  });

  const supplier2 = await Supplier.create({
    tenantId: tenant._id,
    name: 'Electronic Components Ltd',
    contactName: 'Sarah Chen',
    email: 'sarah@electronics.com',
    phone: '+1-555-0102',
    address: '200 Tech Park, Springfield, USA',
    isActive: true,
  });

  const supplier3 = await Supplier.create({
    tenantId: tenant._id,
    name: 'Packaging Materials Inc',
    contactName: 'Mike Johnson',
    email: 'mike@packaging.com',
    phone: '+1-555-0103',
    address: '300 Box St, Springfield, USA',
    isActive: true,
  });
  console.log('✅ Created suppliers');

  const products = await Product.create([
    {
      tenantId: tenant._id,
      sku: 'BOLT-M8x50',
      barcode: '6291234567890',
      name: 'Steel Bolt M8x50mm',
      description: 'High-grade steel bolt, zinc plated',
      category: 'Fasteners',
      unit: 'unit',
      costPrice: 0.45,
      sellingPrice: 1.20,
      reorderLevel: 100,
      reorderQuantity: 500,
      isActive: true,
    },
    {
      tenantId: tenant._id,
      sku: 'NUT-M8',
      barcode: '6291234567891',
      name: 'Hex Nut M8',
      description: 'Standard hex nut, zinc plated',
      category: 'Fasteners',
      unit: 'unit',
      costPrice: 0.12,
      sellingPrice: 0.35,
      reorderLevel: 200,
      reorderQuantity: 1000,
      isActive: true,
    },
    {
      tenantId: tenant._id,
      sku: 'WASHER-M8',
      barcode: '6291234567892',
      name: 'Flat Washer M8',
      description: 'Flat washer for M8 bolts',
      category: 'Fasteners',
      unit: 'unit',
      costPrice: 0.05,
      sellingPrice: 0.15,
      reorderLevel: 300,
      reorderQuantity: 1500,
      isActive: true,
    },
    {
      tenantId: tenant._id,
      sku: 'SCREW-M4x20',
      barcode: '6291234567893',
      name: 'Machine Screw M4x20mm',
      description: 'Pan head machine screw',
      category: 'Fasteners',
      unit: 'unit',
      costPrice: 0.08,
      sellingPrice: 0.25,
      reorderLevel: 150,
      reorderQuantity: 750,
      isActive: true,
    },
    {
      tenantId: tenant._id,
      sku: 'RES-10K',
      barcode: '6291234567894',
      name: 'Resistor 10K Ohm 1/4W',
      description: 'Carbon film resistor 5% tolerance',
      category: 'Electronics',
      unit: 'unit',
      costPrice: 0.02,
      sellingPrice: 0.10,
      reorderLevel: 500,
      reorderQuantity: 2000,
      isActive: true,
    },
    {
      tenantId: tenant._id,
      sku: 'CAP-100UF',
      barcode: '6291234567895',
      name: 'Capacitor 100uF 25V',
      description: 'Electrolytic capacitor radial',
      category: 'Electronics',
      unit: 'unit',
      costPrice: 0.15,
      sellingPrice: 0.50,
      reorderLevel: 100,
      reorderQuantity: 500,
      isActive: true,
    },
    {
      tenantId: tenant._id,
      sku: 'LED-RED-5MM',
      barcode: '6291234567896',
      name: 'Red LED 5mm',
      description: 'Diffused red LED, 20mA',
      category: 'Electronics',
      unit: 'unit',
      costPrice: 0.05,
      sellingPrice: 0.20,
      reorderLevel: 200,
      reorderQuantity: 1000,
      isActive: true,
    },
    {
      tenantId: tenant._id,
      sku: 'BOX-SMALL',
      barcode: '6291234567897',
      name: 'Small Cardboard Box',
      description: '150x100x50mm corrugated box',
      category: 'Packaging',
      unit: 'unit',
      costPrice: 0.35,
      sellingPrice: 0.85,
      reorderLevel: 50,
      reorderQuantity: 200,
      isActive: true,
    },
    {
      tenantId: tenant._id,
      sku: 'TAPE-PACKING',
      barcode: '6291234567898',
      name: 'Packing Tape 48mm x 50m',
      description: 'Clear polypropylene packing tape',
      category: 'Packaging',
      unit: 'roll',
      costPrice: 1.20,
      sellingPrice: 3.50,
      reorderLevel: 30,
      reorderQuantity: 100,
      isActive: true,
    },
    {
      tenantId: tenant._id,
      sku: 'BUBBLE-WRAP',
      barcode: '6291234567899',
      name: 'Bubble Wrap Roll 500mm x 10m',
      description: 'Protective bubble wrap for shipping',
      category: 'Packaging',
      unit: 'roll',
      costPrice: 8.50,
      sellingPrice: 22.00,
      reorderLevel: 10,
      reorderQuantity: 30,
      isActive: true,
    },
  ]);
  console.log('✅ Created products');

  await InventoryBalance.insertMany([
    { productId: products[0]._id, locationId: shelfA1._id, quantity: 250, reservedQuantity: 10, updatedAt: new Date() },
    { productId: products[1]._id, locationId: shelfA1._id, quantity: 500, reservedQuantity: 20, updatedAt: new Date() },
    { productId: products[2]._id, locationId: shelfA1._id, quantity: 800, reservedQuantity: 30, updatedAt: new Date() },
    { productId: products[3]._id, locationId: shelfA2._id, quantity: 300, reservedQuantity: 15, updatedAt: new Date() },
    { productId: products[4]._id, locationId: shelfB1._id, quantity: 1000, reservedQuantity: 50, updatedAt: new Date() },
    { productId: products[5]._id, locationId: shelfB1._id, quantity: 400, reservedQuantity: 20, updatedAt: new Date() },
    { productId: products[6]._id, locationId: shelfB1._id, quantity: 600, reservedQuantity: 25, updatedAt: new Date() },
    { productId: products[7]._id, locationId: dispatch._id, quantity: 100, reservedQuantity: 5, updatedAt: new Date() },
    { productId: products[8]._id, locationId: dispatch._id, quantity: 50, reservedQuantity: 2, updatedAt: new Date() },
    { productId: products[9]._id, locationId: dispatch._id, quantity: 25, reservedQuantity: 1, updatedAt: new Date() },
  ]);
  console.log('✅ Created inventory balances');

  const po1 = await PurchaseOrder.create({
    tenantId: tenant._id,
    supplierId: supplier1._id,
    warehouseId: warehouse._id,
    orderNumber: 'PO-2026-001',
    status: 'received',
    expectedDate: new Date('2026-09-10'),
    notes: 'Monthly fastener restock',
    createdBy: owner._id,
    approvedBy: manager._id,
  });

  const po2 = await PurchaseOrder.create({
    tenantId: tenant._id,
    supplierId: supplier2._id,
    warehouseId: warehouse._id,
    orderNumber: 'PO-2026-002',
    status: 'partial',
    expectedDate: new Date('2026-09-15'),
    notes: 'Electronic components order',
    createdBy: owner._id,
    approvedBy: manager._id,
  });

  const po3 = await PurchaseOrder.create({
    tenantId: tenant._id,
    supplierId: supplier3._id,
    warehouseId: warehouse._id,
    orderNumber: 'PO-2026-003',
    status: 'submitted',
    expectedDate: new Date('2026-09-20'),
    notes: 'Packaging materials quarterly order',
    createdBy: owner._id,
  });
  console.log('✅ Created purchase orders');

  await PurchaseOrderItem.insertMany([
    { purchaseOrderId: po1._id, productId: products[0]._id, orderedQuantity: 200, receivedQuantity: 200, unitCost: 0.40 },
    { purchaseOrderId: po1._id, productId: products[1]._id, orderedQuantity: 400, receivedQuantity: 400, unitCost: 0.10 },
    { purchaseOrderId: po1._id, productId: products[2]._id, orderedQuantity: 600, receivedQuantity: 600, unitCost: 0.04 },
    { purchaseOrderId: po2._id, productId: products[4]._id, orderedQuantity: 800, receivedQuantity: 400, unitCost: 0.018 },
    { purchaseOrderId: po2._id, productId: products[5]._id, orderedQuantity: 300, receivedQuantity: 150, unitCost: 0.12 },
    { purchaseOrderId: po2._id, productId: products[6]._id, orderedQuantity: 500, receivedQuantity: 0, unitCost: 0.04 },
    { purchaseOrderId: po3._id, productId: products[7]._id, orderedQuantity: 100, receivedQuantity: 0, unitCost: 0.30 },
    { purchaseOrderId: po3._id, productId: products[8]._id, orderedQuantity: 50, receivedQuantity: 0, unitCost: 1.00 },
    { purchaseOrderId: po3._id, productId: products[9]._id, orderedQuantity: 25, receivedQuantity: 0, unitCost: 7.50 },
  ]);
  console.log('✅ Created purchase order items');

  await InventoryTransaction.insertMany([
    {
      tenantId: tenant._id,
      productId: products[0]._id,
      toLocationId: shelfA1._id,
      quantity: 250,
      type: 'receive',
      referenceType: 'purchase_order',
      referenceId: po1._id,
      reason: 'Received from PO-2026-001',
      performedBy: operator._id,
    },
    {
      tenantId: tenant._id,
      productId: products[1]._id,
      toLocationId: shelfA1._id,
      quantity: 500,
      type: 'receive',
      referenceType: 'purchase_order',
      referenceId: po1._id,
      reason: 'Received from PO-2026-001',
      performedBy: operator._id,
    },
    {
      tenantId: tenant._id,
      productId: products[2]._id,
      toLocationId: shelfA1._id,
      quantity: 800,
      type: 'receive',
      referenceType: 'purchase_order',
      referenceId: po1._id,
      reason: 'Received from PO-2026-001',
      performedBy: operator._id,
    },
    {
      tenantId: tenant._id,
      productId: products[3]._id,
      toLocationId: shelfA2._id,
      quantity: 300,
      type: 'receive',
      referenceType: 'purchase_order',
      referenceId: po1._id,
      reason: 'Received from PO-2026-001',
      performedBy: operator._id,
    },
    {
      tenantId: tenant._id,
      productId: products[4]._id,
      toLocationId: shelfB1._id,
      quantity: 400,
      type: 'receive',
      referenceType: 'purchase_order',
      referenceId: po2._id,
      reason: 'Partial receipt from PO-2026-002',
      performedBy: operator._id,
    },
    {
      tenantId: tenant._id,
      productId: products[5]._id,
      toLocationId: shelfB1._id,
      quantity: 150,
      type: 'receive',
      referenceType: 'purchase_order',
      referenceId: po2._id,
      reason: 'Partial receipt from PO-2026-002',
      performedBy: operator._id,
    },
    {
      tenantId: tenant._id,
      productId: products[0]._id,
      fromLocationId: shelfA1._id,
      toLocationId: dispatch._id,
      quantity: 20,
      type: 'move',
      referenceType: 'manual',
      reason: 'Moved to dispatch area for shipping',
      performedBy: operator._id,
    },
    {
      tenantId: tenant._id,
      productId: products[1]._id,
      fromLocationId: shelfA1._id,
      toLocationId: dispatch._id,
      quantity: 30,
      type: 'dispatch',
      referenceType: 'shipment',
      referenceId: new mongoose.Types.ObjectId(),
      reason: 'Dispatched for order SHIP-10082',
      performedBy: operator._id,
    },
  ]);
  console.log('✅ Created inventory transactions');

  await Notification.insertMany([
    {
      tenantId: tenant._id,
      userId: manager._id,
      type: 'low_stock',
      title: 'Low Stock Alert',
      message: 'Steel Bolt M8x50mm (BOLT-M8x50) has reached reorder level',
      data: { productId: products[0]._id, currentQuantity: 250, reorderLevel: 100 },
      readAt: null,
    },
    {
      tenantId: tenant._id,
      userId: operator._id,
      type: 'receiving_complete',
      title: 'Receiving Complete',
      message: 'Purchase order PO-2026-001 has been fully received',
      data: { purchaseOrderId: po1._id },
      readAt: null,
    },
    {
      tenantId: tenant._id,
      type: 'system',
      title: 'Welcome to LogiTrack',
      message: 'Your warehouse management system is ready. Start by exploring the dashboard.',
      data: {},
      readAt: null,
    },
  ]);
  console.log('✅ Created notifications');

  await AuditLog.insertMany([
    {
      tenantId: tenant._id,
      userId: owner._id,
      action: 'tenant_create',
      entityType: 'tenant',
      entityId: tenant._id,
      afterData: { name: tenant.name, slug: tenant.slug },
    },
    {
      tenantId: tenant._id,
      userId: owner._id,
      action: 'warehouse_create',
      entityType: 'warehouse',
      entityId: warehouse._id,
      afterData: { name: warehouse.name, code: warehouse.code },
    },
    {
      tenantId: tenant._id,
      userId: owner._id,
      action: 'product_create',
      entityType: 'product',
      entityId: products[0]._id,
      afterData: { sku: products[0].sku, name: products[0].name },
    },
  ]);
  console.log('✅ Created audit logs');

  console.log('\n🎉 Seed completed successfully!');
  console.log('\n📋 Development Credentials:');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log(`Tenant: Demo Logistics`);
  console.log(`Owner:    owner@logitrack.demo / ${DEV_PASSWORD}`);
  console.log(`Manager:  manager@logitrack.demo / ${DEV_PASSWORD}`);
  console.log(`Operator: operator@logitrack.demo / ${DEV_PASSWORD}`);
  console.log(`Viewer:   viewer@logitrack.demo / ${DEV_PASSWORD}`);
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  console.log('⚠️  NEVER USE THESE CREDENTIALS IN PRODUCTION!');
  
  await mongoose.connection.close();
  process.exit(0);
}

seed().catch((error) => {
  console.error('❌ Seed failed:', error);
  process.exit(1);
});