import 'package:flutter/material.dart';

import 'package:logitrack/core/localization/app_localizations.dart';
import 'package:logitrack/core/models/movement_model.dart';
import 'package:logitrack/core/models/notification_model.dart';
import 'package:logitrack/core/repositories/movement_repository.dart';
import 'package:logitrack/core/repositories/notification_repository.dart';
import 'package:logitrack/core/repositories/po_repository.dart';
import 'package:logitrack/core/repositories/product_repository.dart';
import 'package:logitrack/core/routing/app_router.dart';
import 'package:logitrack/core/services/storage_service.dart';
import 'package:logitrack/core/theme/app_theme.dart';
import 'package:logitrack/core/widgets/charts.dart';
import 'package:logitrack/core/widgets/wms_header.dart';

class WarehouseDashboardPage extends StatelessWidget {
  const WarehouseDashboardPage({super.key, this.onOpenProducts});

  final VoidCallback? onOpenProducts;

  String _greeting(BuildContext context) {
    final h = DateTime.now().hour;
    if (h < 12) return context.tr('goodMorning');
    if (h < 17) return context.tr('goodAfternoon');
    return context.tr('goodEvening');
  }

  String _fmt(num v) => v.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );

  String _money(double v) {
    if (v >= 1000000) return '\$${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '\$${(v / 1000).toStringAsFixed(1)}K';
    return '\$${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final products = ProductRepository.instance;
    final pos = PoRepository.instance;
    final movements = MovementRepository.instance;
    final notifs = NotificationRepository.instance;

    final totalUnits = products.all.fold<int>(0, (s, p) => s + p.currentQty);
    final inboundUnits = movements
        .byType(MovementType.inbound)
        .fold<int>(0, (s, m) => s + m.totalUnits);
    final outboundUnits = movements
        .byType(MovementType.outbound)
        .fold<int>(0, (s, m) => s + m.totalUnits);

    final alerts = notifs.all
        .where(
            (n) => n.kind == NotifKind.critical || n.kind == NotifKind.warning)
        .take(2)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WmsHeader(sectionKey: 'dashboard'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          // ==================== Greeting ====================
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_greeting(context)}, ${StorageService.userName.split(' ').first} ☀️',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.badge_outlined,
                            size: 12, color: AppColors.secondaryText),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Shift A • ${StorageService.userBadge}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.5,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.timer_outlined,
                            size: 12, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          '${context.tr('activeShift')} 3h 42m',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up_rounded,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 5),
                    Text(
                      '98.4%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ==================== KPI cards ====================
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.inventory_2_outlined,
                  iconColor: AppColors.primary,
                  badge: '+3.8%',
                  badgeColor: AppColors.green,
                  label: context.tr('totalStock'),
                  value: _fmt(totalUnits),
                  sub:
                      '${_money(products.totalValuation)} ${context.tr('valued')}',
                  onTap: onOpenProducts,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _StatCard(
                  icon: Icons.warning_amber_rounded,
                  iconColor: AppColors.orange,
                  badge: context.tr('reorder'),
                  badgeColor: AppColors.secondaryText,
                  label: context.tr('lowStockAlert'),
                  value: '${products.lowStockCount} Items',
                  sub: context.tr('needsRestock'),
                  onTap: onOpenProducts,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.event_busy_outlined,
                  iconColor: AppColors.red,
                  badge: '<15 Days',
                  badgeColor: AppColors.red,
                  label: context.tr('expiringSoon'),
                  value: '${notifs.warningCount} ${context.tr('batches')}',
                  sub: context.tr('criticalFifo'),
                  subColor: AppColors.red,
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRouter.floorFeed),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _StatCard(
                  icon: Icons.receipt_long_outlined,
                  iconColor: AppColors.text,
                  badge: context.tr('queue'),
                  badgeColor: AppColors.secondaryText,
                  label: context.tr('pendingOrders'),
                  value: '${pos.all.length} POs',
                  sub:
                      '${pos.inboundDue} In • ${movements.byType(MovementType.outbound).length} Out',
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRouter.purchaseOrders),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ==================== Quick actions ====================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('quickTouchActions'),
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondaryText,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                context.tr('gloveModeActive'),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  icon: Icons.qr_code_scanner_rounded,
                  title: context.tr('barcodeScan'),
                  subtitle: context.tr('rapidAudit'),
                  filled: true,
                  onTap: () => Navigator.of(context).pushNamed(AppRouter.audit),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _ActionTile(
                  icon: Icons.fact_check_outlined,
                  title: context.tr('stockAudit'),
                  subtitle: context.tr('zoneChecks'),
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRouter.locations),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  icon: Icons.download_rounded,
                  title: context.tr('inboundDock'),
                  subtitle: context.tr('receivePallets'),
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRouter.operations),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _ActionTile(
                  icon: Icons.upload_rounded,
                  title: context.tr('outboundDock'),
                  subtitle: context.tr('dispatchBay'),
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRouter.newMovement),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ==================== Weekly throughput ====================
          Container(
            padding: const EdgeInsets.all(15),
            decoration: _card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('weeklyThroughput'),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            context.tr('inboundOutboundVolume'),
                            style: TextStyle(
                              fontSize: 10.5,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _Legend(
                            color: AppColors.primary,
                            label: context.tr('inLabel')),
                        const SizedBox(width: 10),
                        _Legend(
                          color: AppColors.primary.withOpacity(0.28),
                          label: context.tr('outLabel'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _MiniStat(
                          label: 'TOTAL INBOUND',
                          value: '${_fmt(inboundUnits)} units',
                        ),
                      ),
                      Container(width: 1, height: 30, color: AppColors.border),
                      Expanded(
                        child: _MiniStat(
                          label: 'TOTAL OUTBOUND',
                          value: '${_fmt(outboundUnits)} units',
                          alignEnd: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // 📊 fl_chart
                const ThroughputBarChart(
                  height: 150,
                  inbound: [520, 720, 440, 840, 580, 360, 960],
                  outbound: [340, 460, 600, 380, 700, 280, 540],
                  labels: ['M', 'T', 'W', 'T', 'F', 'S', 'Today'],
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ==================== Urgent ====================
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.red),
              const SizedBox(width: 7),
              Text(
                '${context.tr('urgentAttention')} (${alerts.length})',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                  letterSpacing: 0.6,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRouter.floorFeed),
                child: Text(
                  context.tr('viewAllAlerts'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),

          ...alerts.map(
            (n) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: _AlertCard(notif: n),
            ),
          ),

          const SizedBox(height: 10),

          // ==================== More Modules ====================
          Text(
            context.tr('moreModules'),
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 11),

          _NavTile(
            icon: Icons.factory_outlined,
            title: context.tr('suppliersCustomers'),
            sub: context.tr('partnersContactsCatalogs'),
            route: AppRouter.suppliers,
          ),
          const SizedBox(height: 9),
          _NavTile(
            icon: Icons.receipt_long_outlined,
            title: 'Purchase Orders',
            sub:
                '${pos.all.length} active • ${_money(pos.openCommitments)} committed',
            route: AppRouter.purchaseOrders,
          ),
          const SizedBox(height: 9),
          _NavTile(
            icon: Icons.grid_view_rounded,
            title: context.tr('warehouseLocations'),
            sub: context.tr('rackMatrixBins'),
            route: AppRouter.locations,
          ),
          const SizedBox(height: 9),
          _NavTile(
            icon: Icons.qr_code_2_rounded,
            title: context.tr('barcodeGenerator'),
            sub: context.tr('printThermalLabels'),
            route: AppRouter.barcodeGen,
          ),
          const SizedBox(height: 9),
          _NavTile(
            icon: Icons.account_balance_outlined,
            title: context.tr('assetValuation'),
            sub:
                '${_money(products.totalValuation)} ${context.tr('totalPortfolio')}',
            route: AppRouter.valuation,
          ),
          const SizedBox(height: 9),
          _NavTile(
            icon: Icons.person_outline_rounded,
            title: 'Profile & Settings',
            sub: context.tr('accountLanguageHardware'),
            route: AppRouter.terminalProfile,
          ),
        ],
      ),
    );
  }
}

