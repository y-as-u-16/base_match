import 'package:flutter/material.dart';

class MetricData {
  const MetricData({required this.label, required this.value});

  final String label;
  final String value;
}

class StatsHero extends StatelessWidget {
  const StatsHero({
    super.key,
    required this.plateAppearances,
    required this.pitchingAppearances,
    required this.battingPlayers,
    required this.pitchingPlayers,
    required this.onAddRecord,
  });

  final int plateAppearances;
  final int pitchingAppearances;
  final int battingPlayers;
  final int pitchingPlayers;
  final VoidCallback onAddRecord;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _ScoreLinesPainter(
                lineColor: colorScheme.onPrimary.withValues(alpha: 0.10),
                accentColor: colorScheme.tertiary.withValues(alpha: 0.18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.onPrimary.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.query_stats_rounded,
                          size: 22,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'サマリー',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: colorScheme.onPrimary.withValues(
                                alpha: 0.76,
                              ),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '積み上げた記録を一画面で確認',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w900,
                              height: 1.18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
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
                      children: [
                        _HeroMetric(
                          width: tileWidth,
                          label: '打席',
                          value: '$plateAppearances',
                        ),
                        _HeroMetric(
                          width: tileWidth,
                          label: '投球',
                          value: '$pitchingAppearances',
                        ),
                        _HeroMetric(
                          width: tileWidth,
                          label: '打者',
                          value: '$battingPlayers',
                        ),
                        _HeroMetric(
                          width: tileWidth,
                          label: '投手',
                          value: '$pitchingPlayers',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onAddRecord,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('記録を追加'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.onPrimary,
                      foregroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
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
          color: colorScheme.onPrimary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.onPrimary.withValues(alpha: 0.14),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: 0.70),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatsPanel extends StatelessWidget {
  const StatsPanel({
    super.key,
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.primaryLabel,
    required this.primaryValue,
    required this.supportingMetrics,
    required this.chart,
  });

  final String label;
  final IconData icon;
  final Color accentColor;
  final String primaryLabel;
  final String primaryValue;
  final List<MetricData> supportingMetrics;
  final Widget chart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.52),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(icon, color: accentColor, size: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        primaryLabel,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow.withValues(
                      alpha: 0.86,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.34),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 9, 12, 10),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        primaryValue,
                        maxLines: 1,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            chart,
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 520 ? 4 : 2;
                final spacing = 10.0;
                final tileWidth =
                    (constraints.maxWidth - spacing * (columns - 1)) / columns;

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
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 9),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
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
          color: colorScheme.surfaceContainerLow.withValues(alpha: 0.76),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.42),
          ),
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
                    color: colorScheme.onSurface,
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

class BattingSparkline extends StatelessWidget {
  const BattingSparkline({
    super.key,
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
                color: colorScheme.surfaceContainerLow.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.40),
                ),
              ),
              child: CustomPaint(
                painter: _BatPathPainter(
                  color: colorScheme.primary.withValues(alpha: 0.16),
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

class PitchingDiamond extends StatelessWidget {
  const PitchingDiamond({
    super.key,
    required this.outsPitched,
    required this.strikeouts,
  });

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
          color: colorScheme.surfaceContainerLow.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.40),
          ),
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

class _ScoreLinesPainter extends CustomPainter {
  const _ScoreLinesPainter({
    required this.lineColor,
    required this.accentColor,
  });

  final Color lineColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final accentPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    for (var i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final path = Path()
      ..moveTo(size.width * 0.58, size.height * 0.18)
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.06,
        size.width * 0.96,
        size.height * 0.20,
      );
    canvas.drawPath(path, accentPaint);
  }

  @override
  bool shouldRepaint(covariant _ScoreLinesPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.accentColor != accentColor;
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
