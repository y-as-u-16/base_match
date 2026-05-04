import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../models/season_summary.dart';

class SeasonSummaryCard extends StatelessWidget {
  const SeasonSummaryCard({super.key, required this.summary});

  final SeasonSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
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
                        l10n.seasonSummaryTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF1D1D1F),
                          fontWeight: FontWeight.w900,
                          height: 1.12,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.seasonSummarySubtitle(summary.year),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF6E6E73),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.query_stats_rounded, color: Color(0xFF86868B)),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 520 ? 3 : 2;
                final spacing = 10.0;
                final tileWidth =
                    (constraints.maxWidth - spacing * (columns - 1)) / columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    _SeasonMetricTile(
                      width: tileWidth,
                      icon: Icons.sports_baseball_outlined,
                      label: l10n.seasonGamesMetricLabel,
                      value: l10n.seasonGamesCount(summary.games),
                      emphasized: true,
                    ),
                    _SeasonMetricTile(
                      width: tileWidth,
                      icon: Icons.emoji_events_outlined,
                      label: l10n.seasonRecordMetricLabel,
                      value: l10n.seasonRecordLabel(
                        summary.wins,
                        summary.losses,
                        summary.draws,
                      ),
                    ),
                    _SeasonMetricTile(
                      width: tileWidth,
                      icon: Icons.scoreboard_outlined,
                      label: l10n.seasonRunsMetricLabel,
                      value: l10n.seasonRunsLabel(summary.totalRuns),
                    ),
                    _SeasonMetricTile(
                      width: tileWidth,
                      icon: Icons.trending_up,
                      label: l10n.seasonAverageMetricLabel,
                      value: summary.battingAverage,
                    ),
                    _SeasonMetricTile(
                      width: tileWidth,
                      icon: Icons.speed_outlined,
                      label: l10n.seasonEraMetricLabel,
                      value: summary.era,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SeasonMetricTile extends StatelessWidget {
  const _SeasonMetricTile({
    required this.width,
    required this.icon,
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final double width;
  final IconData icon;
  final String label;
  final String value;
  final bool emphasized;

  static const _accentBlue = Color(0xFF0071E3);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = emphasized
        ? const Color(0xFF1D1D1F)
        : const Color(0xFFF5F5F7);
    final foreground = emphasized ? Colors.white : const Color(0xFF1D1D1F);
    final muted = emphasized
        ? Colors.white.withValues(alpha: 0.68)
        : const Color(0xFF6E6E73);

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: emphasized
                      ? Colors.white.withValues(alpha: 0.12)
                      : _accentBlue.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Icon(
                    icon,
                    size: 17,
                    color: emphasized ? Colors.white : _accentBlue,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: muted,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  maxLines: 1,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
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
