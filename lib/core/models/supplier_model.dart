import 'package:flutter/material.dart';

import 'package:logitrack/core/theme/app_theme.dart';

enum PartnerType { supplier, customer }

enum SupplierTier { tier1, strategic, preferred, standard }

extension SupplierTierX on SupplierTier {
  String get label {
    switch (this) {
      case SupplierTier.tier1:
        return 'Tier 1';
      case SupplierTier.strategic:
        return 'Strategic';
      case SupplierTier.preferred:
        return 'Preferred';
      case SupplierTier.standard:
        return 'Standard';
    }
  }

  Color get color {
    switch (this) {
      case SupplierTier.tier1:
        return AppColors.primary;
      case SupplierTier.strategic:
        return AppColors.green;
      case SupplierTier.preferred:
        return AppColors.orange;
      case SupplierTier.standard:
        return AppColors.secondaryText;
    }
  }
}

class SupplierModel {
  const SupplierModel({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.type,
    required this.tier,
    required this.rating,
    required this.onTimePercent,
    required this.activePos,
    required this.pipelineValue,
    required this.contactName,
    required this.contactRole,
    required this.contactEmail,
    required this.contactPhone,
    required this.paymentTerms,
    required this.leadTimeDays,
    required this.address,
    required this.icon,
  });

  final String id;
  final String code;
  final String name;
  final String category;
  final PartnerType type;
  final SupplierTier tier;
  final double rating;
  final double onTimePercent;
  final int activePos;
  final double pipelineValue;
  final String contactName;
  final String contactRole;
  final String contactEmail;
  final String contactPhone;
  final String paymentTerms;
  final int leadTimeDays;
  final String address;
  final IconData icon;

  // ===== Computed =====
  String get initials {
    final parts = contactName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return contactName.substring(0, 2).toUpperCase();
  }

  String get ratingLabel => rating.toStringAsFixed(1);

  String get onTimeLabel => '${onTimePercent.toStringAsFixed(1)}% On-Time';

  String get pipelineLabel =>
      '$activePos PO${activePos == 1 ? '' : 's'} • \$${_fmt(pipelineValue)}';

  String get contactFull => '$contactName ($contactRole)';

  static String _fmt(double v) {
    final s = v.toStringAsFixed(0);
    return s.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  bool matches(String query) {
    if (query.trim().isEmpty) return true;
    final q = query.toLowerCase().trim();
    return code.toLowerCase().contains(q) ||
        name.toLowerCase().contains(q) ||
        category.toLowerCase().contains(q) ||
        contactName.toLowerCase().contains(q);
  }
}