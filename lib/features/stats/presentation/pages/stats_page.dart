import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../games/presentation/view_models/game_view_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/services/stats_calculator.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localGameStoreProvider);
    final batting = BattingStats.fromAppearances(state.plateAppearances);
    final pitching = PitchingStats.fromAppearances(state.pitchingAppearances);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.statsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          _StatsPanel(
            title: l10n.battingStatsTitle,
            label: l10n.teamBattingTitle,
            icon: Icons.sports_baseball_outlined,
            accentColor: Theme.of(context).colorScheme.tertiary,
            primaryLabel: l10n.seasonAverageMetricLabel,
            primaryValue: batting.averageLabel,
            supportingMetrics: [
              _MetricData(label: '打席', value: '${batting.pa}'),
              _MetricData(label: '打数', value: '${batting.ab}'),
              _MetricData(label: '安打', value: '${batting.hits}'),
              _MetricData(label: '本塁打', value: '${batting.hr}'),
              _MetricData(label: '四球', value: '${batting.walks}'),
              _MetricData(label: '三振', value: '${batting.so}'),
            ],
            chart: _BattingSparkline(
              hits: batting.hits,
              walks: batting.walks,
              strikeouts: batting.so,
            ),
          ),
          const SizedBox(height: 16),
          _StatsPanel(
            title: l10n.pitchingStatsTitle,
            label: l10n.teamPitchingTitle,
            icon: Icons.speed_outlined,
            accentColor: Theme.of(context).colorScheme.primary,
            primaryLabel: l10n.seasonEraMetricLabel,
            primaryValue: pitching.eraLabel,
            supportingMetrics: [
              _MetricData(label: '登板', value: '${pitching.games}'),
              _MetricData(label: '投球回', value: pitching.inningsLabel),
              _MetricData(label: '自責点', value: '${pitching.earnedRuns}'),
              _MetricData(label: '奪三振', value: '${pitching.strikeouts}'),
            ],
            chart: _PitchingDiamond(
              outsPitched: pitching.outsPitched,
              strikeouts: pitching.strikeouts,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricData {
  const _MetricData({required this.label, required this.value});

  final String label;
  final String value;
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel({
    required this.title,
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.primaryLabel,
    required this.primaryValue,
    required this.supportingMetrics,
    required this.chart,
  });

  final String title;
  final String label;
  final IconData icon;
  final Color accentColor;
  final String primaryLabel;
  final String primaryValue;
  final List<_MetricData> supportingMetrics;
  final Widget chart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: title),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(icon, color: colorScheme.onPrimary),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                primaryLabel,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            primaryValue,
                            maxLines: 1,
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                chart,
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 520 ? 4 : 2;
                    final spacing = 10.0;
                    final tileWidth =
                        (constraints.maxWidth - spacing * (columns - 1)) /
                        columns;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: supportingMetrics
                          .map(
                            (metric) => _MetricTile(
                              width: tileWidth,
                              label: metric.label,
                              value: metric.value,
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.width,
    required this.label,
    required this.value,
  });

  final double width;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  maxLines: 1,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BattingSparkline extends StatelessWidget {
  const _BattingSparkline({
    required this.hits,
    required this.walks,
    required this.strikeouts,
  });

  final int hits;
  final int walks;
  final int strikeouts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final maxValue = [
      hits,
      walks,
      strikeouts,
      1,
    ].reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 72,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _BarStat(
            label: 'H',
            value: hits,
            maxValue: maxValue,
            color: colorScheme.tertiary,
          ),
          const SizedBox(width: 10),
          _BarStat(
            label: 'BB',
            value: walks,
            maxValue: maxValue,
            color: colorScheme.secondary,
          ),
          const SizedBox(width: 10),
          _BarStat(
            label: 'K',
            value: strikeouts,
            maxValue: maxValue,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.55,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: _BatPathPainter(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.18),
                ),
                child: Center(
                  child: Text(
                    '打撃の流れ',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarStat extends StatelessWidget {
  const _BarStat({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  final String label;
  final int value;
  final int maxValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fillFactor = 0.35 + (value / maxValue) * 0.65;

    return SizedBox(
      width: 34,
      child: Column(
        children: [
          SizedBox(
            height: 16,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$value',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: fillFactor,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.82),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const SizedBox(width: 34),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 16,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PitchingDiamond extends StatelessWidget {
  const _PitchingDiamond({required this.outsPitched, required this.strikeouts});

  final int outsPitched;
  final int strikeouts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final strikeoutRate = outsPitched == 0
        ? 0.0
        : (strikeouts / outsPitched).clamp(0.0, 1.0);

    return SizedBox(
      height: 82,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _DiamondPainter(
                  lineColor: colorScheme.primary.withValues(alpha: 0.24),
                  fillColor: colorScheme.primary.withValues(
                    alpha: 0.08 + strikeoutRate * 0.18,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  '投球テンポ',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w800,
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

class _BatPathPainter extends CustomPainter {
  const _BatPathPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.12, size.height * 0.62)
      ..quadraticBezierTo(
        size.width * 0.38,
        size.height * 0.12,
        size.width * 0.72,
        size.height * 0.44,
      )
      ..quadraticBezierTo(
        size.width * 0.86,
        size.height * 0.58,
        size.width * 0.9,
        size.height * 0.18,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BatPathPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _DiamondPainter extends CustomPainter {
  const _DiamondPainter({required this.lineColor, required this.fillColor});

  final Color lineColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.32, size.height * 0.5);
    final radius = size.height * 0.28;
    final diamond = Path()
      ..moveTo(center.dx, center.dy - radius)
      ..lineTo(center.dx + radius, center.dy)
      ..lineTo(center.dx, center.dy + radius)
      ..lineTo(center.dx - radius, center.dy)
      ..close();
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(diamond, fillPaint);
    canvas.drawPath(diamond, linePaint);
    canvas.drawCircle(center, 4, Paint()..color = lineColor);
  }

  @override
  bool shouldRepaint(covariant _DiamondPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }
}
