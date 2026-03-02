import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/plate_appearance.dart';
import '../view_models/game_view_model.dart';

class GameDetailPage extends ConsumerWidget {
  const GameDetailPage({super.key, required this.gameId});

  final String gameId;

  String _resultLabel(String type, String detail) {
    const typeLabels = {
      'hit': 'ヒット',
      'out': 'アウト',
      'walk': '四死球',
      'error': 'エラー',
    };
    const detailLabels = {
      'single': '単打',
      'double': '二塁打',
      'triple': '三塁打',
      'hr': '本塁打',
      'k': '三振',
      'ground': 'ゴロ',
      'fly': 'フライ',
      'line': 'ライナー',
      'dp': '併殺',
      'sac_bunt': '犠打',
      'sac_fly': '犠飛',
      'other': 'その他',
      'bb': '四球',
      'hbp': '死球',
      'e': 'エラー',
    };
    return '${typeLabels[type] ?? type} - ${detailLabels[detail] ?? detail}';
  }

  String _resultShortLabel(String detail) {
    const labels = {
      'single': '単打',
      'double': '二塁打',
      'triple': '三塁打',
      'hr': '本塁打',
      'k': '三振',
      'ground': 'ゴロ',
      'fly': 'フライ',
      'line': 'ライナー',
      'dp': '併殺',
      'sac_bunt': '犠打',
      'sac_fly': '犠飛',
      'other': 'その他',
      'bb': '四球',
      'hbp': '死球',
      'e': 'エラー',
    };
    return labels[detail] ?? detail;
  }

