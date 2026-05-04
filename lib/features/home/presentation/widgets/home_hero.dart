import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../models/season_summary.dart';

class HomeHero extends StatelessWidget {
  const HomeHero({super.key, required this.summary});

  final SeasonSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.58),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.62),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _BallparkLinePainter(
                      lineColor: colorScheme.primary.withValues(alpha: 0.08),
                      accentColor: colorScheme.tertiary.withValues(alpha: 0.10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 390;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SeasonPill(
                            label: l10n.seasonSummarySubtitle(summary.year),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            l10n.homeHeadline,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w900,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: Text(
                              l10n.homeDescription,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _HeroStatChip(
                                minWidth: compact ? 128 : 150,
                                label: l10n.seasonGamesMetricLabel,
                                value: '${summary.games}',
                              ),
                              _HeroStatChip(
                                minWidth: compact ? 128 : 150,
                                label: l10n.seasonRecordMetricLabel,
                                value:
                                    '${summary.wins}-${summary.losses}-${summary.draws}',
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SeasonPill extends StatelessWidget {
  const _SeasonPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.14)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 14,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStatChip extends StatelessWidget {
  const _HeroStatChip({
    required this.label,
    required this.value,
    required this.minWidth,
  });

  final String label;
  final String value;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth, minHeight: 66),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.86),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  maxLines: 1,
                  style: theme.textTheme.headlineSmall?.copyWith(
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
    );
  }
}

class _BallparkLinePainter extends CustomPainter {
  const _BallparkLinePainter({
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
      ..style = PaintingStyle.fill;

    final center = Offset(size.width * 0.78, size.height * 0.60);
    final base = size.shortestSide * 0.16;
    final diamond = Path()
      ..moveTo(center.dx, center.dy - base)
      ..lineTo(center.dx + base, center.dy)
      ..lineTo(center.dx, center.dy + base)
      ..lineTo(center.dx - base, center.dy)
      ..close();

    canvas.drawCircle(
      center.translate(base * 0.08, base * 0.08),
      base * 1.9,
      accentPaint,
    );
    canvas.drawPath(diamond, linePaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: base * 2.35),
      3.40,
      2.30,
      false,
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _BallparkLinePainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.accentColor != accentColor;
  }
}
