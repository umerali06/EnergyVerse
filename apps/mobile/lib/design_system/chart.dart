import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'motion.dart';
import 'tokens_generated.dart';

enum ChartStatus { loading, error, empty, ready }

/// A single day/value point for [TimeSeriesChart]. Kept intentionally
/// generic (label + value) so any future module can chart daily counts
/// without inventing a new shape.
class SeriesPoint {
  const SeriesPoint({required this.label, required this.value});

  final String label;
  final int value;
}

/// Chart color/typography/motion contract every future module chart reuses.
/// Colors always come from [DsColors]/[Theme] — never a literal `Color(...)`
/// in a chart call site — so a brand-token change repaints every chart.
class ChartTheme {
  const ChartTheme({
    required this.line,
    required this.grid,
    required this.axisLabel,
    required this.tooltipBackground,
    required this.tooltipText,
  });

  final Color line;
  final Color grid;
  final Color axisLabel;
  final Color tooltipBackground;
  final Color tooltipText;

  factory ChartTheme.of(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    return ChartTheme(
      line: dark ? DsColors.primary400 : DsColors.primary700,
      grid: dark ? DsColors.darkBorder : DsColors.lightBorder,
      axisLabel: dark ? DsColors.darkTextMuted : DsColors.lightTextMuted,
      tooltipBackground: dark ? DsColors.darkElevated : DsColors.lightElevated,
      tooltipText: dark ? DsColors.darkTextPrimary : DsColors.lightTextPrimary,
    );
  }
}

/// Loading skeleton / empty / error / ready states shared by every chart
/// type, so a future module dropping in a new chart never re-solves this.
class ChartFrame extends StatelessWidget {
  const ChartFrame({
    required this.status,
    required this.child,
    this.height = 220,
    this.emptyTitle = 'No data yet',
    this.emptyDescription = 'Data will appear here once it is available.',
    this.errorDescription =
        "Couldn't load this chart. Check your connection and try again.",
    this.onRetry,
    super.key,
  });

  final ChartStatus status;
  final Widget child;
  final double height;
  final String emptyTitle;
  final String emptyDescription;
  final String errorDescription;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ChartStatus.loading:
        return SizedBox(
          height: height,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 3)),
        );
      case ChartStatus.error:
        return SizedBox(
          height: height,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(errorDescription, textAlign: TextAlign.center),
                if (onRetry != null) ...[
                  const SizedBox(height: DsSpacing.s3),
                  TextButton(onPressed: onRetry, child: const Text('Retry')),
                ],
              ],
            ),
          ),
        );
      case ChartStatus.empty:
        return SizedBox(
          height: height,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  emptyTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: DsSpacing.s2),
                Text(
                  emptyDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      case ChartStatus.ready:
        return SizedBox(height: height, child: child);
    }
  }
}

/// Line chart for a single time series (e.g. dashboard activity/day).
/// Entry animation respects reduced-motion via the shared [motionDuration]
/// helper — no animation plays when the platform requests less motion.
class TimeSeriesChart extends StatelessWidget {
  const TimeSeriesChart({
    required this.data,
    required this.status,
    this.height = 220,
    this.emptyTitle = 'No activity yet',
    this.emptyDescription = 'Activity appears here once events are recorded.',
    this.errorDescription =
        "Couldn't load activity data. Check your connection and try again.",
    this.onRetry,
    super.key,
  });

  final List<SeriesPoint> data;
  final ChartStatus status;
  final double height;
  final String emptyTitle;
  final String emptyDescription;
  final String errorDescription;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final palette = ChartTheme.of(context);
    final duration = motionDuration(context, DsMotion.normal);
    final maxY = data.isEmpty
        ? 1.0
        : (data.map((point) => point.value).reduce((a, b) => a > b ? a : b))
                .toDouble() *
            1.2;
    return ChartFrame(
      emptyDescription: emptyDescription,
      emptyTitle: emptyTitle,
      errorDescription: errorDescription,
      height: height,
      onRetry: onRetry,
      status: status,
      child: LineChart(
        duration: duration,
        LineChartData(
          maxY: maxY <= 0 ? 1 : maxY,
          minY: 0,
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: palette.grid, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontFamily: DsTypography.mono,
                    fontSize: DsTypography.sizeCaption,
                    color: palette.axisLabel,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: data.isEmpty
                    ? 1.0
                    : (data.length / 4).clamp(1, data.length).toDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: DsSpacing.s1),
                    child: Text(
                      data[index].label,
                      style: TextStyle(
                        fontFamily: DsTypography.mono,
                        fontSize: DsTypography.sizeCaption,
                        color: palette.axisLabel,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => palette.tooltipBackground,
              getTooltipItems: (spots) => spots
                  .map(
                    (spot) => LineTooltipItem(
                      '${spot.y.toInt()}',
                      TextStyle(
                        fontFamily: DsTypography.mono,
                        color: palette.tooltipText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var index = 0; index < data.length; index++)
                  FlSpot(index.toDouble(), data[index].value.toDouble()),
              ],
              isCurved: true,
              color: palette.line,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: palette.line.withAlpha(38),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
