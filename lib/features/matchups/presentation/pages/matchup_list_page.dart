import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/batter_pitcher_matchup.dart';
import '../../domain/entities/team_matchup.dart';
import '../view_models/matchup_view_model.dart';

class MatchupListPage extends ConsumerWidget {
  const MatchupListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('因縁一覧'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.sports_baseball, size: 18),
                text: '個人因縁',
              ),
              Tab(
                icon: Icon(Icons.groups, size: 18),
                text: 'チーム因縁',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BatterPitcherTab(),
            _TeamTab(),
          ],
        ),
      ),
    );
  }
}

class _BatterPitcherTab extends ConsumerWidget {
  const _BatterPitcherTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchups = ref.watch(batterPitcherMatchupsProvider);

    return matchups.when(
      loading: () => const LoadingWidget(),
      error: (error, _) => AppErrorWidget(
        message: '対戦成績の読み込みに失敗しました',
        onRetry: () => ref.invalidate(batterPitcherMatchupsProvider),
      ),
      data: (list) {
        if (list.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.sports_baseball_outlined,
            title: 'まだ宿敵はいない。試合を記録して因縁を刻もう。',
            subtitle: '試合を登録すると、自動的に対戦成績が集計されます',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) =>
              _BatterPitcherTile(matchup: list[index]),
        );
      },
    );
  }
}

class _BatterPitcherTile extends StatelessWidget {
  const _BatterPitcherTile({required this.matchup});
  final BatterPitcherMatchup matchup;

  /// 打率に応じたインジケーターの色を返す
  Color _indicatorColor() {
    if (matchup.avg >= 0.300) return AppTheme.stitchRed;
    if (matchup.avg >= 0.200) return AppTheme.trophyGold;
    return AppTheme.fieldGreen;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            context.go(
              '/matchups/batter_pitcher/${matchup.batterPlayerId}/${matchup.pitcherPlayerId}',
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              // 打率インジケーターバー
              Container(
                width: 5,
                height: 80,
                color: _indicatorColor(),
              ),
              const SizedBox(width: 12),
              // 野球ボール風アイコン
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.baseWhite,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.stitchRed.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.sports_baseball,
                  color: AppTheme.stitchRed,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              matchup.batterName,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.stitchRed.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'VS',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppTheme.stitchRed,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              matchup.pitcherName,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _StatChip(
                            label: '打率',
                            value: matchup.avg.toStringAsFixed(3),
                            theme: theme,
                            highlight: matchup.avg >= 0.300,
                          ),
                          const SizedBox(width: 8),
                          _StatChip(
                            label: '安打',
                            value: '${matchup.hits}/${matchup.ab}',
                            theme: theme,
                          ),
                          const SizedBox(width: 8),
                          _StatChip(
                            label: 'HR',
                            value: '${matchup.hr}',
                            theme: theme,
                            highlight: matchup.hr >= 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // シェアボタン
              IconButton(
                onPressed: () {
                  context.go(
                    '/matchups/batter_pitcher/${matchup.batterPlayerId}/${matchup.pitcherPlayerId}/card',
                  );
                },
                icon: Icon(
                  Icons.share_outlined,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                tooltip: '因縁カードを共有',
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.theme,
    this.highlight = false,
  });

  final String label;
  final String value;
  final ThemeData theme;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: highlight
            ? AppTheme.stitchRed.withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
        border: highlight
            ? Border.all(
                color: AppTheme.stitchRed.withValues(alpha: 0.3), width: 1)
            : null,
      ),
      child: Text(
        '$label $value',
        style: theme.textTheme.labelSmall?.copyWith(
          color: highlight
              ? AppTheme.stitchRed
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _TeamTab extends ConsumerWidget {
  const _TeamTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchups = ref.watch(teamMatchupsProvider);

    return matchups.when(
      loading: () => const LoadingWidget(),
      error: (error, _) => AppErrorWidget(
        message: 'チーム対戦成績の読み込みに失敗しました',
        onRetry: () => ref.invalidate(teamMatchupsProvider),
      ),
      data: (list) {
        if (list.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.groups_outlined,
            title: 'まだ宿敵はいない。試合を記録して因縁を刻もう。',
            subtitle: '試合を登録すると、自動的に対戦成績が集計されます',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) => _TeamTile(matchup: list[index]),
        );
      },
    );
  }
}

class _TeamTile extends StatelessWidget {
  const _TeamTile({required this.matchup});
  final TeamMatchup matchup;

  /// 勝率に応じたインジケーターの色を返す
  Color _indicatorColor() {
    final winRate = matchup.winRateA;
    if (winRate >= 0.600) return AppTheme.stitchRed;
    if (winRate >= 0.400) return AppTheme.trophyGold;
    return AppTheme.fieldGreen;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            context.go(
              '/matchups/team/${matchup.teamAId}/${matchup.teamBId}',
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              // 勝率インジケーターバー
              Container(
                width: 5,
                height: 80,
                color: _indicatorColor(),
              ),
              const SizedBox(width: 12),
              // チームアイコン（野球ボール風）
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.baseWhite,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.fieldGreen.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.groups,
                  color: AppTheme.fieldGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              matchup.teamAName,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.stitchRed.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'VS',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppTheme.stitchRed,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              matchup.teamBName,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _StatChip(
                            label: '',
                            value: '${matchup.games}試合',
                            theme: theme,
                          ),
                          const SizedBox(width: 8),
                          _StatChip(
                            label: '',
                            value:
                                '${matchup.winsA}勝${matchup.winsB}敗${matchup.draws}分',
                            theme: theme,
                            highlight: matchup.winRateA >= 0.600,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // シェアボタン
              IconButton(
                onPressed: () {
                  context.go(
                    '/matchups/team/${matchup.teamAId}/${matchup.teamBId}/card',
                  );
                },
                icon: Icon(
                  Icons.share_outlined,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                tooltip: '因縁カードを共有',
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