BoxDecoration get _card => BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    );

// ==================== Widgets ====================

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.badge,
    required this.badgeColor,
    required this.label,
    required this.value,
    required this.sub,
    this.subColor,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String badge;
  final Color badgeColor;
  final String label;
  final String value;
  final String sub;
  final Color? subColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: _card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 14, color: iconColor),
                ),
                const Spacer(),
                Text(
                  badge,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: badgeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: AppColors.secondaryText,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
                fontSize: 10,
                color: subColor ?? AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: filled ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: filled
                    ? Colors.white.withOpacity(0.18)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  size: 18, color: filled ? Colors.white : AppColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.15,
                      fontWeight: FontWeight.w900,
                      color: filled ? Colors.white : AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: filled ? Colors.white70 : AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: AppColors.secondaryText,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.notif});

  final NotificationModel notif;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(AppRouter.floorFeed),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: _card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    notif.tag,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.place_outlined,
                    size: 12, color: AppColors.secondaryText),
                const SizedBox(width: 3),
                Text(
                  notif.locationTag,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            Text(
              notif.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              notif.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                height: 1.5,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRouter.floorFeed),
                style: ElevatedButton.styleFrom(
                  backgroundColor: notif.color,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: Text(
                  notif.actionLabel,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.title,
    required this.sub,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String sub;
  final String route;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(route),
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: _card,
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
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
            ),
            Icon(Icons.chevron_right_rounded,
                size: 19, color: AppColors.secondaryText),
          ],
        ),
      ),
    );
  }
}
