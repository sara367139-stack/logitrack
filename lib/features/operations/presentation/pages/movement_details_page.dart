import 'package:flutter/material.dart';

import 'package:logitrack/core/models/movement_model.dart';
import 'package:logitrack/core/repositories/movement_repository.dart';
import 'package:logitrack/core/theme/app_theme.dart';
import 'package:logitrack/core/widgets/app_snackbar.dart';

class MovementDetailsPage extends StatelessWidget {
  const MovementDetailsPage({super.key, this.movement});

  final MovementModel? movement;

  String _fmt(num v) => v.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );

  @override
  Widget build(BuildContext context) {
    final m = movement ?? MovementRepository.instance.all.first;
    final weight = (m.totalUnits * 0.68).round();
    final loadedLines = m.lines.where((l) => l.loaded).length;

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
          'Movement Details',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
        actions: [
          _Sq(
            Icons.print_outlined,
            () => AppSnackBar.info(context, 'Printing manifest...'),
          ),
          const SizedBox(width: 8),
          _Sq(
            Icons.ios_share_rounded,
            () => AppSnackBar.info(context, 'Share link copied'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
        children: [
          // ==================== Status Hero ====================
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.heroGradient),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.code,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${m.type.label} • ${m.timeLabel}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 6),
                      decoration: BoxDecoration(
                        color: m.status.color.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 6, color: m.status.color),
                          const SizedBox(width: 5),
                          Text(
                            m.status.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: m.status.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                    children: [
                      _HStat(
                        'PALLETS',
                        m.hasProgress
                            ? '${m.palletsLoaded} / ${m.palletsTotal}'
                            : '—',
                      ),
                      const _HDiv(),
                      _HStat('UNITS', _fmt(m.totalUnits)),
                      const _HDiv(),
                      _HStat('WEIGHT', '${_fmt(weight)} kg'),
                    ],
                  ),
                ),

                if (m.hasProgress) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: m.progress,
                      minHeight: 5,
                      backgroundColor: Colors.white.withOpacity(0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          m.status.color),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ==================== Timeline ====================
          _Sec(
            icon: Icons.timeline_rounded,
            title: 'Movement Timeline',
            children: _buildTimeline(m),
          ),

          const SizedBox(height: 12),

          // ==================== Route ====================
          _Sec(
            icon: Icons.route_rounded,
            title: 'Route Information',
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Icon(Icons.warehouse_rounded,
                              size: 15, color: Colors.white),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ORIGIN',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.6,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                m.origin,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 14),
                        Container(
                          width: 2,
                          height: 20,
                          color: AppColors.border,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Icon(Icons.place_rounded,
                              size: 15, color: Colors.white),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DESTINATION',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.6,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                m.destination,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _Info(
                      label: 'CARRIER',
                      value: m.carrier,
                      icon: Icons.local_shipping_outlined,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: _Info(
                      label: 'DOCK BAY',
                      value: m.dockBay,
                      icon: Icons.garage_outlined,
                    ),
                  ),
                ],
              ),

              if (m.etaLabel != null) ...[
                const SizedBox(height: 11),
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 15, color: AppColors.primary),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          m.etaLabel!,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 12),

          // ==================== Manifest ====================
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
                      child: Icon(Icons.inventory_2_outlined,
                          size: 16, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Cargo Manifest',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$loadedLines / ${m.lines.length} loaded',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: loadedLines == m.lines.length
                            ? AppColors.green
                            : AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...m.lines.map(
                  (l) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: _Line(
                      sku: l.sku,
                      name: l.name,
                      qty: '${_fmt(l.qty)} units',
                      done: l.loaded,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (m.inspector != null) ...[
            const SizedBox(height: 12),
            _Sec(
              icon: Icons.verified_user_outlined,
              title: 'Quality Inspection',
              children: [
                Row(
                  children: [
                    Container(
                      height: 38,
                      width: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(Icons.check_circle_rounded,
                          size: 19, color: AppColors.green),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verified by ${m.inspector}',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'All units passed QA inspection',
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
              ],
            ),
          ],

          if (m.note != null) ...[
            const SizedBox(height: 12),
            _Sec(
              icon: Icons.sticky_note_2_outlined,
              title: 'Operator Notes',
              children: [
                Text(
                  m.note!,
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.7,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ],
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
                        AppSnackBar.info(context, 'Live tracking...'),
                    icon: Icon(Icons.my_location_rounded,
                        size: 17, color: AppColors.text),
                    label: Text(
                      'Track Live',
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
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: m.status == MovementStatus.completed
                        ? null
                        : () => AppSnackBar.success(
                            context, 'Loading resumed'),
                    icon: Icon(
                      m.status == MovementStatus.completed
                          ? Icons.check_rounded
                          : Icons.qr_code_scanner_rounded,
                      size: 17,
                      color: Colors.white,
                    ),
                    label: Text(
                      m.status == MovementStatus.completed
                          ? 'Completed'
                          : 'Continue Load',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.green,
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

  // ==================== Timeline Builder ====================

  List<Widget> _buildTimeline(MovementModel m) {
    final step = switch (m.status) {
      MovementStatus.pending => 1,
      MovementStatus.inProgress => 2,
      MovementStatus.enRoute => 3,
      MovementStatus.completed => 4,
    };

    final isInbound = m.type == MovementType.inbound;

    return [
      _TL(
        time: m.timeLabel,
        title: 'Movement Created',
        sub: 'By Sarah Jenkins (TRM-NB-04)',
        done: step >= 0,
        first: true,
      ),
      _TL(
        time: step >= 1 ? '10:32 AM' : 'Pending',
        title: isInbound ? 'Unloading Started' : 'Picking Started',
        sub: '${m.origin} • 3 operators assigned',
        done: step >= 1,
      ),
      _TL(
        time: step >= 2 ? '11:04 AM' : 'Pending',
        title: isInbound ? 'QA Inspection' : 'Pallets Staged',
        sub: m.hasProgress
            ? '${m.palletsLoaded} of ${m.palletsTotal} pallets • ${m.dockBay}'
            : m.dockBay,
        done: step >= 2,
        current: step == 2,
      ),
      _TL(
        time: step >= 3 ? '11:30 AM' : 'Pending',
        title: isInbound ? 'Stocked to Bins' : 'Carrier Pickup',
        sub: '${m.carrier} • ${m.etaLabel ?? 'Scheduled'}',
        done: step >= 3,
        current: step == 3,
      ),
      _TL(
        time: step >= 4 ? 'Completed' : 'Pending',
        title: isInbound ? 'Inventory Updated' : 'Delivered',
        sub: m.destination,
        done: step >= 4,
        current: step == 4,
        last: true,
      ),
    ];
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

class _HStat extends StatelessWidget {
  const _HStat(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 7.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _HDiv extends StatelessWidget {
  const _HDiv();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 26,
      color: Colors.white.withOpacity(0.15),
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

class _TL extends StatelessWidget {
  const _TL({
    required this.time,
    required this.title,
    required this.sub,
    required this.done,
    this.current = false,
    this.first = false,
    this.last = false,
  });

  final String time;
  final String title;
  final String sub;
  final bool done;
  final bool current;
  final bool first;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: done ? AppColors.primary : AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: done ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                ),
                child: done
                    ? const Icon(Icons.check, size: 10, color: Colors.white)
                    : null,
              ),
              if (!last)
                Expanded(
                  child: Container(
                    width: 2,
                    color: done ? AppColors.primary : AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                            color: done
                                ? AppColors.text
                                : AppColors.secondaryText,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: current
                              ? AppColors.primary
                              : AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: AppColors.secondaryText),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.sku,
    required this.name,
    required this.qty,
    required this.done,
  });

  final String sku;
  final String name;
  final String qty;
  final bool done;

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
          Icon(
            done
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 18,
            color: done ? AppColors.green : AppColors.secondaryText,
          ),
          const SizedBox(width: 10),
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
                const SizedBox(height: 2),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          Text(
            qty,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}