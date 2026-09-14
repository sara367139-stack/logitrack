import 'package:flutter/material.dart';

import 'package:logitrack/core/localization/app_localizations.dart';
import 'package:logitrack/core/models/notification_model.dart';
import 'package:logitrack/core/repositories/notification_repository.dart';
import 'package:logitrack/core/routing/app_router.dart';
import 'package:logitrack/core/theme/app_theme.dart';
import 'package:logitrack/core/widgets/empty_state.dart';
import 'package:logitrack/core/widgets/wms_header.dart';

class FloorFeedPage extends StatefulWidget {
  const FloorFeedPage({super.key});

  @override
  State<FloorFeedPage> createState() => _FloorFeedPageState();
}

class _FloorFeedPageState extends State<FloorFeedPage> {
  final _repo = NotificationRepository.instance;
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final today = _repo.byGroup(NotifGroup.today, filterIndex: _filter);
    final yesterday = _repo.byGroup(NotifGroup.yesterday, filterIndex: _filter);
    final earlier = _repo.byGroup(NotifGroup.earlier, filterIndex: _filter);
    final total = today.length + yesterday.length + earlier.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WmsHeader(sectionKey: 'floorFeed'),
      body: Column(
        children: [
          // ===== Header =====
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
            child: Row(
              children: [
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.bolt_rounded,
                      size: 16, color: Colors.white),
                ),
                const SizedBox(width: 9),
                Text(
                  context.tr('floorFeed'),
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(width: 8),
                if (_repo.unreadCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '${_repo.unreadCount} ${context.tr('unread')}',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.tr('markAllRead')),
                        backgroundColor: AppColors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.done_all_rounded,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 5),
                      Text(
                        context.tr('markAllRead'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
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
                itemCount: NotificationRepository.filterLabels.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final sel = i == _filter;
                  final count = _repo.countFor(i);

                  return GestureDetector(
                    onTap: () => setState(() => _filter = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (i == 1)
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(Icons.circle,
                                  size: 6,
                                  color: sel ? Colors.white : AppColors.red),
                            ),
                          Text(
                            NotificationRepository.filterLabels[i],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color:
                                  sel ? Colors.white : AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: sel
                                  // ignore: deprecated_member_use
                                  ? Colors.white.withOpacity(0.25)
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$count',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: sel ? Colors.white : AppColors.text,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Expanded(
            child: total == 0
                ? EmptyState(
                    icon: Icons.notifications_off_outlined,
                    title: context.tr('noNotifications'),
                    message: context.tr('caughtUpCategory'),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                    children: [
                      // ===== Accuracy Card =====
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.insights_rounded,
                                    size: 15, color: AppColors.primary),
                                const SizedBox(width: 7),
                                Text(
                                  context.tr('floorAccuracyRate'),
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.text,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${context.tr('shiftTarget')}: 99.0%',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '98.4',
                                  style: TextStyle(
                                    fontSize: 32,
                                    height: 1,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.text,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 4, left: 2),
                                  child: Text(
                                    '%',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 110,
                                  height: 40,
                                  child: CustomPaint(
                                    painter: _SparkPainter(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_repo.criticalCount} ${context.tr('critical')} • ${_repo.warningCount} ${context.tr('warningsPending')}',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (today.isNotEmpty) ...[
                        _GroupHeader(
                          label: context.tr('today').toUpperCase(),
                          count: today.length,
                          highlight: true,
                        ),
                        const SizedBox(height: 10),
                        ...today.map((n) => Padding(
                              padding: const EdgeInsets.only(bottom: 11),
                              child: _FeedCard(item: n),
                            )),
                        const SizedBox(height: 8),
                      ],

                      if (yesterday.isNotEmpty) ...[
                        _GroupHeader(
                          label: context.tr('yesterday'),
                          count: yesterday.length,
                        ),
                        const SizedBox(height: 10),
                        ...yesterday.map((n) => Padding(
                              padding: const EdgeInsets.only(bottom: 11),
                              child: _FeedCard(item: n),
                            )),
                        const SizedBox(height: 8),
                      ],

                      if (earlier.isNotEmpty) ...[
                        _GroupHeader(
                          label: context.tr('earlier'),
                          count: earlier.length,
                        ),
                        const SizedBox(height: 10),
                        ...earlier.map((n) => Padding(
                              padding: const EdgeInsets.only(bottom: 11),
                              child: _FeedCard(item: n),
                            )),
                      ],

                      const SizedBox(height: 12),

                      Column(
                        children: [
                          Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(Icons.check_rounded,
                                size: 17, color: AppColors.green),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            context.tr('allOperationalFeedsUpToDate'),
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.7,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pull down anytime to sync ERP bus',
                            style: TextStyle(
                              fontSize: 9.5,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// ================= Widgets =================

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({
    required this.label,
    required this.count,
    this.highlight = false,
  });

  final String label;
  final int count;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
            color: highlight ? AppColors.text : AppColors.secondaryText,
          ),
        ),
        if (highlight) ...[
          const SizedBox(width: 6),
          Icon(Icons.circle, size: 6, color: AppColors.primary),
        ],
        const Spacer(),
        Text(
          '$count event${count == 1 ? '' : 's'}',
          style: TextStyle(
            fontSize: 9.5,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

class _FeedCard extends StatelessWidget {
  const _FeedCard({required this.item});

  final NotificationModel item;

  void _handleAction(BuildContext context) {
    switch (item.category) {
      case 'orders':
        Navigator.of(context).pushNamed(AppRouter.purchaseOrders);
        break;
      case 'audit':
        Navigator.of(context).pushNamed(AppRouter.audit);
        break;
      default:
        Navigator.of(context).pushNamed(AppRouter.products);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.unread
              // ignore: deprecated_member_use
              ? item.color.withOpacity(0.3)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: item.color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(item.icon, size: 17, color: item.color),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        if (item.unread) ...[
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: item.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 7),
                        ],
                        Text(
                          item.timeLabel,
                          style: TextStyle(
                            fontSize: 9.5,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.body,
                      style: TextStyle(
                        fontSize: 10.5,
                        height: 1.5,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.place_outlined,
                        size: 10, color: AppColors.secondaryText),
                    const SizedBox(width: 4),
                    Text(
                      item.locationTag,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: item.color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  item.tag,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: item.color,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _handleAction(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color:
                        item.unread ? AppColors.primary : AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: item.unread
                        ? null
                        : Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    item.actionLabel,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                      color: item.unread ? Colors.white : AppColors.text,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SparkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pts = [0.3, 0.45, 0.35, 0.55, 0.5, 0.72, 0.85];
    final dx = size.width / (pts.length - 1);
    final path = Path();

    for (int i = 0; i < pts.length; i++) {
      final x = i * dx;
      final y = size.height - (pts[i] * size.height);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );

    canvas.drawCircle(
      Offset(size.width, size.height - (pts.last * size.height)),
      3.5,
      Paint()..color = AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
