import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../models/season_summary.dart';

class SeasonSummaryCard extends StatelessWidget {
  const SeasonSummaryCard({super.key, required this.summary});

  final SeasonSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.62),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(9),
                    child: Icon(
                      Icons.query_stats_rounded,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.seasonSummaryTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w900,
                          height: 1.12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.seasonSummarySubtitle(summary.year),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
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
  });

  final double width;
  final IconData icon;
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
          color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.72),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.62,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Icon(icon, size: 17, color: colorScheme.tertiary),
                ),
              ),
              const SizedBox(height: 10),
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
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
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
