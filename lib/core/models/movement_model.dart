import 'package:flutter/material.dart';

import 'package:logitrack/core/theme/app_theme.dart';

enum MovementType { inbound, outbound, transfer }

extension MovementTypeX on MovementType {
  String get label {
    switch (this) {
      case MovementType.inbound:
        return 'Inbound';
      case MovementType.outbound:
        return 'Dispatch';
      case MovementType.transfer:
        return 'Transfer';
    }
  }

  IconData get icon {
    switch (this) {
      case MovementType.inbound:
        return Icons.download_rounded;
      case MovementType.outbound:
        return Icons.upload_rounded;
      case MovementType.transfer:
        return Icons.swap_horiz_rounded;
    }
  }

  Color get color {
    switch (this) {
      case MovementType.inbound:
        return AppColors.text;
      case MovementType.outbound:
      case MovementType.transfer:
        return AppColors.primary;
    }
  }
}

enum MovementStatus { pending, inProgress, enRoute, completed }

extension MovementStatusX on MovementStatus {
  String get label {
    switch (this) {
      case MovementStatus.pending:
        return 'Pending Carrier Pick-up';
      case MovementStatus.inProgress:
        return 'In Progress';
      case MovementStatus.enRoute:
        return 'Transit En-Route';
      case MovementStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case MovementStatus.pending:
      case MovementStatus.inProgress:
        return AppColors.orange;
      case MovementStatus.enRoute:
        return AppColors.primary;
      case MovementStatus.completed:
        return AppColors.green;
    }
  }
}

class MovementLine {
  const MovementLine({
    required this.sku,
    required this.name,
    required this.qty,
    this.loaded = false,
  });

  final String sku;
  final String name;
  final int qty;
  final bool loaded;
}

class MovementModel {
  const MovementModel({
    required this.id,
    required this.code,
    required this.type,
    required this.status,
    required this.timeLabel,
    required this.origin,
    required this.destination,
    required this.carrier,
    required this.dockBay,
    required this.lines,
    required this.footerIcon,
    required this.footerText,
    required this.actionLabel,
    this.actionIcon,
    this.palletsLoaded,
    this.palletsTotal,
    this.etaLabel,
    this.inspector,
    this.note,
  });

  final String id;
  final String code;
  final MovementType type;
  final MovementStatus status;
  final String timeLabel;
  final String origin;
  final String destination;
  final String carrier;
  final String dockBay;
  final List<MovementLine> lines;
  final IconData footerIcon;
  final String footerText;
  final String actionLabel;
  final IconData? actionIcon;
  final int? palletsLoaded;
  final int? palletsTotal;
  final String? etaLabel;
  final String? inspector;
  final String? note;

  // ===== Computed =====
  bool get hasProgress => palletsLoaded != null && palletsTotal != null;

  double get progress =>
      hasProgress ? (palletsLoaded! / palletsTotal!).clamp(0.0, 1.0) : 0;

  String get progressLabel =>
      '$palletsLoaded / $palletsTotal Pallets Loaded (${(progress * 100).round()}%)';

  int get totalUnits => lines.fold(0, (s, l) => s + l.qty);

  bool matches(String query) {
    if (query.trim().isEmpty) return true;
    final q = query.toLowerCase().trim();
    return code.toLowerCase().contains(q) ||
        origin.toLowerCase().contains(q) ||
        destination.toLowerCase().contains(q) ||
        carrier.toLowerCase().contains(q);
  }
}