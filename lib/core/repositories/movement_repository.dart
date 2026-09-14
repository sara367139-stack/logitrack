import 'package:flutter/material.dart';

import 'package:logitrack/core/models/movement_model.dart';

class MovementRepository {
  MovementRepository._();
  static final instance = MovementRepository._();

  final List<MovementModel> _all = const [
    MovementModel(
      id: 'm1',
      code: '#DISP-9021',
      type: MovementType.outbound,
      status: MovementStatus.inProgress,
      timeLabel: 'Created 10:15 AM today',
      origin: 'WH-North Bay Hub • Dock 04',
      destination: 'Apex Assembly Plant • Dock C',
      carrier: 'FedEx Freight #TRK-882',
      dockBay: 'Dock Bay 04',
      palletsLoaded: 3,
      palletsTotal: 5,
      footerIcon: Icons.dock_outlined,
      footerText: 'DR-FL   Dock Bay 04 assigned',
      actionLabel: 'Manage',
      lines: [
        MovementLine(
          sku: 'BEAR-6205-HD',
          name: 'Heavy-Duty Ball Bearings',
          qty: 640,
          loaded: true,
        ),
        MovementLine(
          sku: 'PACK-BX12-25',
          name: 'Corrugated Boxes 12x12',
          qty: 400,
          loaded: true,
        ),
        MovementLine(
          sku: 'CHEM-SIL-300',
          name: 'High-Temp Silicone',
          qty: 200,
        ),
      ],
      note:
          'Handle bearings with care — bottom tier packaging showed minor crush damage on previous shipment.',
    ),
    MovementModel(
      id: 'm2',
      code: '#INB-4410',
      type: MovementType.inbound,
      status: MovementStatus.completed,
      timeLabel: '08:45 AM today',
      origin: 'Global Fasteners Co.',
      destination: 'WH-North Bay Hub • Dock 02',
      carrier: 'Maersk Sea',
      dockBay: 'Dock 02',
      inspector: 'Sarah J.',
      footerIcon: Icons.person_outline,
      footerText: 'Inspector: Sarah J.',
      actionLabel: 'Receipt',
      actionIcon: Icons.receipt_long_outlined,
      lines: [
        MovementLine(
          sku: 'HDW-BOLT-M8',
          name: 'Hex Bolts M8 Galvanized',
          qty: 500,
          loaded: true,
        ),
      ],
    ),
    MovementModel(
      id: 'm3',
      code: '#TRF-1102',
      type: MovementType.transfer,
      status: MovementStatus.enRoute,
      timeLabel: 'Dispatched 25 mins ago',
      origin: 'WH-North (Zone A)',
      destination: 'WH-East (Zone C)',
      carrier: 'Internal Fleet',
      dockBay: 'Bay 01',
      etaLabel: 'ETA: 11:10 AM (15m)',
      footerIcon: Icons.access_time_rounded,
      footerText: 'ETA: 11:10 AM (15m)',
      actionLabel: 'Track',
      actionIcon: Icons.my_location_rounded,
      lines: [
        MovementLine(
          sku: 'SEAL-HYD-40',
          name: 'Hydraulic Seals',
          qty: 120,
          loaded: true,
        ),
      ],
    ),
    MovementModel(
      id: 'm4',
      code: '#DISP-9018',
      type: MovementType.outbound,
      status: MovementStatus.pending,
      timeLabel: 'Staged 07:30 AM',
      origin: 'WH-North Bay Hub • Lane 02',
      destination: 'Metro Distribution Center',
      carrier: 'DHL Freight',
      dockBay: 'Lane 02',
      footerIcon: Icons.schedule_rounded,
      footerText: 'Awaiting DHL Freight',
      actionLabel: 'Notify',
      actionIcon: Icons.notifications_none_rounded,
      lines: [
        MovementLine(
          sku: 'PACK-BX12-25',
          name: 'Corrugated Boxes 12x12',
          qty: 800,
          loaded: true,
        ),
      ],
    ),
    MovementModel(
      id: 'm5',
      code: '#INB-4415',
      type: MovementType.inbound,
      status: MovementStatus.inProgress,
      timeLabel: 'Arriving 02:00 PM',
      origin: 'Apex Precision Ltd.',
      destination: 'WH-North Bay Hub • Dock 04',
      carrier: 'FedEx Freight',
      dockBay: 'Dock 04',
      palletsLoaded: 1,
      palletsTotal: 6,
      footerIcon: Icons.dock_outlined,
      footerText: 'PO-2025-0892 linked',
      actionLabel: 'Receive',
      actionIcon: Icons.qr_code_scanner_rounded,
      lines: [
        MovementLine(
          sku: 'BEAR-6205-HD',
          name: 'Heavy-Duty Ball Bearings',
          qty: 500,
          loaded: true,
        ),
        MovementLine(
          sku: 'BEAR-6301-LT',
          name: 'Light-Duty Bearings 6301',
          qty: 300,
        ),
      ],
    ),
  ];

  // ===== Queries =====
  List<MovementModel> get all => List.unmodifiable(_all);

  MovementModel? byId(String id) {
    try {
      return _all.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  List<MovementModel> byType(MovementType t) =>
      _all.where((m) => m.type == t).toList();

  /// filterIndex: 0=All, 1=Completed, 2=In Progress
  bool _testStatus(int index, MovementModel m) {
    switch (index) {
      case 1:
        return m.status == MovementStatus.completed;
      case 2:
        return m.status == MovementStatus.inProgress ||
            m.status == MovementStatus.enRoute ||
            m.status == MovementStatus.pending;
      default:
        return true;
    }
  }

  List<MovementModel> query({
    required MovementType type,
    int statusFilter = 0,
    String search = '',
  }) {
    return _all
        .where((m) => m.type == type)
        .where((m) => _testStatus(statusFilter, m))
        .where((m) => m.matches(search))
        .toList();
  }

  int countStatus(MovementType t, int statusFilter) => _all
      .where((m) => m.type == t)
      .where((m) => _testStatus(statusFilter, m))
      .length;

  int get outboundUnitsToday => _all
      .where((m) => m.type == MovementType.outbound)
      .fold(0, (s, m) => s + m.totalUnits);

  int get activeDispatchRuns =>
      _all.where((m) => m.status != MovementStatus.completed).length;
}