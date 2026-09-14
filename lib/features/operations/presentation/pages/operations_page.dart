import 'package:flutter/material.dart';

import 'package:logitrack/core/models/movement_model.dart';
import 'package:logitrack/core/repositories/movement_repository.dart';
import 'package:logitrack/core/routing/app_router.dart';
import 'package:logitrack/core/theme/app_theme.dart';
import 'package:logitrack/core/widgets/empty_state.dart';
import 'package:logitrack/core/widgets/wms_header.dart';
import 'package:logitrack/features/operations/presentation/pages/movement_details_page.dart';

class OperationsPage extends StatefulWidget {
  const OperationsPage({super.key});

  @override
  State<OperationsPage> createState() => _OperationsPageState();
}

class _OperationsPageState extends State<OperationsPage> {
  final _repo = MovementRepository.instance;

  MovementType _type = MovementType.outbound;
  int _statusFilter = 0;

  String _fmt(num v) => v.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );

  String get _velocityLabel {
    final units =
        _repo.byType(_type).fold<int>(0, (s, m) => s + m.totalUnits);
    return _fmt(units);
  }

  @override
  Widget build(BuildContext context) {
    final list = _repo.query(type: _type, statusFilter: _statusFilter);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WmsHeader(section: 'OPERATIONS'),
      body: Column(
        children: [
          // ==================== Tabs ====================
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Row(
              children: MovementType.values.map((t) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: t == MovementType.transfer ? 0 : 8,
                    ),
                    child: _Tab(
                      icon: t.icon,
                      label:
                          t == MovementType.outbound ? 'Outbound' : t.label,
                      active: t == _type,
                      onTap: () => setState(() {
                        _type = t;
                        _statusFilter = 0;
                      }),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
              children: [
                // ==================== Velocity Card ====================
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.heroGradient,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child:
                            Icon(_type.icon, size: 21, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "TODAY'S ${_type.label.toUpperCase()} VELOCITY",
                              style: const TextStyle(
                                fontSize: 8.5,
                                letterSpacing: 0.9,
                                fontWeight: FontWeight.w900,
                                color: Colors.white60,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _velocityLabel,
                                  style: const TextStyle(
                                    fontSize: 23,
                                    height: 1,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    'units processed',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Across ${_repo.byType(_type).length} active runs',
                              style: const TextStyle(
                                fontSize: 9.5,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ==================== Filters ====================
                Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      count: _repo.countStatus(_type, 0),
                      active: _statusFilter == 0,
                      onTap: () => setState(() => _statusFilter = 0),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Completed',
                      count: _repo.countStatus(_type, 1),
                      dot: AppColors.green,
                      active: _statusFilter == 1,
                      onTap: () => setState(() => _statusFilter = 1),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'In Progress',
                      count: _repo.countStatus(_type, 2),
                      dot: AppColors.orange,
                      active: _statusFilter == 2,
                      onTap: () => setState(() => _statusFilter = 2),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ==================== List ====================
                if (list.isEmpty)
                  SizedBox(
                    height: 280,
                    child: EmptyState(
                      icon: _type.icon,
                      title: 'No ${_type.label.toLowerCase()} movements',
                      message:
                          'Nothing here right now. Create a new movement to get started.',
                      actionLabel: 'New Movement',
                      onAction: () => Navigator.of(context)
                          .pushNamed(AppRouter.newMovement),
                    ),
                  )
                else
                  ...list.map(
                    (m) => Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: _MovementCard(m: m),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: FloatingActionButton.extended(
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRouter.newMovement),
          backgroundColor: AppColors.primary,
          elevation: 4,
          icon: const Icon(Icons.add_rounded, color: Colors.white, size: 19),
          label: const Text(
            'NEW MOVEMENT',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== Widgets ====================

class _Tab extends StatelessWidget {
  const _Tab({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 14,
                color: active ? Colors.white : AppColors.secondaryText),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  color: active ? Colors.white : AppColors.secondaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
    this.count,
    this.dot,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final int? count;
  final Color? dot;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dot != null) ...[
              Icon(Icons.circle,
                  size: 6, color: active ? Colors.white : dot),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                color: active ? Colors.white : AppColors.secondaryText,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 5),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: active
                      ? Colors.white.withOpacity(0.22)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: active ? Colors.white : AppColors.text,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MovementCard extends StatelessWidget {
  const _MovementCard({required this.m});

  final MovementModel m;

  String _fmt(num v) => v.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (x) => '${x[1]},',
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MovementDetailsPage(movement: m),
        ),
      ),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Header =====
            Row(
              children: [
                Text(
                  m.code,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(width: 7),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: m.type.color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    m.type.label,
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w900,
                      color: m.type.color,
                    ),
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: m.status.color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 6, color: m.status.color),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            m.status.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: m.status.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              m.timeLabel,
              style: TextStyle(
                fontSize: 9.5,
                color: AppColors.secondaryText,
              ),
            ),

            const SizedBox(height: 11),

            // ===== Transfer route =====
            if (m.type == MovementType.transfer) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        m.origin,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_rounded,
                        size: 15, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        m.destination,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ] else ...[
              _InfoRow(
                icon: m.type == MovementType.inbound
                    ? Icons.store_outlined
                    : Icons.place_outlined,
                label: m.type == MovementType.inbound
                    ? 'Origin Vendor'
                    : 'Destination',
                value: m.type == MovementType.inbound
                    ? m.origin
                    : m.destination,
              ),
              _InfoRow(
                icon: Icons.local_shipping_outlined,
                label: 'Carrier',
                value: m.carrier,
              ),
            ],

            _InfoRow(
              icon: Icons.inventory_2_outlined,
              label: 'Cargo',
              value: '${m.lines.length} SKU • ${_fmt(m.totalUnits)} units',
            ),

            // ===== Progress =====
            if (m.hasProgress) ...[
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'PALLET STAGING',
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          m.progressLabel,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: m.progress,
                        minHeight: 5,
                        backgroundColor: AppColors.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 9),

            // ===== Footer =====
            Row(
              children: [
                Icon(m.footerIcon, size: 13, color: AppColors.secondaryText),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    m.footerText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
                Text(
                  m.actionLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 3),
                Icon(
                  m.actionIcon ?? Icons.chevron_right_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 13, color: AppColors.secondaryText),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.secondaryText,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}