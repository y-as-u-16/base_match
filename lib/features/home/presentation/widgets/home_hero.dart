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

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary,
                Color.lerp(colorScheme.primary, colorScheme.secondary, 0.44)!,
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.18),
                blurRadius: 34,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _BallparkLinePainter(
                    lineColor: colorScheme.onPrimary.withValues(alpha: 0.16),
                    accentColor: colorScheme.tertiary.withValues(alpha: 0.20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 390;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _SeasonPill(
                          label: l10n.seasonSummarySubtitle(summary.year),
                        ),
                        const SizedBox(height: 22),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 430),
                          child: Text(
                            l10n.homeHeadline,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontSize: compact ? 34 : 42,
                              fontWeight: FontWeight.w900,
                              height: 1.02,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 470),
                          child: Text(
                            l10n.homeDescription,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary.withValues(
                                alpha: 0.78,
                              ),
                              height: 1.45,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                        _HeroScoreboard(
                          gamesLabel: l10n.seasonGamesMetricLabel,
                          gamesValue: '${summary.games}',
                          recordLabel: l10n.seasonRecordMetricLabel,
                          recordValue:
                              '${summary.wins}-${summary.losses}-${summary.draws}',
                          foregroundColor: colorScheme.onPrimary,
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
    );
  }
}

class _HeroScoreboard extends StatelessWidget {
  const _HeroScoreboard({
    required this.gamesLabel,
    required this.gamesValue,
    required this.recordLabel,
    required this.recordValue,
    required this.foregroundColor,
  });

  final String gamesLabel;
  final String gamesValue;
  final String recordLabel;
  final String recordValue;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: foregroundColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: foregroundColor.withValues(alpha: 0.16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 330;

            if (compact) {
              return Column(
                children: [
                  _HeroStatChip(
                    label: gamesLabel,
                    value: gamesValue,
                    foregroundColor: foregroundColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Divider(
                      height: 1,
                      color: foregroundColor.withValues(alpha: 0.14),
                    ),
                  ),
                  _HeroStatChip(
                    label: recordLabel,
                    value: recordValue,
                    foregroundColor: foregroundColor,
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: _HeroStatChip(
                    label: gamesLabel,
                    value: gamesValue,
                    foregroundColor: foregroundColor,
                  ),
                ),
                SizedBox(
                  height: 54,
                  child: VerticalDivider(
                    width: 1,
                    color: foregroundColor.withValues(alpha: 0.14),
                  ),
                ),
                Expanded(
                  child: _HeroStatChip(
                    label: recordLabel,
                    value: recordValue,
                    foregroundColor: foregroundColor,
                  ),
                ),
              ],
            );
          },
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
        color: colorScheme.onPrimary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.onPrimary.withValues(alpha: 0.16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 14,
              color: colorScheme.onPrimary.withValues(alpha: 0.84),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onPrimary.withValues(alpha: 0.84),
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
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
    required this.foregroundColor,
  });

  final String label;
  final String value;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w900,
                height: 1,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: foregroundColor.withValues(alpha: 0.66),
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ],
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
