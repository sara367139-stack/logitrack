import 'package:flutter/material.dart';

import 'package:logitrack/core/theme/app_theme.dart';

enum StockStatus { inStock, lowStock, outOfStock, optimal }

extension StockStatusX on StockStatus {
  String get label {
    switch (this) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
      case StockStatus.optimal:
        return 'Optimal';
    }
  }

  Color get color {
    switch (this) {
      case StockStatus.inStock:
        return AppColors.green;
      case StockStatus.lowStock:
        return AppColors.orange;
      case StockStatus.outOfStock:
        return AppColors.red;
      case StockStatus.optimal:
        return AppColors.primary;
    }
  }
}

class ProductModel {
  const ProductModel({
    required this.id,
    required this.sku,
    required this.barcode,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    required this.currentQty,
    required this.maxQty,
    required this.minQty,
    required this.zone,
    required this.aisle,
    required this.rack,
    required this.bin,
    required this.status,
    required this.icon,
    this.warning,
  });

  final String id;
  final String sku;
  final String barcode;
  final String name;
  final String category;
  final double price;
  final String unit;
  final int currentQty;
  final int maxQty;
  final int minQty;
  final String zone;
  final String aisle;
  final String rack;
  final String bin;
  final StockStatus status;
  final IconData icon;
  final String? warning;

  // ===== Computed =====
  double get progress =>
      maxQty == 0 ? 0 : (currentQty / maxQty).clamp(0.0, 1.0);

  String get priceLabel => '\$${price.toStringAsFixed(2)}';

  String get location => '$zone • $aisle • $bin';

  String get capacityLabel {
    if (status == StockStatus.outOfStock) return 'Stock Depleted';
    if (status == StockStatus.lowStock) return 'Reorder threshold reached';
    if (status == StockStatus.optimal) return 'Storage Capacity';
    return 'Available Capacity';
  }

  String get capacityValue {
    if (status == StockStatus.outOfStock) return '0 Units';
    if (status == StockStatus.lowStock) {
      return '$currentQty Units / $minQty min';
    }
    return '$currentQty Units / $maxQty target';
  }

  double get totalValue => currentQty * price;

  /// البحث
  bool matches(String query) {
    if (query.trim().isEmpty) return true;
    final q = query.toLowerCase().trim();
    return sku.toLowerCase().contains(q) ||
        name.toLowerCase().contains(q) ||
        barcode.contains(q) ||
        category.toLowerCase().contains(q) ||
        location.toLowerCase().contains(q);
  }
}