  Color _resultColor(String type, ThemeData theme) {
    switch (type) {
      case 'hit':
        return theme.colorScheme.primary;
      case 'out':
        return theme.colorScheme.error;
      case 'walk':
        return theme.colorScheme.tertiary;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  /// Group plate appearances by inning for display.
  Map<int, List<PlateAppearance>> _groupByInning(List<PlateAppearance> pas) {
    final grouped = <int, List<PlateAppearance>>{};
    for (final pa in pas) {
      final inning = pa.inning ?? 0;
      grouped.putIfAbsent(inning, () => []);
      grouped[inning]!.add(pa);
    }
    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(gameDetailProvider(gameId));
    final pasAsync = ref.watch(plateAppearancesProvider(gameId));
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Scaffold(
      appBar: AppBar(title: const Text('試合詳細')),
      body: gameAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text('エラー: $e')),
        data: (game) => Column(
          children: [
            // Game info header with gradient
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            dateFormat.format(game.date),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (game.gameNumber != null) ...[
                            const Gap(8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '第${game.gameNumber}試合',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Row(
                        children: [
                          if (game.innings != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${game.innings}回制',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: game.status == AppConstants.statusFinal
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.amber.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              game.status == AppConstants.statusFinal
                                  ? '確定'
                                  : '下書き',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (game.location != null) ...[
                    const Gap(6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        const Gap(4),
                        Text(
                          game.location!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (game.status == AppConstants.statusFinal) ...[
                    const Gap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              'HOME',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                                letterSpacing: 1,
                              ),
                            ),
                            const Gap(2),
                            Text(
                              '${game.homeScore}',
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            '-',
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              'AWAY',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                                letterSpacing: 1,
                              ),
                            ),
                            const Gap(2),
                            Text(
                              '${game.awayScore}',
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Plate appearances list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.list_alt, size: 20,
                          color: theme.colorScheme.onSurfaceVariant),
                      const Gap(8),
                      Text(
                        '打席結果',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (game.status == AppConstants.statusDraft)
                    TextButton.icon(
                      onPressed: () =>
                          context.go('/games/$gameId/plate-appearance'),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('打席を追加'),
                    ),
                ],
              ),
            ),
            const Gap(8),

            Expanded(
              child: pasAsync.when(
                loading: () => const LoadingWidget(),
                error: (e, _) => Center(child: Text('エラー: $e')),
                data: (pas) {
                  if (pas.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.sports_baseball_outlined,
                      title: 'まだ打席結果がありません',
                      subtitle: '打席を追加してデータを記録しましょう',
                    );
                  }

                  // Check if any PA has inning data
                  final hasInnings = pas.any((pa) => pa.inning != null);

                  if (hasInnings) {
                    return _InningGroupedList(
                      pas: pas,
                      groupByInning: _groupByInning,
                      resultShortLabel: _resultShortLabel,
                      resultColor: _resultColor,
                    );
                  }

                  // Fallback: flat list
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: pas.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final pa = pas[index];
                      final color = _resultColor(pa.resultType, theme);
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              pa.inning?.toString() ?? '-',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          _resultLabel(pa.resultType, pa.resultDetail),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: pa.rbi != null && pa.rbi! > 0
                            ? Text('${pa.rbi}打点')
                            : null,
                      );
                    },
                  );
                },
              ),
            ),

            // Finalize button
            if (game.status == AppConstants.statusDraft)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('因縁を確定する'),
                          content: const Text(
                            'この試合の因縁を確定する。覚悟はいいか?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, false),
                              child: const Text('まだ早い'),
                            ),
                            FilledButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, true),
                              child: const Text('確定する'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await ref
                            .read(gameViewModelProvider.notifier)
                            .finalizeGame(gameId);
                        ref.invalidate(gameDetailProvider(gameId));
                        ref.invalidate(plateAppearancesProvider(gameId));

                        if (context.mounted) {
                          _showMatchupBottomSheet(context, ref, gameId);
                        }
                      }
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('試合を確定する'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showMatchupBottomSheet(
      BuildContext context, WidgetRef ref, String gameId) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, _) {
            final matchupAsync = ref.watch(gameTopMatchupProvider(gameId));

            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: matchupAsync.when(
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SizedBox(
                  height: 120,
                  child: Center(child: Text('データの取得に失敗しました')),
                ),
                data: (matchup) {
                  if (matchup == null) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const Gap(24),
                        Icon(
                          Icons.sports_baseball,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                        const Gap(12),
                        Text(
                          '試合が確定されました',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(24),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            child: const Text('閉じる'),
                          ),
                        ),
                      ],
                    );
                  }

                  final avgText = matchup.avg != null
                      ? '.${(matchup.avg! * 1000).round().toString().padLeft(3, '0')}'
                      : '---';

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const Gap(20),
                      Icon(
                        Icons.local_fire_department,
                        size: 40,
                        color: theme.colorScheme.error,
                      ),
                      const Gap(8),
                      Text(
                        '注目の因縁',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Gap(16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.primaryContainer,
                              theme.colorScheme.secondaryContainer,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${matchup.batterName} vs ${matchup.pitcherName}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Gap(12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _StatColumn(
                                  label: '通算打率',
                                  value: avgText,
                                  theme: theme,
                                ),
                                _StatColumn(
                                  label: '打数',
                                  value: '${matchup.ab}',
                                  theme: theme,
                                ),
                                _StatColumn(
                                  label: '安打',
                                  value: '${matchup.hits}',
                                  theme: theme,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.pop(sheetContext);
                            context.go(
                              '/matchups/player/${matchup.batterId}/${matchup.pitcherId}/card',
                            );
                          },
                          icon: const Icon(Icons.style),
                          label: const Text('因縁カードを作成'),
                        ),
                      ),
                      const Gap(8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          child: const Text('閉じる'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

/// Displays plate appearances grouped by inning.
class _InningGroupedList extends StatelessWidget {
  const _InningGroupedList({
    required this.pas,
    required this.groupByInning,
    required this.resultShortLabel,
    required this.resultColor,
  });

  final List<PlateAppearance> pas;
  final Map<int, List<PlateAppearance>> Function(List<PlateAppearance>)
      groupByInning;
  final String Function(String) resultShortLabel;
  final Color Function(String, ThemeData) resultColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grouped = groupByInning(pas);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final entry = grouped.entries.elementAt(index);
        final inning = entry.key;
        final inningPas = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const Divider(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                inning == 0 ? 'イニング未指定' : '$inning回',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const Gap(8),
            ...inningPas.map((pa) {
              final color = resultColor(pa.resultType, theme);
              return Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Text(
                        resultShortLabel(pa.resultDetail),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                    if (pa.rbi != null && pa.rbi! > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${pa.rbi}打点',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.label,
    required this.value,
    required this.theme,
  });

  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const Gap(2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
