import 'package:flutter/material.dart';

import 'package:logitrack/core/theme/app_theme.dart';

enum PoStatus {
  draft,
  awaitingApproval,
  approved,
  inTransit,
  received,
  reconciled,
}

extension PoStatusX on PoStatus {
  String get label {
    switch (this) {
      case PoStatus.draft:
        return 'Draft';
      case PoStatus.awaitingApproval:
        return 'Awaiting Acknowledgment';
      case PoStatus.approved:
        return 'Approved';
      case PoStatus.inTransit:
        return 'In-Transit';
      case PoStatus.received:
        return 'Received';
      case PoStatus.reconciled:
        return 'Reconciled';
    }
  }

  Color get color {
    switch (this) {
      case PoStatus.draft:
        return AppColors.secondaryText;
      case PoStatus.awaitingApproval:
        return AppColors.orange;
      case PoStatus.approved:
        return AppColors.primary;
      case PoStatus.inTransit:
        return AppColors.primary;
      case PoStatus.received:
      case PoStatus.reconciled:
        return AppColors.green;
    }
  }

  /// الخطوة في الـ Stepper (0..3)
  int get step {
    switch (this) {
      case PoStatus.draft:
        return 0;
      case PoStatus.awaitingApproval:
      case PoStatus.approved:
        return 1;
      case PoStatus.inTransit:
        return 2;
      case PoStatus.received:
      case PoStatus.reconciled:
        return 3;
    }
  }
}

class PoLineItem {
  const PoLineItem({
    required this.sku,
    required this.name,
    required this.qty,
    required this.unitPrice,
  });

  final String sku;
  final String name;
  final int qty;
  final double unitPrice;

  double get total => qty * unitPrice;
}

class PurchaseOrderModel {
  const PurchaseOrderModel({
    required this.id,
    required this.code,
    required this.supplierId,
    required this.supplierName,
    required this.status,
    required this.createdAt,
    required this.expectedAt,
    required this.lines,
    required this.carrier,
    required this.dockBay,
    this.priority = 'Standard',
    this.note,
  });

  final String id;
  final String code;
  final String supplierId;
  final String supplierName;
  final PoStatus status;
  final DateTime createdAt;
  final DateTime expectedAt;
  final List<PoLineItem> lines;
  final String carrier;
  final String dockBay;
  final String priority;
  final String? note;

  // ===== Computed =====
  double get subtotal => lines.fold(0, (s, l) => s + l.total);
  double get tax => subtotal * 0.14;
  double get total => subtotal + tax;

  int get totalUnits => lines.fold(0, (s, l) => s + l.qty);

  String get amountLabel => '\$${_fmt(total)}';

  String get itemsLabel =>
      '${lines.length} item${lines.length == 1 ? '' : 's'} • ${_fmt(totalUnits.toDouble())} units';

  bool get isActive =>
      status == PoStatus.inTransit || status == PoStatus.approved;

  static String _fmt(double v) {
    final s = v.toStringAsFixed(v % 1 == 0 ? 0 : 2);
    final parts = s.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return parts.length > 1 ? '$intPart.${parts[1]}' : intPart;
  }

  bool matches(String query) {
    if (query.trim().isEmpty) return true;
    final q = query.toLowerCase().trim();
    return code.toLowerCase().contains(q) ||
        supplierName.toLowerCase().contains(q) ||
        lines.any((l) =>
            l.sku.toLowerCase().contains(q) ||
            l.name.toLowerCase().contains(q));
  }
}