import 'package:flutter/material.dart';

import 'package:logitrack/core/models/product_model.dart';

class ProductFilter {
  const ProductFilter({
    required this.label,
    required this.test,
  });

  final String label;
  final bool Function(ProductModel) test;
}

class ProductRepository {
  ProductRepository._();
  static final instance = ProductRepository._();

  // ===== Mock Data =====
  final List<ProductModel> _all = const [
    ProductModel(
      id: '1',
      sku: 'BEAR-6205-HD',
      barcode: '079357318921',
      name: 'Heavy-Duty Ball Bearings 6205-2RS',
      category: 'Bearings',
      price: 18.50,
      unit: '/ unit',
      currentQty: 340,
      maxQty: 400,
      minQty: 50,
      zone: 'Zone A',
      aisle: 'Aisle A4',
      rack: 'Rack 02',
      bin: 'Bin B3',
      status: StockStatus.inStock,
      icon: Icons.settings_rounded,
    ),
    ProductModel(
      id: '2',
      sku: 'ELEC-STM32-DEV',
      barcode: '890123456788',
      name: 'Microcontroller STM32 Dev Board',
      category: 'Electronics',
      price: 24.00,
      unit: '/ unit',
      currentQty: 14,
      maxQty: 500,
      minQty: 100,
      zone: 'Zone B',
      aisle: 'Aisle 1',
      rack: 'Rack 01',
      bin: 'Shelf 04',
      status: StockStatus.lowStock,
      icon: Icons.memory_rounded,
      warning: 'Reorder threshold reached',
    ),
    ProductModel(
      id: '3',
      sku: 'CHEM-SIL-300',
      barcode: '451234567890',
      name: 'High-Temp Silicone Sealant',
      category: 'Chemicals',
      price: 9.75,
      unit: '/ unit',
      currentQty: 0,
      maxQty: 300,
      minQty: 60,
      zone: 'Zone C',
      aisle: 'Flammable Aisle',
      rack: 'Rack 05',
      bin: 'Bin 1',
      status: StockStatus.outOfStock,
      icon: Icons.science_rounded,
      warning: 'Stock Depleted',
    ),
    ProductModel(
      id: '4',
      sku: 'PACK-BX12-25',
      barcode: '123456789012',
      name: 'Corrugated Boxes 12x12',
      category: 'Packaging',
      price: 32.00,
      unit: '/ bundle',
      currentQty: 1200,
      maxQty: 1200,
      minQty: 200,
      zone: 'Zone D',
      aisle: 'Bulk Aisle',
      rack: 'Pallet 09',
      bin: 'Bulk Pallet 09',
      status: StockStatus.optimal,
      icon: Icons.inventory_rounded,
    ),
    ProductModel(
      id: '5',
      sku: 'BEAR-6301-LT',
      barcode: '079357318955',
      name: 'Light-Duty Ball Bearings 6301',
      category: 'Bearings',
      price: 8.40,
      unit: '/ unit',
      currentQty: 128,
      maxQty: 300,
      minQty: 50,
      zone: 'Zone A',
      aisle: 'Aisle A4',
      rack: 'Rack 03',
      bin: 'Bin C1',
      status: StockStatus.inStock,
      icon: Icons.settings_rounded,
    ),
    ProductModel(
      id: '6',
      sku: 'AUTO-FLT-88',
      barcode: '551234098766',
      name: 'Automotive Fluid Filter',
      category: 'Automotive',
      price: 14.20,
      unit: '/ unit',
      currentQty: 42,
      maxQty: 400,
      minQty: 80,
      zone: 'Zone A',
      aisle: 'Aisle A3',
      rack: 'Rack 01',
      bin: 'Bin A3',
      status: StockStatus.lowStock,
      icon: Icons.filter_alt_rounded,
      warning: 'Below safety stock',
    ),
    ProductModel(
      id: '7',
      sku: 'ELEC-CAP-470',
      barcode: '778812340099',
      name: 'Electrolytic Capacitor 470uF',
      category: 'Electronics',
      price: 1.35,
      unit: '/ unit',
      currentQty: 3800,
      maxQty: 5000,
      minQty: 800,
      zone: 'Zone B',
      aisle: 'Aisle 2',
      rack: 'Rack 04',
      bin: 'Shelf 11',
      status: StockStatus.inStock,
      icon: Icons.bolt_rounded,
    ),
    ProductModel(
      id: '8',
      sku: 'CHEM-ADH-50',
      barcode: '332211004455',
      name: 'Industrial Adhesive Poly-50',
      category: 'Chemicals',
      price: 27.90,
      unit: '/ canister',
      currentQty: 38,
      maxQty: 200,
      minQty: 40,
      zone: 'Zone C',
      aisle: 'Chemical Aisle',
      rack: 'Rack C-12',
      bin: 'Bin 4',
      status: StockStatus.lowStock,
      icon: Icons.water_drop_rounded,
      warning: 'Expires in 7 days • FIFO',
    ),
  ];

  // ===== Filters =====
  List<ProductFilter> get filters => [
        ProductFilter(label: 'All', test: (_) => true),
        ProductFilter(
          label: 'Low Stock',
          test: (p) =>
              p.status == StockStatus.lowStock ||
              p.status == StockStatus.outOfStock,
        ),
        ProductFilter(
          label: 'Bearings',
          test: (p) => p.category == 'Bearings',
        ),
        ProductFilter(
          label: 'Electronics',
          test: (p) => p.category == 'Electronics',
        ),
        ProductFilter(
          label: 'Chemicals',
          test: (p) => p.category == 'Chemicals',
        ),
        ProductFilter(
          label: 'Packaging',
          test: (p) => p.category == 'Packaging',
        ),
        ProductFilter(
          label: 'Automotive',
          test: (p) => p.category == 'Automotive',
        ),
      ];

  // ===== Queries =====
  List<ProductModel> get all => List.unmodifiable(_all);

  int get totalCount => _all.length;

  int countFor(int filterIndex) =>
      _all.where(filters[filterIndex].test).length;

  ProductModel? byId(String id) {
    try {
      return _all.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  ProductModel? bySku(String sku) {
    try {
      return _all.firstWhere(
          (p) => p.sku.toLowerCase() == sku.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  /// فلترة + بحث + ترتيب
  List<ProductModel> query({
    String search = '',
    int filterIndex = 0,
    ProductSort sort = ProductSort.stockLowToHigh,
  }) {
    var list = _all
        .where(filters[filterIndex].test)
        .where((p) => p.matches(search))
        .toList();

    switch (sort) {
      case ProductSort.stockLowToHigh:
        list.sort((a, b) => a.currentQty.compareTo(b.currentQty));
        break;
      case ProductSort.stockHighToLow:
        list.sort((a, b) => b.currentQty.compareTo(a.currentQty));
        break;
      case ProductSort.nameAZ:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ProductSort.priceHighToLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
    }

    return list;
  }

  double get totalValuation =>
      _all.fold(0, (sum, p) => sum + p.totalValue);

  int get lowStockCount => _all
      .where((p) =>
          p.status == StockStatus.lowStock ||
          p.status == StockStatus.outOfStock)
      .length;
}

enum ProductSort {
  stockLowToHigh,
  stockHighToLow,
  nameAZ,
  priceHighToLow,
}

extension ProductSortX on ProductSort {
  String get label {
    switch (this) {
      case ProductSort.stockLowToHigh:
        return 'Stock: Low to High';
      case ProductSort.stockHighToLow:
        return 'Stock: High to Low';
      case ProductSort.nameAZ:
        return 'Name: A → Z';
      case ProductSort.priceHighToLow:
        return 'Price: High to Low';
    }
  }
}