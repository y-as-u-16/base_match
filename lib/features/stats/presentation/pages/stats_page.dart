import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../games/presentation/view_models/game_view_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/services/stats_calculator.dart';
import '../widgets/stats_page_widgets.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localGameStoreProvider);
    final battingRows = NamedBattingStats.fromAppearances(
      state.plateAppearances,
    );
    final pitchingRows = NamedPitchingStats.fromAppearances(
      state.pitchingAppearances,
    );
    final l10n = AppLocalizations.of(context);
    final battingPanels = battingRows.isEmpty
        ? [
            NamedBattingStats(
              playerName: l10n.noBattingStatsLabel,
              stats: BattingStats.empty(),
            ),
          ]
        : battingRows;
    final pitchingPanels = pitchingRows.isEmpty
        ? [
            NamedPitchingStats(
              playerName: l10n.noPitchingStatsLabel,
              stats: PitchingStats.empty(),
            ),
          ]
        : pitchingRows;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l10n.statsTitle),
        centerTitle: false,
        backgroundColor: colorScheme.surfaceContainerLowest,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: _statsTitleStyle(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StatsHero(
              plateAppearances: state.plateAppearances.length,
              pitchingAppearances: state.pitchingAppearances.length,
              battingPlayers: battingRows.length,
              pitchingPlayers: pitchingRows.length,
              onAddRecord: () => context.go('/games/create'),
            ),
            const SizedBox(height: 24),
            SectionHeader(title: l10n.battingStatsTitle),
            const SizedBox(height: 12),
            ...battingPanels.map((row) {
              final batting = row.stats;
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: StatsPanel(
                  label: row.playerName,
                  icon: Icons.sports_baseball_outlined,
                  accentColor: colorScheme.tertiary,
                  primaryLabel: l10n.seasonAverageMetricLabel,
                  primaryValue: batting.averageLabel,
                  supportingMetrics: [
                    MetricData(label: '打席', value: '${batting.pa}'),
                    MetricData(label: '打数', value: '${batting.ab}'),
                    MetricData(label: '安打', value: '${batting.hits}'),
                    MetricData(label: '本塁打', value: '${batting.hr}'),
                    MetricData(label: '四球', value: '${batting.walks}'),
                    MetricData(label: '三振', value: '${batting.so}'),
                  ],
                  chart: BattingSparkline(
                    hits: batting.hits,
                    walks: batting.walks,
                    strikeouts: batting.so,
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            SectionHeader(title: l10n.pitchingStatsTitle),
            const SizedBox(height: 12),
            ...pitchingPanels.map((row) {
              final pitching = row.stats;
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: StatsPanel(
                  label: row.playerName,
                  icon: Icons.speed_outlined,
                  accentColor: colorScheme.primary,
                  primaryLabel: l10n.seasonEraMetricLabel,
                  primaryValue: pitching.eraLabel,
                  supportingMetrics: [
                    MetricData(label: '登板', value: '${pitching.games}'),
                    MetricData(label: '投球回', value: pitching.inningsLabel),
                    MetricData(label: '自責点', value: '${pitching.earnedRuns}'),
                    MetricData(label: '奪三振', value: '${pitching.strikeouts}'),
                  ],
                  chart: PitchingDiamond(
                    outsPitched: pitching.outsPitched,
                    strikeouts: pitching.strikeouts,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  TextStyle _statsTitleStyle(BuildContext context) {
    final base = Theme.of(context).textTheme.titleLarge;
    final colorScheme = Theme.of(context).colorScheme;

    return (base ?? const TextStyle()).copyWith(
      color: colorScheme.onSurface,
      fontSize: 22,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
    );
  }
}
