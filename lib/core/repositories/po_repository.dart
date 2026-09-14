import 'package:logitrack/core/models/purchase_order_model.dart';

class PoRepository {
  PoRepository._();
  static final instance = PoRepository._();

  final List<PurchaseOrderModel> _all = [
    PurchaseOrderModel(
      id: 'po1',
      code: 'PO-2025-0892',
      supplierId: 's1',
      supplierName: 'Apex Precision Ltd.',
      status: PoStatus.inTransit,
      createdAt: DateTime(2025, 10, 22, 10, 15),
      expectedAt: DateTime(2025, 10, 24, 14, 0),
      carrier: 'FedEx Freight',
      dockBay: 'Bay 04',
      priority: 'Standard',
      lines: const [
        PoLineItem(
          sku: 'BEAR-6205-HD',
          name: 'Heavy-Duty Ball Bearings',
          qty: 500,
          unitPrice: 11.20,
        ),
        PoLineItem(
          sku: 'BEAR-6301-LT',
          name: 'Light-Duty Bearings 6301',
          qty: 300,
          unitPrice: 8.40,
        ),
        PoLineItem(
          sku: 'BEAR-6002-STD',
          name: 'Standard Bearing 6002',
          qty: 200,
          unitPrice: 6.75,
        ),
      ],
    ),
    PurchaseOrderModel(
      id: 'po2',
      code: 'PO-2025-0889',
      supplierId: 's2',
      supplierName: 'Global Semiconductor Alliance',
      status: PoStatus.awaitingApproval,
      createdAt: DateTime(2025, 10, 20, 8, 30),
      expectedAt: DateTime(2025, 10, 28),
      carrier: 'DHL Express',
      dockBay: 'Bay 02',
      priority: 'Priority A1',
      lines: const [
        PoLineItem(
          sku: 'ELEC-STM32-DEV',
          name: 'Microcontroller STM32 Board',
          qty: 1500,
          unitPrice: 24.00,
        ),
        PoLineItem(
          sku: 'ELEC-CAP-470',
          name: 'Electrolytic Capacitor 470uF',
          qty: 1000,
          unitPrice: 1.35,
        ),
      ],
    ),
    PurchaseOrderModel(
      id: 'po3',
      code: 'PO-2025-0874',
      supplierId: 's4',
      supplierName: 'Industrial Chemicals Direct',
      status: PoStatus.reconciled,
      createdAt: DateTime(2025, 10, 12),
      expectedAt: DateTime(2025, 10, 18),
      carrier: 'UPS Ground',
      dockBay: 'Dock 03',
      lines: const [
        PoLineItem(
          sku: 'CHEM-ADH-50',
          name: 'Industrial Adhesive Poly-50',
          qty: 300,
          unitPrice: 27.90,
        ),
      ],
      note: 'Stocked to Bay B-14 • Dock 03',
    ),
    PurchaseOrderModel(
      id: 'po4',
      code: 'PO-2025-0901',
      supplierId: 's3',
      supplierName: 'EcoPackaging Solutions',
      status: PoStatus.draft,
      createdAt: DateTime(2025, 10, 23),
      expectedAt: DateTime(2025, 11, 2),
      carrier: '—',
      dockBay: '—',
      lines: const [
        PoLineItem(
          sku: 'PACK-BX12-25',
          name: 'Corrugated Boxes 12x12',
          qty: 400,
          unitPrice: 32.00,
        ),
      ],
    ),
    PurchaseOrderModel(
      id: 'po5',
      code: 'PO-2025-0866',
      supplierId: 's5',
      supplierName: 'Global Fasteners Co.',
      status: PoStatus.received,
      createdAt: DateTime(2025, 10, 5),
      expectedAt: DateTime(2025, 10, 21),
      carrier: 'Maersk Sea',
      dockBay: 'Bay 07',
      lines: const [
        PoLineItem(
          sku: 'HDW-BOLT-M8',
          name: 'Hex Bolts M8 Galvanized',
          qty: 5000,
          unitPrice: 0.42,
        ),
      ],
    ),
  ];

  // ===== Filters =====
  static const filterLabels = [
    'All',
    'Drafts',
    'Awaiting Approval',
    'In-Transit',
    'Received',
  ];

  bool _testFilter(int index, PurchaseOrderModel po) {
    switch (index) {
      case 1:
        return po.status == PoStatus.draft;
      case 2:
        return po.status == PoStatus.awaitingApproval;
      case 3:
        return po.status == PoStatus.inTransit;
      case 4:
        return po.status == PoStatus.received ||
            po.status == PoStatus.reconciled;
      default:
        return true;
    }
  }

  // ===== Queries =====
  List<PurchaseOrderModel> get all => List.unmodifiable(_all);

  int countFor(int filterIndex) =>
      _all.where((po) => _testFilter(filterIndex, po)).length;

  PurchaseOrderModel? byId(String id) {
    try {
      return _all.firstWhere((po) => po.id == id);
    } catch (_) {
      return null;
    }
  }

  List<PurchaseOrderModel> bySupplier(String supplierId) =>
      _all.where((po) => po.supplierId == supplierId).toList();

  List<PurchaseOrderModel> query({
    String search = '',
    int filterIndex = 0,
  }) {
    return _all
        .where((po) => _testFilter(filterIndex, po))
        .where((po) => po.matches(search))
        .toList();
  }

  double get openCommitments => _all
      .where((po) =>
          po.status != PoStatus.reconciled &&
          po.status != PoStatus.received)
      .fold(0, (s, po) => s + po.total);

  int get inboundDue => _all
      .where((po) =>
          po.status == PoStatus.inTransit ||
          po.status == PoStatus.approved)
      .length;
}