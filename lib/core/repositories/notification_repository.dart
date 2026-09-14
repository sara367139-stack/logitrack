import 'package:flutter/material.dart';

import 'package:logitrack/core/models/notification_model.dart';

class NotificationRepository {
  NotificationRepository._();
  static final instance = NotificationRepository._();

  final List<NotificationModel> _all = const [
    NotificationModel(
      id: 'n1',
      kind: NotifKind.critical,
      group: NotifGroup.today,
      category: 'alerts',
      title: 'Critical Stock Alert',
      body:
          'SKU-4092 Hydraulic Seal reached critical threshold (12 remaining). Automated PO suggested.',
      timeLabel: '12m ago',
      tag: 'CRITICAL',
      locationTag: 'BIN-D12',
      icon: Icons.error_outline_rounded,
      actionLabel: 'Create PO',
      unread: true,
    ),
    NotificationModel(
      id: 'n2',
      kind: NotifKind.warning,
      group: NotifGroup.today,
      category: 'audit',
      title: 'Audit Discrepancy Flag',
      body:
          'Sarah J. recorded a -4 unit discrepancy on BEAR-6205-HD in Bin B3 during cycle count.',
      timeLabel: '35m ago',
      tag: 'AUDIT',
      locationTag: 'Zone B • Bin B3',
      icon: Icons.warning_amber_rounded,
      actionLabel: 'Re-audit',
      unread: true,
    ),
    NotificationModel(
      id: 'n3',
      kind: NotifKind.info,
      group: NotifGroup.today,
      category: 'orders',
      title: 'Inbound Dock Arrival',
      body:
          'PO #PO-2025-0892 from Apex Precision has arrived at Dock Bay 02 for unloading.',
      timeLabel: '1h ago',
      tag: 'INBOUND',
      locationTag: 'Deck 02',
      icon: Icons.local_shipping_outlined,
      actionLabel: 'Start Receiving',
      unread: true,
    ),
    NotificationModel(
      id: 'n4',
      kind: NotifKind.success,
      group: NotifGroup.yesterday,
      category: 'orders',
      title: 'PO Acknowledged',
      body:
          'Global Semiconductor confirmed PO #PO-2025-0889. Target ship date Oct 28.',
      timeLabel: 'Yesterday',
      tag: 'VENDOR',
      locationTag: 'Vendor Confirmed',
      icon: Icons.assignment_turned_in_outlined,
      actionLabel: 'Manifest',
    ),
    NotificationModel(
      id: 'n5',
      kind: NotifKind.warning,
      group: NotifGroup.yesterday,
      category: 'alerts',
      title: 'Expiration Warning',
      body:
          'Batch #EXP-881 Industrial Adhesive expires in 7 days. Recommended FIFO dispatch.',
      timeLabel: 'Yesterday',
      tag: 'EXPIRY',
      locationTag: 'Rack R-04',
      icon: Icons.event_busy_outlined,
      actionLabel: 'Queue Transfer',
    ),
    NotificationModel(
      id: 'n6',
      kind: NotifKind.success,
      group: NotifGroup.earlier,
      category: 'audit',
      title: 'Audit Session Completed',
      body:
          'Aisle 4 North Sweep finished — 24/24 bins verified. Variance: -4 units.',
      timeLabel: '2 days ago',
      tag: 'AUDIT',
      locationTag: 'Aisle 4',
      icon: Icons.check_circle_outline_rounded,
      actionLabel: 'View Report',
    ),
  ];

  // ===== Filters =====
  static const filterLabels = ['All', 'Alerts', 'Orders', 'Audit'];
  static const filterKeys = ['all', 'alerts', 'orders', 'audit'];

  // ===== Queries =====
  List<NotificationModel> get all => List.unmodifiable(_all);

  int get unreadCount => _all.where((n) => n.unread).length;

  int get criticalCount =>
      _all.where((n) => n.kind == NotifKind.critical).length;

  int get warningCount =>
      _all.where((n) => n.kind == NotifKind.warning).length;

  int get infoCount => _all
      .where((n) =>
          n.kind == NotifKind.info || n.kind == NotifKind.success)
      .length;

  int countFor(int filterIndex) {
    final key = filterKeys[filterIndex];
    return _all.where((n) => n.matchesCategory(key)).length;
  }

  List<NotificationModel> query({int filterIndex = 0}) {
    final key = filterKeys[filterIndex];
    return _all.where((n) => n.matchesCategory(key)).toList();
  }

  List<NotificationModel> byGroup(NotifGroup g, {int filterIndex = 0}) =>
      query(filterIndex: filterIndex)
          .where((n) => n.group == g)
          .toList();
}