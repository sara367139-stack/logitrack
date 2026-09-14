import 'package:flutter/material.dart';

import 'package:logitrack/core/localization/app_localizations.dart';
import 'package:logitrack/core/theme/app_theme.dart';

enum NotifType { critical, warning, info, success }

class NotifItem {
  const NotifItem({
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.tag,
    required this.icon,
    this.unread = false,
    this.action,
  });

  final NotifType type;
  final String title;
  final String body;
  final String time;
  final String tag;
  final IconData icon;
  final bool unread;
  final String? action;
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _filter = 0;

  static const _filterKeys = ['all', 'critical', 'inventory', 'orders'];

  static const _today = <NotifItem>[
    NotifItem(
      type: NotifType.critical,
      title: 'Stock Depleted: CHEM-SIL-300',
      body:
          'High-Temp Silicone Sealant reached 0 units in Zone C. Immediate reorder required.',
      time: '12m ago',
      tag: 'CRITICAL',
      icon: Icons.error_outline_rounded,
      unread: true,
      action: 'Create PO',
    ),
    NotifItem(
      type: NotifType.warning,
      title: 'Reorder Threshold Reached',
      body:
          'ELEC-STM32-DEV dropped to 14 units (min 100). Supplier lead time: 12 days.',
      time: '48m ago',
      tag: 'LOW STOCK',
      icon: Icons.warning_amber_rounded,
      unread: true,
      action: 'Review',
    ),
    NotifItem(
      type: NotifType.info,
      title: 'Inbound Dock Arrival',
      body:
          'PO-2025-0892 from Apex Precision arriving tomorrow 2:00 PM at Dock Bay 04.',
      time: '2h ago',
      tag: 'INBOUND',
      icon: Icons.local_shipping_outlined,
      unread: true,
      action: 'Prepare Dock',
    ),
  ];

  static const _earlier = <NotifItem>[
    NotifItem(
      type: NotifType.success,
      title: 'Audit Session Completed',
      body:
          'Aisle 4 North Sweep finished — 24/24 bins verified. Variance: -4 units.',
      time: 'Yesterday',
      tag: 'AUDIT',
      icon: Icons.check_circle_outline_rounded,
    ),
    NotifItem(
      type: NotifType.info,
      title: 'Transfer En-Route',
      body:
          'TRF-1102: 120 Units Hydraulic Seals moving WH-North → WH-East. ETA 15m.',
      time: 'Yesterday',
      tag: 'TRANSFER',
      icon: Icons.swap_horiz_rounded,
    ),
    NotifItem(
      type: NotifType.warning,
      title: 'FIFO Expiry Alert',
      body: '14 batches of Industrial Adhesive Poly-50 expire within 7 days.',
      time: '2 days ago',
      tag: 'EXPIRY',
      icon: Icons.event_busy_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 46,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(9),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(Icons.arrow_back_rounded,
                  size: 16, color: AppColors.text),
            ),
          ),
        ),
        title: Text(
          context.tr('notifications'),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              context.tr('markAllRead'),
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          // ===== Summary =====
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: _SumBox(
                    count: '3',
                    label: context.tr('critical'),
                    color: AppColors.red,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SumBox(
                    count: '8',
                    label: context.tr('warnings'),
                    color: AppColors.orange,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SumBox(
                    count: '14',
                    label: context.tr('updates'),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // ===== Filters =====
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              height: 30,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: _filterKeys.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final sel = i == _filter;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(
                        context.tr(_filterKeys[i]),
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          color: sel ? Colors.white : AppColors.secondaryText,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ===== List =====
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
              children: [
                _SectionLabel(context.tr('today').toUpperCase()),
                const SizedBox(height: 10),
                ..._today.map((n) => Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: _NotifCard(item: n),
                    )),
                const SizedBox(height: 8),
                _SectionLabel(context.tr('earlier')),
                const SizedBox(height: 10),
                ..._earlier.map((n) => Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: _NotifCard(item: n),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SumBox extends StatelessWidget {
  const _SumBox({
    required this.count,
    required this.label,
    required this.color,
  });

  final String count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 19,
              height: 1,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 9.5,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
        color: AppColors.secondaryText,
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({required this.item});

  final NotifItem item;

  Color get _color {
    switch (item.type) {
      case NotifType.critical:
        return AppColors.red;
      case NotifType.warning:
        return AppColors.orange;
      case NotifType.success:
        return AppColors.green;
      case NotifType.info:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.unread ? _color.withOpacity(0.3) : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: item.unread ? _color : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13),
                bottomLeft: Radius.circular(13),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: _color.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(item.icon, size: 16, color: _color),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: _color.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          item.tag,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            color: _color,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        item.time,
                        style: TextStyle(
                          fontSize: 9.5,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      if (item.unread) ...[
                        const SizedBox(width: 7),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: _color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 11),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.body,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.5,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  if (item.action != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            child: Text(
                              item.action!,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 9),
                        SizedBox(
                          height: 36,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.background,
                              side: BorderSide(color: AppColors.border),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            child: Text(
                              context.tr('dismiss'),
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w900,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
