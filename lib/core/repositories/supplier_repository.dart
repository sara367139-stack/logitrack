import 'package:flutter/material.dart';

import 'package:logitrack/core/models/supplier_model.dart';

class SupplierRepository {
  SupplierRepository._();
  static final instance = SupplierRepository._();

  final List<SupplierModel> _all = const [
    SupplierModel(
      id: 's1',
      code: 'SUP-019',
      name: 'Apex Precision Ltd.',
      category: 'Bearings & CNC Parts',
      type: PartnerType.supplier,
      tier: SupplierTier.tier1,
      rating: 4.9,
      onTimePercent: 99.2,
      activePos: 3,
      pipelineValue: 45200,
      contactName: 'Marcus Vance',
      contactRole: 'Procurement Dir.',
      contactEmail: 'm.vance@apexprecision.com',
      contactPhone: '+1 (555) 204-8891',
      paymentTerms: 'Net 30',
      leadTimeDays: 12,
      address: '4200 Industrial Pkwy, Detroit MI',
      icon: Icons.precision_manufacturing_rounded,
    ),
    SupplierModel(
      id: 's2',
      code: 'SUP-032',
      name: 'Global Semiconductor Alliance',
      category: 'Microcontrollers & ICs',
      type: PartnerType.supplier,
      tier: SupplierTier.strategic,
      rating: 4.7,
      onTimePercent: 96.5,
      activePos: 1,
      pipelineValue: 84000,
      contactName: 'Elena Rostova',
      contactRole: 'Key Account Rep',
      contactEmail: 'e.rostova@gsa-tech.com',
      contactPhone: '+1 (555) 771-3320',
      paymentTerms: 'Net 45',
      leadTimeDays: 21,
      address: '88 Silicon Ave, San Jose CA',
      icon: Icons.memory_rounded,
    ),
    SupplierModel(
      id: 's3',
      code: 'SUP-007',
      name: 'EcoPackaging Solutions',
      category: 'Corrugated Boxes & Pallets',
      type: PartnerType.supplier,
      tier: SupplierTier.preferred,
      rating: 5.0,
      onTimePercent: 100,
      activePos: 4,
      pipelineValue: 12400,
      contactName: 'David Kim',
      contactRole: 'Logistics Lead',
      contactEmail: 'd.kim@ecopack.co',
      contactPhone: '+1 (555) 902-1177',
      paymentTerms: 'Net 15',
      leadTimeDays: 7,
      address: '15 Greenway Blvd, Portland OR',
      icon: Icons.inventory_rounded,
    ),
    SupplierModel(
      id: 's4',
      code: 'SUP-044',
      name: 'Industrial Chemicals Direct',
      category: 'Adhesives & Sealants',
      type: PartnerType.supplier,
      tier: SupplierTier.standard,
      rating: 4.2,
      onTimePercent: 91.4,
      activePos: 2,
      pipelineValue: 8950,
      contactName: 'Omar Haddad',
      contactRole: 'Sales Manager',
      contactEmail: 'o.haddad@icdirect.com',
      contactPhone: '+1 (555) 330-7744',
      paymentTerms: 'Net 30',
      leadTimeDays: 10,
      address: '902 Chemical Row, Houston TX',
      icon: Icons.science_rounded,
    ),
    SupplierModel(
      id: 's5',
      code: 'SUP-051',
      name: 'Global Fasteners Co.',
      category: 'Hardware & Metals',
      type: PartnerType.supplier,
      tier: SupplierTier.preferred,
      rating: 4.6,
      onTimePercent: 97.8,
      activePos: 1,
      pipelineValue: 21300,
      contactName: 'Hana Suzuki',
      contactRole: 'Export Coordinator',
      contactEmail: 'h.suzuki@gfasteners.jp',
      contactPhone: '+81 3-5555-0120',
      paymentTerms: 'Net 30',
      leadTimeDays: 18,
      address: '3-1 Shibaura, Tokyo JP',
      icon: Icons.hardware_rounded,
    ),
    // ===== Customers =====
    SupplierModel(
      id: 'c1',
      code: 'CUS-201',
      name: 'Apex Assembly Plant',
      category: 'Automotive Assembly',
      type: PartnerType.customer,
      tier: SupplierTier.tier1,
      rating: 4.8,
      onTimePercent: 98.1,
      activePos: 5,
      pipelineValue: 96400,
      contactName: 'Laura Bennett',
      contactRole: 'Supply Chain Mgr',
      contactEmail: 'l.bennett@apexassembly.com',
      contactPhone: '+1 (555) 618-2200',
      paymentTerms: 'Net 30',
      leadTimeDays: 3,
      address: '77 Assembly Dr, Flint MI',
      icon: Icons.factory_rounded,
    ),
    SupplierModel(
      id: 'c2',
      code: 'CUS-218',
      name: 'Metro Distribution Center',
      category: 'Retail Distribution',
      type: PartnerType.customer,
      tier: SupplierTier.strategic,
      rating: 4.5,
      onTimePercent: 94.7,
      activePos: 2,
      pipelineValue: 33800,
      contactName: 'Karim Fouad',
      contactRole: 'Receiving Head',
      contactEmail: 'k.fouad@metrodc.com',
      contactPhone: '+1 (555) 447-9012',
      paymentTerms: 'Net 45',
      leadTimeDays: 2,
      address: '1200 Metro Loop, Chicago IL',
      icon: Icons.store_rounded,
    ),
  ];

  // ===== Queries =====
  List<SupplierModel> get all => List.unmodifiable(_all);

  List<SupplierModel> byType(PartnerType t) =>
      _all.where((s) => s.type == t).toList();

  int countSuppliers() => byType(PartnerType.supplier).length;
  int countCustomers() => byType(PartnerType.customer).length;

  SupplierModel? byId(String id) {
    try {
      return _all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  SupplierModel? byCode(String code) {
    try {
      return _all.firstWhere(
          (s) => s.code.toLowerCase() == code.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  /// الفلاتر حسب النوع
  List<String> categoriesFor(PartnerType t) {
    final set = <String>{};
    for (final s in byType(t)) {
      set.add(s.category.split(' & ').first);
    }
    return ['All', ...set];
  }

  List<SupplierModel> query({
    required PartnerType type,
    String search = '',
    String category = 'All',
  }) {
    return byType(type).where((s) {
      final catOk =
          category == 'All' || s.category.startsWith(category);
      return catOk && s.matches(search);
    }).toList();
  }

  int countCategory(PartnerType t, String cat) {
    if (cat == 'All') return byType(t).length;
    return byType(t).where((s) => s.category.startsWith(cat)).length;
  }
}