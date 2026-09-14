import 'package:flutter/material.dart';

import 'package:logitrack/core/theme/app_theme.dart';
import 'package:logitrack/core/widgets/wms_header.dart';

class AssetValuationPage extends StatelessWidget {
  const AssetValuationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WmsHeader(section: 'VALUATION'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
        children: [
          // ===== Date Range =====
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 13, color: AppColors.primary),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'Oct 1 – Oct 24, 2025 (MTD)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          size: 16, color: AppColors.secondaryText),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 11),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warehouse_outlined,
                        size: 13, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'North Bay H...',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===== Hero Valuation =====
          Container(
            padding: const EdgeInsets.all(15),
            decoration: _card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_balance_outlined,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 7),
                    Text(
                      'WAREHOUSE ASSET VALUATION',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.7,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_upward_rounded,
                              size: 10, color: AppColors.green),
                          SizedBox(width: 3),
                          Text(
                            '+4.2%',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$4,285,450',
                      style: TextStyle(
                        fontSize: 31,
                        height: 1,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '.00',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _Pill(
                      icon: Icons.qr_code_2_rounded,
                      text: '1,248 Total SKUs',
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.circle,
                        size: 4, color: AppColors.secondaryText),
                    const SizedBox(width: 8),
                    _Pill(
                      icon: Icons.inventory_2_outlined,
                      text: '142,850 Units in stock',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '30-DAY VALUATION TRAJECTORY',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.7,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Peak: \$4.31M',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 62,
                  child: CustomPaint(
                    size: const Size(double.infinity, 62),
                    painter: _TrajectoryPainter(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ===== Category Valuation =====
          Container(
            padding: const EdgeInsets.all(15),
            decoration: _card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.pie_chart_outline_rounded,
                        size: 15, color: AppColors.primary),
                    const SizedBox(width: 7),
                    Text(
                      'Category Valuation',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'BY % VALUE',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // stacked bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    height: 10,
                    child: Row(
                      children: [
                        Expanded(flex: 42, child: Container(color: AppColors.primary)),
                        Expanded(flex: 28, child: Container(color: const Color(0xFF3B82F6))),
                        Expanded(flex: 18, child: Container(color: const Color(0xFF93B4E8))),
                        Expanded(flex: 12, child: Container(color: AppColors.border)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Text(
                      '\$0',
                      style: TextStyle(
                        fontSize: 8.5,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Total Portfolio: \$4.28M',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                _CatRow(
                  color: AppColors.primary,
                  name: 'Industrial Hardware',
                  pct: '42% allocation',
                  value: '\$1,800,000',
                ),
                const SizedBox(height: 9),
                const _CatRow(
                  color: Color(0xFF3B82F6),
                  name: 'Electronics & Comms',
                  pct: '28% allocation',
                  value: '\$1,200,000',
                ),
                const SizedBox(height: 9),
                const _CatRow(
                  color: Color(0xFF93B4E8),
                  name: 'Packaging Materials',
                  pct: '18% allocation',
                  value: '\$770,000',
                ),
                const SizedBox(height: 9),
                _CatRow(
                  color: AppColors.secondaryText,
                  name: 'Industrial Chemicals',
                  pct: '12% allocation',
                  value: '\$515,000',
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ===== Hub Storage =====
          Container(
            padding: const EdgeInsets.all(15),
            decoration: _card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warehouse_outlined,
                        size: 15, color: AppColors.primary),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Hub Storage\nDistribution',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.2,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    Text(
                      'ZONE\nDENSITY',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 8.5,
                        height: 1.3,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF2C4160), Color(0xFF16233A)],
                    ),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.view_in_ar_rounded,
                          size: 46,
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 10,
                        child: Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Zone B & C Peak Utilization',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    '92% cubic capacity consumed',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Active',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ===== Velocity Analysis =====
          Container(
            padding: const EdgeInsets.all(15),
            decoration: _card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.speed_rounded,
                        size: 15, color: AppColors.primary),
                    const SizedBox(width: 7),
                    Text(
                      'Velocity Analysis',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'TURNOVER MATRIX',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Icon(Icons.circle, size: 6, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'FAST-MOVING (HIGH TURN RATE)',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _VelRow(
                  icon: Icons.inventory_rounded,
                  name: 'Corrugated Shipping Boxes',
                  sub: 'Turnover: 8.4x / mo • 16,200 units',
                  badge: '8.4x',
                  badgeColor: AppColors.primary,
                ),
                const SizedBox(height: 9),
                _VelRow(
                  icon: Icons.settings_rounded,
                  name: 'Heavy-Duty Ball Bearings',
                  sub: 'Turnover: 6.2x / mo • 3,800 units',
                  badge: '6.2x',
                  badgeColor: AppColors.primary,
                ),

                const SizedBox(height: 16),

                Row(
                  children: const [
                    Icon(Icons.circle, size: 6, color: AppColors.red),
                    SizedBox(width: 6),
                    Text(
                      'DEAD STOCK / IDLE ALERTS',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        color: AppColors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const _VelRow(
                  icon: Icons.hourglass_empty_rounded,
                  name: 'High-Temp Silicone Gasket',
                  sub: '0 movement in 90 days • 240 units ...',
                  badge: '90d',
                  badgeColor: AppColors.red,
                  danger: true,
                ),
                const SizedBox(height: 9),
                const _VelRow(
                  icon: Icons.block_rounded,
                  name: 'Pneumatic Valve 12mm',
                  sub: '0 movement in 120 days • \$4,200 ...',
                  badge: '120d',
                  badgeColor: AppColors.red,
                  danger: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ===== Export =====
          Container(
            padding: const EdgeInsets.all(15),
            decoration: _card,
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.download_rounded,
                        size: 15, color: AppColors.primary),
                    const SizedBox(width: 7),
                    Text(
                      'Export Data & Audit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'COMPLIANCE',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.picture_as_pdf_outlined,
                            size: 17, color: Colors.white),
                        SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            'Export Inventory Valuation (PDF)',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_downward_rounded,
                            size: 15, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                _ExportBtn(
                  icon: Icons.table_chart_outlined,
                  label: 'Export Full Stock Audit (Excel / CSV)',
                  trailing: Icons.arrow_downward_rounded,
                ),
                const SizedBox(height: 9),
                _ExportBtn(
                  icon: Icons.mail_outline_rounded,
                  label: 'Share Monthly Report to Management',
                  trailing: Icons.chevron_right_rounded,
                ),
              ],
            ),
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

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.secondaryText),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

class _CatRow extends StatelessWidget {
  const _CatRow({
    required this.color,
    required this.name,
    required this.pct,
    required this.value,
  });

  final Color color;
  final String name;
  final String pct;
  final String value;

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
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  pct,
                  style: TextStyle(
                    fontSize: 9.5,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _VelRow extends StatelessWidget {
  const _VelRow({
    required this.icon,
    required this.name,
    required this.sub,
    required this.badge,
    required this.badgeColor,
    this.danger = false,
  });

  final IconData icon;
  final String name;
  final String sub;
  final String badge;
  final Color badgeColor;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: danger
            ? AppColors.red.withOpacity(0.04)
            : AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: danger
            ? Border.all(color: AppColors.red.withOpacity(0.18))
            : null,
      ),
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              icon,
              size: 16,
              color: danger ? AppColors.red : AppColors.secondaryText,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
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
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportBtn extends StatelessWidget {
  const _ExportBtn({
    required this.icon,
    required this.label,
    required this.trailing,
  });

  final IconData icon;
  final String label;
  final IconData trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.text),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
          ),
          Icon(trailing, size: 16, color: AppColors.secondaryText),
        ],
      ),
    );
  }
}

class _TrajectoryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pts = [0.25, 0.32, 0.28, 0.45, 0.40, 0.58, 0.52, 0.70, 0.66, 0.88, 0.80];
    final dx = size.width / (pts.length - 1);

    final line = Path();
    final fill = Path();

    for (int i = 0; i < pts.length; i++) {
      final x = i * dx;
      final y = size.height - (pts[i] * size.height);
      if (i == 0) {
        line.moveTo(x, y);
        fill.moveTo(x, size.height);
        fill.lineTo(x, y);
      } else {
        line.lineTo(x, y);
        fill.lineTo(x, y);
      }
    }
    fill.lineTo(size.width, size.height);
    fill.close();

    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.20),
            AppColors.primary.withOpacity(0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawPath(
      line,
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}