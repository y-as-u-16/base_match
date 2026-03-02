import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/view_models/auth_view_model.dart';
import '../../../games/domain/entities/game.dart';
import '../../../teams/domain/entities/team.dart';
import '../view_models/home_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('base_match'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onFabPressed(context, ref),
        backgroundColor: AppTheme.stitchRed,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.sports_baseball),
        label: const Text('試合を記録'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myTeamsForHomeProvider);
          ref.invalidate(recentGamesProvider);
          ref.invalidate(matchupHighlightsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // スコアボード風ウェルカムヘッダー
            _ScoreboardHeader(
              userName: user?.displayName,
            ),
            const SizedBox(height: 24),

            // 因縁ハイライト
            const _MatchupHighlightsSection(),
            const SizedBox(height: 24),

            // クイックアクション
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.local_fire_department,
                    label: '因縁を見る',
                    color: AppTheme.stitchRed,
                    onTap: () => context.go('/matchups'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.groups,
                    label: 'チーム作成',
                    color: AppTheme.leatherBrown,
                    onTap: () => context.go('/teams/create'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 自分のチーム
            const _SectionHeader(
              title: '自分のチーム',
              icon: Icons.groups_outlined,
            ),
            const SizedBox(height: 8),
            const _MyTeamsSection(),
            const SizedBox(height: 24),

            // 直近の試合
            const _SectionHeader(
              title: '直近の試合',
              icon: Icons.sports_baseball_outlined,
            ),
            const SizedBox(height: 8),
            const _RecentGamesSection(),
            // FAB用の余白
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _onFabPressed(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.read(myTeamsForHomeProvider);
    final teams = teamsAsync.valueOrNull ?? [];

    if (teams.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('まずチームを作成してください')),
      );
      return;
    }

    if (teams.length == 1) {
      context.go('/games/create?teamId=${teams.first.id}');
      return;
    }

    // 複数チームの場合はダイアログで選択
    showDialog(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: const Text('チームを選択'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: teams
                .map(
                  (team) => ListTile(
                    leading: Icon(Icons.groups,
                        color: theme.colorScheme.primary),
                    title: Text(team.name),
                    onTap: () {
                      Navigator.pop(dialogContext);
                      context.go('/games/create?teamId=${team.id}');
                    },
                  ),
                )
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('キャンセル'),
            ),
          ],
        );
      },
    );
  }
}

// ダイヤモンド模様を描画するCustomPainter
class _DiamondPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const spacing = 40.0;
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        final path = Path()
          ..moveTo(x, y - spacing / 2)
          ..lineTo(x + spacing / 2, y)
          ..lineTo(x, y + spacing / 2)
          ..lineTo(x - spacing / 2, y)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DiamondPatternPainter oldDelegate) => false;
}

// スコアボード風ウェルカムヘッダー
class _ScoreboardHeader extends StatelessWidget {
  const _ScoreboardHeader({this.userName});

