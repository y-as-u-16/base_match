import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../games/domain/entities/pitching_appearance.dart';
import '../../../games/domain/entities/plate_appearance.dart';
import '../../../games/presentation/view_models/game_view_model.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localGameStoreProvider);
    final batting = _battingStats(state.plateAppearances);
    final pitching = _pitchingStats(state.pitchingAppearances);

    return Scaffold(
      appBar: AppBar(title: const Text('成績')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '打撃成績',
            children: [
              _BattingTile(
                label: '自分側',
                stats: batting[AppConstants.sideHome]!,
              ),
              _BattingTile(
                label: '相手側',
                stats: batting[AppConstants.sideAway]!,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _Section(
            title: 'ピッチング成績',
            children: [
              _PitchingTile(
                label: '自分側',
                stats: pitching[AppConstants.sideHome]!,
              ),
              _PitchingTile(
                label: '相手側',
                stats: pitching[AppConstants.sideAway]!,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, _BattingStats> _battingStats(List<PlateAppearance> appearances) {
    final stats = {
      AppConstants.sideHome: _BattingStats.empty(),
      AppConstants.sideAway: _BattingStats.empty(),
    };
    for (final appearance in appearances) {
      stats[appearance.battingSide] = stats[appearance.battingSide]!.add(
        appearance,
      );
    }
    return stats;
  }

  Map<String, _PitchingStats> _pitchingStats(
    List<PitchingAppearance> appearances,
  ) {
    final stats = {
      AppConstants.sideHome: _PitchingStats.empty(),
      AppConstants.sideAway: _PitchingStats.empty(),
    };
    for (final appearance in appearances) {
      stats[appearance.pitchingSide] = stats[appearance.pitchingSide]!.add(
        appearance,
      );
    }
    return stats;
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

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
        ...children,
      ],
    );
  }
}

class _BattingTile extends StatelessWidget {
  const _BattingTile({required this.label, required this.stats});

  final String label;
  final _BattingStats stats;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: Text(
          '打席 ${stats.pa} / 打数 ${stats.ab} / 安打 ${stats.hits} / 本塁打 ${stats.hr} / 三振 ${stats.so}',
        ),
        trailing: Text(stats.averageLabel),
      ),
    );
  }
}

class _PitchingTile extends StatelessWidget {
  const _PitchingTile({required this.label, required this.stats});

  final String label;
  final _PitchingStats stats;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: Text(
          '登板 ${stats.games} / 投球回 ${stats.inningsLabel} / 自責 ${stats.earnedRuns} / 奪三振 ${stats.strikeouts}',
        ),
        trailing: Text(stats.eraLabel),
      ),
    );
  }
}

class _BattingStats {
  const _BattingStats({
    required this.pa,
    required this.ab,
    required this.hits,
    required this.hr,
    required this.walks,
    required this.so,
  });

  factory _BattingStats.empty() {
    return const _BattingStats(pa: 0, ab: 0, hits: 0, hr: 0, walks: 0, so: 0);
  }

  final int pa;
  final int ab;
  final int hits;
  final int hr;
  final int walks;
  final int so;

  String get averageLabel {
    if (ab == 0) return '.000';
    return (hits / ab).toStringAsFixed(3).replaceFirst('0', '');
  }

  _BattingStats add(PlateAppearance appearance) {
    final isAtBat = {
      AppConstants.resultHit,
      AppConstants.resultOut,
      AppConstants.resultError,
    }.contains(appearance.resultType);
    return _BattingStats(
      pa: pa + 1,
      ab: ab + (isAtBat ? 1 : 0),
      hits: hits + (appearance.resultType == AppConstants.resultHit ? 1 : 0),
      hr: hr + (appearance.resultDetail == AppConstants.detailHr ? 1 : 0),
      walks: walks + (appearance.resultType == AppConstants.resultWalk ? 1 : 0),
      so: so + (appearance.resultDetail == AppConstants.detailK ? 1 : 0),
    );
  }
}

class _PitchingStats {
  const _PitchingStats({
    required this.games,
    required this.outsPitched,
    required this.earnedRuns,
    required this.strikeouts,
  });

  factory _PitchingStats.empty() {
    return const _PitchingStats(
      games: 0,
      outsPitched: 0,
      earnedRuns: 0,
      strikeouts: 0,
    );
  }

  final int games;
  final int outsPitched;
  final int earnedRuns;
  final int strikeouts;

  String get inningsLabel {
    final innings = outsPitched ~/ 3;
    final rest = outsPitched % 3;
    return rest == 0 ? '$innings' : '$innings.$rest';
  }

  String get eraLabel {
    if (outsPitched == 0) return '-.--';
    return (earnedRuns * 27 / outsPitched).toStringAsFixed(2);
  }

  _PitchingStats add(PitchingAppearance appearance) {
    return _PitchingStats(
      games: games + 1,
      outsPitched: outsPitched + appearance.outsPitched,
      earnedRuns: earnedRuns + appearance.earnedRuns,
      strikeouts: strikeouts + appearance.strikeouts,
    );
  }
}
