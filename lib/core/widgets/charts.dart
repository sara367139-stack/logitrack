import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:logitrack/core/theme/app_theme.dart';

// ==================== BAR CHART ====================

class ThroughputBarChart extends StatelessWidget {
  const ThroughputBarChart({
    super.key,
    required this.inbound,
    required this.outbound,
    required this.labels,
    this.height = 160,
  });

  final List<double> inbound;
  final List<double> outbound;
  final List<String> labels;
  final double height;

  @override
  Widget build(BuildContext context) {
    final maxY = [...inbound, ...outbound]
            .reduce((a, b) => a > b ? a : b) *
        1.25;

    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => AppColors.text,
              tooltipRoundedRadius: 8,
              getTooltipItem: (g, gi, rod, ri) => BarTooltipItem(
                rod.toY.toInt().toString(),
                TextStyle(
                  color: AppColors.surface,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                getTitlesWidget: (v, meta) {
                  final i = v.toInt();
                  if (i < 0 || i >= labels.length) {
                    return const SizedBox.shrink();
                  }
                  final isLast = i == labels.length - 1;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight:
                            isLast ? FontWeight.w900 : FontWeight.w500,
                        color: isLast
                            ? AppColors.primary
                            : AppColors.secondaryText,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: AppColors.border, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(labels.length, (i) {
            return BarChartGroupData(
              x: i,
              barsSpace: 3,
              barRods: [
                BarChartRodData(
                  toY: inbound[i],
                  color: AppColors.primary,
                  width: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: outbound[i],
                  color: AppColors.primary.withOpacity(0.28),
                  width: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ==================== LINE CHART ====================

class TrendLineChart extends StatelessWidget {
  const TrendLineChart({
    super.key,
    required this.values,
    this.labels,
    this.height = 150,
    this.showDots = true,
    this.color,
  });

  final List<double> values;
  final List<String>? labels;
  final double height;
  final bool showDots;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    final maxY = values.reduce((a, b) => a > b ? a : b) * 1.2;
    final minY = values.reduce((a, b) => a < b ? a : b) * 0.75;

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.text,
              tooltipRoundedRadius: 8,
              getTooltipItems: (spots) => spots
                  .map((s) => LineTooltipItem(
                        s.y.toStringAsFixed(0),
                        TextStyle(
                          color: AppColors.surface,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                        ),
                      ))
                  .toList(),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY - minY) / 3,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: AppColors.border, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: labels != null,
                reservedSize: 24,
                getTitlesWidget: (v, meta) {
                  final i = v.toInt();
                  if (labels == null || i < 0 || i >= labels!.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      labels![i],
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                values.length,
                (i) => FlSpot(i.toDouble(), values[i]),
              ),
              isCurved: true,
              curveSmoothness: 0.32,
              color: c,
              barWidth: 2.6,
              dotData: FlDotData(
                show: showDots,
                getDotPainter: (spot, _, __, i) => FlDotCirclePainter(
                  radius: i == values.length - 1 ? 5 : 3.5,
                  color: AppColors.surface,
                  strokeWidth: i == values.length - 1 ? 3 : 2,
                  strokeColor: c,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [c.withOpacity(0.25), c.withOpacity(0)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== SPARKLINE ====================

class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.values,
    this.width = 110,
    this.height = 40,
    this.color,
  });

  final List<double> values;
  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;

    return SizedBox(
      width: width,
      height: height,
      child: LineChart(
        LineChartData(
          lineTouchData: const LineTouchData(enabled: false),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                values.length,
                (i) => FlSpot(i.toDouble(), values[i]),
              ),
              isCurved: true,
              color: c,
              barWidth: 2.2,
              dotData: FlDotData(
                show: true,
                checkToShowDot: (s, _) => s.x == values.length - 1,
                getDotPainter: (_, __, ___, ____) =>
                    FlDotCirclePainter(radius: 3.5, color: c, strokeWidth: 0),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [c.withOpacity(0.20), c.withOpacity(0)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== DONUT ====================

class CategoryDonut extends StatelessWidget {
  const CategoryDonut({
    super.key,
    required this.data,
    this.size = 160,
    this.centerLabel,
    this.centerValue,
  });

  /// (label, value, color)
  final List<(String, double, Color)> data;
  final double size;
  final String? centerLabel;
  final String? centerValue;

  @override
  Widget build(BuildContext context) {
    final total = data.fold<double>(0, (s, e) => s + e.$2);

    return SizedBox(
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: size * 0.3,
              sections: data.map((e) {
                final pct = (e.$2 / total) * 100;
                return PieChartSectionData(
                  value: e.$2,
                  color: e.$3,
                  radius: size * 0.18,
                  showTitle: pct > 8,
                  title: '${pct.round()}%',
                  titleStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
          if (centerValue != null)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  centerValue!,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),
                if (centerLabel != null)
                  Text(
                    centerLabel!,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
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