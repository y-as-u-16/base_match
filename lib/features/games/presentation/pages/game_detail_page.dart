import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../view_models/game_view_model.dart';

class GameDetailPage extends ConsumerWidget {
  const GameDetailPage({super.key, required this.gameId});

  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameDetailProvider(gameId));
    final plateAppearances = ref.watch(plateAppearancesProvider(gameId));
    final pitchingAppearances = ref.watch(pitchingAppearancesProvider(gameId));
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');

    if (game == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('試合詳細')),
        body: const Center(child: Text('試合が見つかりません')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('試合詳細')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${game.homeTeamName} vs ${game.awayTeamName}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(dateFormat.format(game.date)),
                  if (game.location != null) Text(game.location!),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _ScoreBox(
                        label: game.homeTeamName,
                        score: game.homeScore ?? 0,
                      ),
                      const SizedBox(width: 12),
                      _ScoreBox(
                        label: game.awayTeamName,
                        score: game.awayScore ?? 0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () =>
                      context.go('/games/$gameId/plate-appearances/new'),
                  icon: const Icon(Icons.add),
                  label: const Text('打席'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/games/$gameId/pitching/new'),
                  icon: const Icon(Icons.add_chart),
                  label: const Text('投手'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            '打席記録',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          if (plateAppearances.isEmpty)
            const _EmptyText('まだ打席記録がありません')
          else
            ...plateAppearances.map(
              (appearance) => Card(
                child: ListTile(
                  title: Text(
                    _resultLabel(
                      appearance.resultType,
                      appearance.resultDetail,
                    ),
                  ),
                  subtitle: Text(
                    '${_sideLabel(appearance.battingSide)} / ${appearance.inning ?? '-'}回 / 打点 ${appearance.rbi ?? 0}',
                  ),
                ),
              ),
            ),
          const SizedBox(height: 28),
          Text(
            'ピッチング記録',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          if (pitchingAppearances.isEmpty)
            const _EmptyText('まだピッチング記録がありません')
          else
            ...pitchingAppearances.map(
              (appearance) => Card(
                child: ListTile(
                  title: Text(
                    '${_sideLabel(appearance.pitchingSide)} 投球回 ${_outsLabel(appearance.outsPitched)}',
                  ),
                  subtitle: Text(
                    '失点 ${appearance.runs} / 自責 ${appearance.earnedRuns} / 奪三振 ${appearance.strikeouts}',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static String _sideLabel(String side) =>
      side == AppConstants.sideHome ? '自分側' : '相手側';

  static String _outsLabel(int outs) {
    final innings = outs ~/ 3;
    final rest = outs % 3;
    return rest == 0 ? '$innings回' : '$innings回$rest/3';
  }

  static String _resultLabel(String type, String detail) {
    const typeLabels = {
      AppConstants.resultHit: 'ヒット',
      AppConstants.resultOut: 'アウト',
      AppConstants.resultWalk: '四死球',
      AppConstants.resultError: 'エラー',
    };
    const detailLabels = {
      AppConstants.detailSingle: '単打',
      AppConstants.detailDouble: '二塁打',
      AppConstants.detailTriple: '三塁打',
      AppConstants.detailHr: '本塁打',
      AppConstants.detailK: '三振',
      AppConstants.detailGround: 'ゴロ',
      AppConstants.detailFly: 'フライ',
      AppConstants.detailLine: 'ライナー',
      AppConstants.detailDp: '併殺',
      AppConstants.detailSacBunt: '犠打',
      AppConstants.detailSacFly: '犠飛',
      AppConstants.detailOther: 'その他',
      AppConstants.detailBb: '四球',
      AppConstants.detailHbp: '死球',
      AppConstants.detailE: 'エラー',
    };
    return '${typeLabels[type] ?? type} - ${detailLabels[detail] ?? detail}';
  }
}

class _ScoreBox extends StatelessWidget {
  const _ScoreBox({required this.label, required this.score});

  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(label, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(
              '$score',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  const _EmptyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16), child: Text(text)),
    );
  }
}
