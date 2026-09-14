import 'package:flutter/material.dart';

import 'package:logitrack/core/localization/app_localizations.dart';
import 'package:logitrack/core/theme/app_theme.dart';
import 'package:logitrack/core/widgets/wms_header.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  int _range = 1;

  static const _rangeKeys = ['today', 'sevenDays', 'thirtyDays', 'quarter'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WmsHeader(sectionKey: 'analytics'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
        children: [
          // ===== Title =====
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('performanceReports'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      context.tr('operationalKpis'),
                      style: TextStyle(
                        fontSize: 10.5,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(Icons.file_download_outlined,
                    size: 18, color: AppColors.text),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===== Range Tabs =====
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: List.generate(_rangeKeys.length, (i) {
                final sel = i == _range;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _range = i),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        context.tr(_rangeKeys[i]),
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          color: sel ? Colors.white : AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 14),

          // ===== Hero KPI =====
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF16233A), Color(0xFF23364F)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(Icons.speed_rounded,
                          size: 21, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('overallFulfillmentRate'),
                            style: TextStyle(
                              fontSize: 8.5,
                              letterSpacing: 0.9,
                              fontWeight: FontWeight.w900,
                              color: Colors.white60,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '98.4',
                                style: TextStyle(
                                  fontSize: 30,
                                  height: 1,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '%',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_upward_rounded,
                              size: 12, color: AppColors.green),
                          const SizedBox(width: 3),
                          Text(
                            '+2.1%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: AppColors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _HeroStat(context.tr('ordersLabel'), '2,847'),
                    const _HeroDivider(),
                    _HeroStat(context.tr('accuracy'), '99.1%'),
                    const _HeroDivider(),
                    _HeroStat(context.tr('avgCycle'), '4.2m'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ===== KPI Grid =====
          Row(
            children: [
              Expanded(
                child: _KpiCard(
                  icon: Icons.trending_up_rounded,
                  label: context.tr('inboundVolume'),
                  value: '18,420',
                  sub: context.tr('pkgsReceived'),
                  delta: '+12.4%',
                  up: true,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _KpiCard(
                  icon: Icons.trending_down_rounded,
                  label: context.tr('outboundVolume'),
                  value: '21,105',
                  sub: context.tr('pkgsDispatched'),
                  delta: '+8.9%',
                  up: true,
                  color: AppColors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: _KpiCard(
                  icon: Icons.error_outline_rounded,
                  label: context.tr('stockVariance'),
                  value: '-1.18%',
                  sub: '42 ${context.tr('discrepancies')}',
                  delta: '-0.4%',
                  up: false,
                  color: AppColors.red,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _KpiCard(
                  icon: Icons.timer_outlined,
                  label: context.tr('dockTurnaround'),
                  value: '32m',
                  sub: context.tr('avgPerTruck'),
                  delta: '-6m',
                  up: true,
                  color: AppColors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===== Chart: Throughput =====
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
                            context.tr('throughputTrend'),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            context.tr('dailyProcessingVolume'),
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        '${context.tr('peak')}: ${context.tr('thu')}',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 130,
                  child: CustomPaint(
                    size: const Size(double.infinity, 130),
                    painter: _LinePainter(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Day(context.tr('mon')),
                    _Day(context.tr('tue')),
                    _Day(context.tr('wed')),
                    _Day(context.tr('thu'), active: true),
                    _Day(context.tr('fri')),
                    _Day(context.tr('sat')),
                    _Day(context.tr('sun')),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ===== Category Breakdown =====
          Container(
            padding: const EdgeInsets.all(15),
            decoration: _card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('categoryDistribution'),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  context.tr('stockValueByFamily'),
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 16),
                _CatBar(
                  label: context.tr('bearingsMechanical'),
                  value: '\$1.84M',
                  pct: 0.44,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                _CatBar(
                  label: context.tr('electronicsIcs'),
                  value: '\$1.12M',
                  pct: 0.27,
                  color: AppColors.green,
                ),
                const SizedBox(height: 12),
                _CatBar(
                  label: context.tr('chemicalsFluids'),
                  value: '\$0.71M',
                  pct: 0.17,
                  color: AppColors.orange,
                ),
                const SizedBox(height: 12),
                _CatBar(
                  label: context.tr('packagingConsumables'),
                  value: '\$0.53M',
                  pct: 0.12,
                  color: AppColors.secondaryText,
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ===== Top Movers =====
          Container(
            padding: const EdgeInsets.all(15),
            decoration: _card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      context.tr('topMovingSkus'),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      context.tr('viewAll'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _MoverRow(
                  rank: 1,
                  sku: 'BEAR-6205-HD',
                  name: context.tr('heavyDutyBallBearings'),
                  units: '4,280',
                  delta: '+18%',
                  up: true,
                ),
                Divider(height: 22, color: AppColors.border),
                _MoverRow(
                  rank: 2,
                  sku: 'PACK-BX12-25',
                  name: context.tr('corrugatedBoxes'),
                  units: '3,140',
                  delta: '+11%',
                  up: true,
                ),
                Divider(height: 22, color: AppColors.border),
                _MoverRow(
                  rank: 3,
                  sku: 'ELEC-STM32-DEV',
                  name: context.tr('microcontrollerBoards'),
                  units: '1,905',
                  delta: '-4%',
                  up: false,
                ),
                Divider(height: 22, color: AppColors.border),
                _MoverRow(
                  rank: 4,
                  sku: 'CHEM-SIL-300',
                  name: context.tr('highTempSilicone'),
                  units: '1,220',
                  delta: '+6%',
                  up: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ===== Export =====
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.table_chart_outlined,
                        size: 17, color: AppColors.text),
                    label: Text(
                      context.tr('exportExcel'),
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
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
                    onPressed: () {},
                    icon: const Icon(Icons.picture_as_pdf_outlined,
                        size: 17, color: Colors.white),
                    label: Text(
                      context.tr('exportPdf'),
                      style: TextStyle(
                        fontSize: 12.5,
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
        ],
      ),
    );
  }
}

BoxDecoration get _card => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    );

class _HeroStat extends StatelessWidget {
  const _HeroStat(this.label, this.value);

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
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroDivider extends StatelessWidget {
  const _HeroDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: Colors.white.withOpacity(0.15),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
    required this.delta,
    required this.up,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String sub;
  final String delta;
  final bool up;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    up
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: 10,
                    color: up ? AppColors.green : AppColors.red,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    delta,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: up ? AppColors.green : AppColors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
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

class _Day extends StatelessWidget {
  const _Day(this.label, {this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 9.5,
        fontWeight: active ? FontWeight.w900 : FontWeight.w600,
        color: active ? AppColors.primary : AppColors.secondaryText,
      ),
    );
  }
}

class _CatBar extends StatelessWidget {
  const _CatBar({
    required this.label,
    required this.value,
    required this.pct,
    required this.color,
  });

  final String label;
  final String value;
  final double pct;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 34,
              child: Text(
                '${(pct * 100).round()}%',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondaryText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 6,
            backgroundColor: AppColors.background,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _MoverRow extends StatelessWidget {
  const _MoverRow({
    required this.rank,
    required this.sku,
    required this.name,
    required this.units,
    required this.delta,
    required this.up,
  });

  final int rank;
  final String sku;
  final String name;
  final String units;
  final String delta;
  final bool up;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 26,
          width: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: rank == 1 ? AppColors.primary : AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$rank',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: rank == 1 ? Colors.white : AppColors.text,
            ),
          ),
        ),
        const SizedBox(width: 11),
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
              units,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              delta,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
                color: up ? AppColors.green : AppColors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pts = [0.35, 0.52, 0.44, 0.88, 0.66, 0.30, 0.58];
    final dx = size.width / (pts.length - 1);

    final path = Path();
    final fill = Path();

    for (int i = 0; i < pts.length; i++) {
      final x = i * dx;
      final y = size.height - (pts[i] * size.height);
      if (i == 0) {
        path.moveTo(x, y);
        fill.moveTo(x, size.height);
        fill.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fill.lineTo(x, y);
      }
    }
    fill.lineTo(size.width, size.height);
    fill.close();

    // gradient fill
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.22),
            AppColors.primary.withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // grid
    final grid = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    for (int i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // line
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 2.6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );

    // dots
    for (int i = 0; i < pts.length; i++) {
      final x = i * dx;
      final y = size.height - (pts[i] * size.height);
      final peak = i == 3;
      canvas.drawCircle(
          Offset(x, y), peak ? 6 : 4, Paint()..color = Colors.white);
      canvas.drawCircle(
        Offset(x, y),
        peak ? 6 : 4,
        Paint()
          ..color = AppColors.primary
          ..strokeWidth = peak ? 3 : 2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
