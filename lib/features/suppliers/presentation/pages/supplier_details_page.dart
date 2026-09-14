import 'package:flutter/material.dart';
import 'package:logitrack/core/models/purchase_order_model.dart';

import 'package:logitrack/core/models/supplier_model.dart';
import 'package:logitrack/core/repositories/po_repository.dart';
import 'package:logitrack/core/repositories/product_repository.dart';
import 'package:logitrack/core/repositories/supplier_repository.dart';
import 'package:logitrack/core/routing/app_router.dart';
import 'package:logitrack/core/theme/app_theme.dart';
import 'package:logitrack/core/widgets/app_snackbar.dart';

class SupplierDetailsPage extends StatelessWidget {
  const SupplierDetailsPage({super.key, this.supplier});

  final SupplierModel? supplier;

  String _money(double v) {
    final s = v.toStringAsFixed(0);
    return s.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  String _date(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final s = supplier ?? SupplierRepository.instance.all.first;
    final orders = PoRepository.instance.bySupplier(s.id);
    final catalog = ProductRepository.instance.all.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leadingWidth: 46,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: _Sq(
            Icons.arrow_back_rounded,
            () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          s.type == PartnerType.supplier
              ? 'Supplier Profile'
              : 'Customer Profile',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
        actions: [
          _Sq(
            Icons.star_border_rounded,
            () => AppSnackBar.success(context, 'Added to favorites'),
          ),
          const SizedBox(width: 8),
          _Sq(Icons.more_horiz_rounded, () {}),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
        children: [
          // ==================== Header ====================
          Container(
            padding: const EdgeInsets.all(15),
            decoration: _dec,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 58,
                      width: 58,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Icon(s.icon,
                          size: 28, color: AppColors.secondaryText),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                s.code,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: s.tier.color.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  '${s.tier.label} Partner',
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w900,
                                    color: s.tier.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            s.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            s.category,
                            style: TextStyle(
                              fontSize: 10.5,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: _Act(
                        Icons.phone_outlined,
                        'Call',
                        () => AppSnackBar.info(context, s.contactPhone),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _Act(
                        Icons.mail_outline_rounded,
                        'Email',
                        () => AppSnackBar.info(context, s.contactEmail),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _Act(
                        Icons.language_rounded,
                        'Website',
                        () => AppSnackBar.info(context, 'Opening website...'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ==================== KPIs ====================
          Row(
            children: [
              Expanded(
                child: _Kpi(
                  icon: Icons.star_rounded,
                  color: AppColors.orange,
                  label: 'RATING',
                  value: s.ratingLabel,
                  sub: 'out of 5.0',
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _Kpi(
                  icon: Icons.local_shipping_outlined,
                  color: AppColors.green,
                  label: 'ON-TIME',
                  value: '${s.onTimePercent.toStringAsFixed(1)}%',
                  sub: 'last 12 months',
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: _Kpi(
                  icon: Icons.receipt_long_outlined,
                  color: AppColors.primary,
                  label: 'ACTIVE POs',
                  value: '${s.activePos}',
                  sub: '\$${_money(s.pipelineValue)} pending',
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _Kpi(
                  icon: Icons.history_rounded,
                  color: AppColors.text,
                  label: 'LEAD TIME',
                  value: '${s.leadTimeDays}d',
                  sub: 'average',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ==================== Contact ====================
          _Sec(
            icon: Icons.contacts_outlined,
            title: 'Primary Contact',
            children: [
              Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Text(
                      s.initials,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.contactName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s.contactRole,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _InfoRow(Icons.mail_outline_rounded, s.contactEmail),
              const SizedBox(height: 10),
              _InfoRow(Icons.phone_outlined, s.contactPhone),
              const SizedBox(height: 10),
              _InfoRow(Icons.place_outlined, s.address),
              const SizedBox(height: 10),
              _InfoRow(
                Icons.credit_card_outlined,
                'Payment Terms: ${s.paymentTerms}',
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ==================== Catalog ====================
          Container(
            padding: const EdgeInsets.all(14),
            decoration: _dec,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(Icons.menu_book_outlined,
                          size: 16, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Product Catalog',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${ProductRepository.instance.totalCount} SKUs',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...catalog.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: _CatalogRow(
                      sku: p.sku,
                      name: p.name,
                      price: p.priceLabel,
                      moq: 'MOQ ${p.minQty}',
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRouter.products),
                    child: Text(
                      'View all products',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ==================== PO History ====================
          _Sec(
            icon: Icons.history_rounded,
            title: 'Recent Orders',
            children: orders.isEmpty
                ? [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(Icons.receipt_long_outlined,
                              size: 30, color: AppColors.secondaryText),
                          const SizedBox(height: 9),
                          Text(
                            'No orders yet',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                : orders
                    .map(
                      (po) => Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: _PoRow(
                          code: po.code,
                          date: _date(po.createdAt),
                          amount: po.amountLabel,
                          status: po.status.label,
                          color: po.status.color,
                          onTap: () => Navigator.of(context)
                              .pushNamed(AppRouter.movementDetails),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),

      // ==================== Bottom ====================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        AppSnackBar.info(context, 'Contract PDF coming soon'),
                    icon: Icon(Icons.description_outlined,
                        size: 17, color: AppColors.text),
                    label: Text(
                      'Contract',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.background,
                      side: BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRouter.createPo),
                    icon: const Icon(Icons.add_shopping_cart_rounded,
                        size: 17, color: Colors.white),
                    label: const Text(
                      'Create Purchase Order',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== Shared ====================

BoxDecoration get _dec => BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    );

class _Sq extends StatelessWidget {
  const _Sq(this.icon, this.onTap);

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 16, color: AppColors.text),
      ),
    );
  }
}

class _Act extends StatelessWidget {
  const _Act(this.icon, this.label, this.onTap);

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.sub,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _dec,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 26,
            width: 26,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(height: 11),
          Text(
            label,
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.6,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9.5,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _Sec extends StatelessWidget {
  const _Sec({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _dec,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.secondaryText),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
        ),
      ],
    );
  }
}

class _CatalogRow extends StatelessWidget {
  const _CatalogRow({
    required this.sku,
    required this.name,
    required this.price,
    required this.moq,
  });

  final String sku;
  final String name;
  final String price;
  final String moq;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sku,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                moq,
                style: TextStyle(
                  fontSize: 8.5,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PoRow extends StatelessWidget {
  const _PoRow({
    required this.code,
    required this.date,
    required this.amount,
    required this.status,
    required this.color,
    this.onTap,
  });

  final String code;
  final String date;
  final String amount;
  final String status;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    code,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}