import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/transactions/domain/asset_trend_calculator.dart';

/// Short ID month labels for the x-axis (index 1..12). `MonthSelector`'s
/// `_idMonths` is library-private AND full-length, so the compact set is
/// redefined here.
const List<String> _kMonthsShort = [
  '',
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// The app's first `fl_chart` `LineChart` (V2-M7): a net-worth-over-time trend
/// over the reconstructed [TrendPoint]s (x = month index, y = net worth). Smooth
/// line + a subtle area fill in the positive accent, compact rupiah y-labels and
/// short ID month x-labels. Degrades to a single dot for ≤1 point (the usecase
/// seeds a baseline point for empty history, so the chart is never empty).
class AssetTrendChart extends StatelessWidget {
  const AssetTrendChart({required this.points, super.key});

  final List<TrendPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty)
      return const SizedBox.shrink(); // usecase seeds ≥1 point
    final theme = Theme.of(context);
    final s = Strings.of(context)!;
    final accent = context.colors.income; // style-guide positive accent
    // Respect the OS "reduce motion" setting — skip the entrance animation.
    final reduce = MediaQuery.disableAnimationsOf(context);
    final spots = [
      for (final (i, p) in points.indexed)
        FlSpot(i.toDouble(), p.netWorth.toDouble()),
    ];
    // A single point can't draw a line — show its dot so the card isn't blank.
    final single = points.length <= 1;
    return Semantics(
      // The trend shape has no other text form — voice the current figure.
      container: true,
      label: s.chartTrendSemantics(formatRupiah(points.last.netWorth)),
      child: AppCard(
        child: SizedBox(
          height: 200,
          child: LineChart(
            duration: reduce ? Duration.zero : AppDurations.fast,
            LineChartData(
              // Tap/drag a point → its net-worth value in a small tooltip.
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => context.colors.surfaceSoft,
                  getTooltipItems: (touched) => [
                    for (final spot in touched)
                      LineTooltipItem(
                        formatRupiah(points[spot.spotIndex].netWorth),
                        theme.textTheme.bodySmall!,
                      ),
                  ],
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: accent,
                  barWidth: 3,
                  dotData: FlDotData(show: single),
                  belowBarData: BarAreaData(
                    show: true,
                    color: accent.withValues(alpha: 0.12),
                  ),
                ),
              ],
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                // AxisTitles defaults to a hidden SideTitles.
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 48,
                    getTitlesWidget: (value, meta) => Text(
                      formatCompactRupiah(value.toInt()),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    // 12 points would crowd; label every other month.
                    interval: points.length > 6 ? 2 : 1,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= points.length) {
                        return const SizedBox.shrink();
                      }
                      final month = DateTime.fromMillisecondsSinceEpoch(
                        points[i].monthMillis,
                      ).month;
                      return Text(
                        _kMonthsShort[month],
                        style: theme.textTheme.bodySmall,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
