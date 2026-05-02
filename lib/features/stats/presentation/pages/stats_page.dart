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
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: l10n.battingStatsTitle,
            child: _BattingTile(stats: batting),
          ),
          const SizedBox(height: 20),
          _Section(
            title: l10n.pitchingStatsTitle,
            child: _PitchingTile(stats: pitching),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _BattingTile extends StatelessWidget {
  const _BattingTile({required this.stats});

  final BattingStats stats;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(AppLocalizations.of(context).teamBattingTitle),
        subtitle: Text(
          AppLocalizations.of(context).battingStatsSummary(
            stats.pa,
            stats.ab,
            stats.hits,
            stats.hr,
            stats.so,
          ),
        ),
        trailing: Text(stats.averageLabel),
      ),
    );
  }
}

class _PitchingTile extends StatelessWidget {
  const _PitchingTile({required this.stats});

  final PitchingStats stats;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(AppLocalizations.of(context).teamPitchingTitle),
        subtitle: Text(
          AppLocalizations.of(context).pitchingStatsSummary(
            stats.games,
            stats.inningsLabel,
            stats.earnedRuns,
            stats.strikeouts,
          ),
        ),
        trailing: Text(stats.eraLabel),
      ),
    );
  }
}