  final String? userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.fieldGreen,
            Color(0xFF0D2818),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.fieldGreen.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ダイヤモンド模様オーバーレイ
          Positioned.fill(
            child: CustomPaint(
              painter: _DiamondPatternPainter(),
            ),
          ),
          // 右側のゴールド装飾アクセント
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.trophyGold.withValues(alpha: 0.15),
                    AppTheme.trophyGold.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: Icon(
              Icons.sports_baseball,
              size: 48,
              color: AppTheme.trophyGold.withValues(alpha: 0.15),
            ),
          ),
          // メインコンテンツ
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.sports_baseball,
                      size: 20,
                      color: AppTheme.baseWhite.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ようこそ${userName != null ? "、$userNameさん" : ""}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // 縫い目パターンの装飾ライン
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 2,
                      color: AppTheme.stitchRed.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 8,
                      height: 2,
                      color: AppTheme.stitchRed.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 4,
                      height: 2,
                      color: AppTheme.stitchRed.withValues(alpha: 0.3),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'あいつとの因縁、忘れてないか?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchupHighlightsSection extends ConsumerWidget {
  const _MatchupHighlightsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highlightsAsync = ref.watch(matchupHighlightsProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          title: '注目の因縁',
          icon: Icons.local_fire_department,
        ),
        const SizedBox(height: 8),
        highlightsAsync.when(
          loading: () => const SizedBox(
            height: 180,
            child: LoadingWidget(),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (highlights) {
            if (highlights.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: 32,
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.4),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'まだ宿敵はいない。試合を記録して因縁を刻もう。',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: highlights.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final h = highlights[index];
                  return _MatchupHighlightCard(highlight: h);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

// 野球トレーディングカード風の因縁ハイライトカード
class _MatchupHighlightCard extends StatelessWidget {
  const _MatchupHighlightCard({required this.highlight});

  final MatchupHighlight highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avgText = highlight.avg != null
        ? '.${(highlight.avg! * 1000).round().toString().padLeft(3, '0')}'
        : '---';

    return GestureDetector(
      onTap: () => context.go(
        '/matchups/player/${highlight.batterId}/${highlight.pitcherId}',
      ),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A3A2A),
              Color(0xFF0D2818),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.trophyGold.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // バッター名 VS ピッチャー名
            Text(
              highlight.batterName,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              'VS',
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppTheme.stitchRed,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              highlight.pitcherName,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            // 打率（大きく中央に）
            Text(
              avgText,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            Text(
              '通算打率',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            const Spacer(),
            // 対戦数（下部コンパクト）
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${highlight.ab}打数 ${highlight.hits}安打',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        // 左の太い縦線
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color: AppTheme.stitchRed,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Icon(icon, size: 22, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyTeamsSection extends ConsumerWidget {
  const _MyTeamsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(myTeamsForHomeProvider);

    return teams.when(
      loading: () => const SizedBox(
        height: 80,
        child: LoadingWidget(),
      ),
      error: (error, _) => AppErrorWidget(
        message: 'チームの読み込みに失敗しました',
        onRetry: () => ref.invalidate(myTeamsForHomeProvider),
      ),
      data: (list) {
        if (list.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: EmptyStateWidget(
                icon: Icons.groups_outlined,
                title: 'まずはチームを作ろう。因縁はそこから始まる。',
                subtitle: 'チームを作成するか、招待コードで参加しましょう',
                actionLabel: 'チームを作成する',
                onAction: () => context.go('/teams/create'),
              ),
            ),
          );
        }
        return Column(
          children: list
              .map((team) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _TeamCard(team: team),
                  ))
              .toList(),
        );
      },
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({required this.team});
  final Team team;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.fieldGreen.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.checkroom,
            color: AppTheme.fieldGreen,
            size: 22,
          ),
        ),
        title: Text(
          team.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        subtitle: team.area != null
            ? Text(
                team.area!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        onTap: () => context.go('/teams/${team.id}'),
      ),
    );
  }
}

class _RecentGamesSection extends ConsumerWidget {
  const _RecentGamesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(recentGamesProvider);

    return games.when(
      loading: () => const SizedBox(
        height: 80,
        child: LoadingWidget(),
      ),
      error: (error, _) => AppErrorWidget(
        message: '試合の読み込みに失敗しました',
        onRetry: () => ref.invalidate(recentGamesProvider),
      ),
      data: (list) {
        if (list.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: EmptyStateWidget(
                icon: Icons.sports_baseball_outlined,
                title: 'まだ因縁は生まれていない。最初の一戦を記録しよう。',
                subtitle: 'チーム詳細画面から試合を追加できます',
              ),
            ),
          );
        }
        return Column(
          children: list
              .map((game) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _GameCard(game: game),
                  ))
              .toList(),
        );
      },
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game});
  final Game game;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');
    final hasScore = game.homeScore != null && game.awayScore != null;
    final isDraft = game.status == 'draft';

    return Card(
      child: InkWell(
        onTap: () => context.go('/games/${game.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 日付表示
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.sports_baseball,
                  color: AppTheme.fieldGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              // 日付とステータス
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateFormat.format(game.date),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isDraft)
                      Text(
                        '下書き',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              // スコア表示（大きめ）
              if (hasScore)
                Row(
                  children: [
                    Text(
                      '${game.homeScore}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        '-',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${game.awayScore}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              if (!hasScore && !isDraft)
                Text(
                  game.status,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
