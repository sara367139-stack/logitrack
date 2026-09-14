import 'package:flutter/material.dart';

import 'package:logitrack/core/models/movement_model.dart';
import 'package:logitrack/core/models/product_model.dart';
import 'package:logitrack/core/models/purchase_order_model.dart';
import 'package:logitrack/core/models/supplier_model.dart';
import 'package:logitrack/core/repositories/movement_repository.dart';
import 'package:logitrack/core/repositories/po_repository.dart';
import 'package:logitrack/core/repositories/product_repository.dart';
import 'package:logitrack/core/repositories/supplier_repository.dart';
import 'package:logitrack/core/routing/app_router.dart';
import 'package:logitrack/core/services/storage_service.dart';
import 'package:logitrack/core/theme/app_theme.dart';
import 'package:logitrack/features/operations/presentation/pages/movement_details_page.dart';
import 'package:logitrack/features/products/presentation/pages/product_details_page.dart';
import 'package:logitrack/features/suppliers/presentation/pages/supplier_details_page.dart';

class _Hit {
  const _Hit({
    required this.type,
    required this.typeColor,
    required this.code,
    required this.title,
    required this.sub,
    required this.icon,
    required this.status,
    required this.statusColor,
    required this.onTap,
  });

  final String type;
  final Color typeColor;
  final String code;
  final String title;
  final String sub;
  final IconData icon;
  final String status;
  final Color statusColor;
  final VoidCallback onTap;
}

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late TextEditingController _ctrl;
  String _query = '';
  int _scope = 0;

  static const _scopes = ['All', 'Products', 'Partners', 'Orders'];

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _ctrl = TextEditingController(text: _query);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _fmt(num v) => v.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );

  // ==================== Search Engine ====================

  List<_Hit> _buildHits() {
    if (_query.trim().isEmpty) return [];
    final hits = <_Hit>[];

    // ===== Products =====
    if (_scope == 0 || _scope == 1) {
      for (final p in ProductRepository.instance.all) {
        if (!p.matches(_query)) continue;
        hits.add(_Hit(
          type: 'PRODUCT',
          typeColor: AppColors.primary,
          code: p.sku,
          title: p.name,
          sub: '${p.location} • ${_fmt(p.currentQty)} units',
          icon: p.icon,
          status: p.status.label,
          statusColor: p.status.color,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProductDetailsPage(product: p),
            ),
          ),
        ));
      }
    }

    // ===== Partners =====
    if (_scope == 0 || _scope == 2) {
      for (final s in SupplierRepository.instance.all) {
        if (!s.matches(_query)) continue;
        hits.add(_Hit(
          type: s.type == PartnerType.supplier ? 'SUPPLIER' : 'CUSTOMER',
          typeColor: AppColors.green,
          code: s.code,
          title: s.name,
          sub: '${s.category} • ${s.ratingLabel} ★ • ${s.paymentTerms}',
          icon: s.icon,
          status: s.tier.label,
          statusColor: s.tier.color,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SupplierDetailsPage(supplier: s),
            ),
          ),
        ));
      }
    }

    // ===== Orders + Movements =====
    if (_scope == 0 || _scope == 3) {
      for (final po in PoRepository.instance.all) {
        if (!po.matches(_query)) continue;
        hits.add(_Hit(
          type: 'ORDER',
          typeColor: AppColors.text,
          code: po.code,
          title: '${po.supplierName} — ${po.amountLabel}',
          sub: po.itemsLabel,
          icon: Icons.receipt_long_outlined,
          status: po.status.label,
          statusColor: po.status.color,
          onTap: () =>
              Navigator.of(context).pushNamed(AppRouter.purchaseOrders),
        ));
      }

      for (final m in MovementRepository.instance.all) {
        if (!m.matches(_query)) continue;
        hits.add(_Hit(
          type: 'MOVEMENT',
          typeColor: AppColors.orange,
          code: m.code,
          title: '${m.origin} → ${m.destination}',
          sub: '${m.carrier} • ${_fmt(m.totalUnits)} units',
          icon: m.type.icon,
          status: m.status.label,
          statusColor: m.status.color,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MovementDetailsPage(movement: m),
            ),
          ),
        ));
      }
    }

    return hits;
  }

  void _submitSearch(String q) {
    StorageService.addRecentSearch(q);
    setState(() => _query = q);
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    final results = _buildHits();
    final recent = StorageService.recentSearches;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        titleSpacing: 0,
        leadingWidth: 44,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_rounded,
              size: 21, color: AppColors.text),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 14),
          child: SizedBox(
            height: 42,
            child: TextField(
              controller: _ctrl,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: (v) => setState(() => _query = v),
              onSubmitted: _submitSearch,
              decoration: InputDecoration(
                hintText: 'Search SKU, partner, PO, movement...',
                prefixIcon: const Icon(Icons.search_rounded, size: 19),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _ctrl.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close_rounded, size: 17),
                      ),
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: SizedBox(
              height: 30,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _scopes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final sel = i == _scope;
                  return GestureDetector(
                    onTap: () => setState(() => _scope = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(
                        _scopes[i],
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          color:
                              sel ? Colors.white : AppColors.secondaryText,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      body: _query.isEmpty
          ? _recentView(recent)
          : results.isEmpty
              ? _emptyView()
              : ListView(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                  children: [
                    Text(
                      '${results.length} result${results.length == 1 ? '' : 's'} for "$_query"',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...results.map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(bottom: 11),
                        child: _ResultCard(r: r),
                      ),
                    ),
                  ],
                ),
    );
  }

  // ==================== Recent ====================

  Widget _recentView(List<String> recent) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
      children: [
        if (recent.isNotEmpty) ...[
          Row(
            children: [
              Text(
                'RECENT SEARCHES',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                  color: AppColors.secondaryText,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  await StorageService.clearRecentSearches();
                  if (mounted) setState(() {});
                },
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recent.map(
            (q) => InkWell(
              onTap: () {
                _ctrl.text = q;
                setState(() => _query = q);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 11),
                child: Row(
                  children: [
                    Icon(Icons.history_rounded,
                        size: 17, color: AppColors.secondaryText),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        q,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    Icon(Icons.north_west_rounded,
                        size: 15, color: AppColors.secondaryText),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
        ],

        // ===== Suggestions =====
        Text(
          'SUGGESTED',
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            'Low Stock',
            'Bearings',
            'Apex',
            'In-Transit',
            'Zone A',
          ].map((s) {
            return GestureDetector(
              onTap: () {
                _ctrl.text = s;
                setState(() => _query = s);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_rounded,
                        size: 13, color: AppColors.secondaryText),
                    const SizedBox(width: 6),
                    Text(
                      s,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 22),

        // ===== Quick Action =====
        Text(
          'QUICK ACTIONS',
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => Navigator.of(context).pushNamed(AppRouter.audit),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.qr_code_scanner_rounded,
                      size: 22, color: Colors.white),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scan barcode instead',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Faster lookup with handheld imager',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: AppColors.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==================== Empty ====================

  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off_rounded,
                size: 44, color: AppColors.primary),
          ),
          const SizedBox(height: 18),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              'Nothing matched "$_query". Try a different SKU, partner name, or order number.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.6,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          if (_scope != 0) ...[
            const SizedBox(height: 18),
            SizedBox(
              height: 42,
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _scope = 0),
                icon: const Icon(Icons.tune_rounded,
                    size: 16, color: Colors.white),
                label: const Text(
                  'Search in All',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== Card ====================

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.r});

  final _Hit r;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: r.onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(r.icon, size: 21, color: AppColors.secondaryText),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: r.typeColor.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          r.type,
                          style: TextStyle(
                            fontSize: 7.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            color: r.typeColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          r.code,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          r.status,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            color: r.statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    r.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    r.sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 18, color: AppColors.secondaryText),
          ],
        ),
      ),
    );
  }
}