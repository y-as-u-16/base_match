import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../games/presentation/view_models/game_view_model.dart';
import '../../domain/services/stats_calculator.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localGameStoreProvider);
    final batting = BattingStats.fromAppearances(state.plateAppearances);
    final pitching = PitchingStats.fromAppearances(state.pitchingAppearances);

    return Scaffold(
      appBar: AppBar(title: const Text('成績')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '打撃成績',
            child: _BattingTile(stats: batting),
          ),
          const SizedBox(height: 20),
          _Section(
            title: 'ピッチング成績',
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
        title: const Text('チーム打撃'),
        subtitle: Text(
          '打席 ${stats.pa} / 打数 ${stats.ab} / 安打 ${stats.hits} / 本塁打 ${stats.hr} / 三振 ${stats.so}',
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
        title: const Text('チーム投手'),
        subtitle: Text(
          '登板 ${stats.games} / 投球回 ${stats.inningsLabel} / 自責 ${stats.earnedRuns} / 奪三振 ${stats.strikeouts}',
        ),
        trailing: Text(stats.eraLabel),
      ),
    );
  }
}
