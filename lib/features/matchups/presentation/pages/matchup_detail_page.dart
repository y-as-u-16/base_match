import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/batter_pitcher_matchup.dart';
import '../../domain/entities/team_matchup.dart';
import '../view_models/matchup_view_model.dart';

class MatchupDetailPage extends ConsumerWidget {
  const MatchupDetailPage({
    super.key,
    required this.matchupType,
    required this.id1,
    required this.id2,
  });

  final String matchupType;
  final String id1;
  final String id2;

  bool get isBatterPitcher => matchupType == 'batter_pitcher';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isBatterPitcher) {
      return _buildBatterPitcherDetail(context, ref);
    } else {
      return _buildTeamDetail(context, ref);
    }
  }

  Widget _buildBatterPitcherDetail(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(
      batterPitcherDetailProvider((batterId: id1, pitcherId: id2)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('個人因縁')),
      body: detail.when(
        loading: () => const LoadingWidget(),
        error: (error, _) => AppErrorWidget(
          message: 'データの読み込みに失敗しました',
          onRetry: () => ref.invalidate(
            batterPitcherDetailProvider((batterId: id1, pitcherId: id2)),
          ),
        ),
        data: (matchup) => _BatterPitcherDetailBody(
          matchup: matchup,
          onGenerateCard: () {
            context.go(
              '/matchups/$matchupType/$id1/$id2/card',
            );
          },
        ),
      ),
    );
  }

  Widget _buildTeamDetail(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(
      teamMatchupDetailProvider((teamAId: id1, teamBId: id2)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('チーム因縁')),
      body: detail.when(
        loading: () => const LoadingWidget(),
        error: (error, _) => AppErrorWidget(
          message: 'データの読み込みに失敗しました',
          onRetry: () => ref.invalidate(
            teamMatchupDetailProvider((teamAId: id1, teamBId: id2)),
          ),
        ),
        data: (matchup) => _TeamDetailBody(
          matchup: matchup,
          onGenerateCard: () {
            context.go(
              '/matchups/$matchupType/$id1/$id2/card',
            );
          },
        ),
      ),
    );
  }
}

class _BatterPitcherDetailBody extends StatelessWidget {
  const _BatterPitcherDetailBody({
    required this.matchup,
    required this.onGenerateCard,
  });
  final BatterPitcherMatchup matchup;
  final VoidCallback onGenerateCard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 球場風ヘッダー
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D3B0E),
                  AppTheme.fieldGreen,
                  Color(0xFF2E7D32),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.fieldGreen.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '宿敵対決',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.trophyGold.withValues(alpha: 0.8),
                    letterSpacing: 4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'BATTER',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            matchup.batterName,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // VS バッジ
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppTheme.stitchRed,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.stitchRed.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'VS',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'PITCHER',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            matchup.pitcherName,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // ダイヤモンド装飾ライン
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 1,
                      color: AppTheme.trophyGold.withValues(alpha: 0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Transform.rotate(
                        angle: 0.785, // 45度
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  AppTheme.trophyGold.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 1,
                      color: AppTheme.trophyGold.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 成績カード（野球カード風）
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // ゴールドのトップライン
                Container(
                  height: 3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFFD54F),
                        AppTheme.trophyGold,
                        Color(0xFFFF8F00),
                        AppTheme.trophyGold,
                        Color(0xFFFFD54F),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 打率を大きく表示
                      Center(
                        child: Column(
                          children: [
                            Text(
                              '打率',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              matchup.avg.toStringAsFixed(3),
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: _avgColor(matchup.avg),
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(
                        color: AppTheme.trophyGold.withValues(alpha: 0.2),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.bar_chart,
                            size: 20,
                            color: AppTheme.fieldGreen,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '通算成績',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _StatRow(
                        icon: Icons.sports_baseball,
                        label: '打数',
                        value: '${matchup.ab}',
                      ),
                      _StatRow(
                        icon: Icons.sports_baseball_outlined,
                        label: '安打',
                        value: '${matchup.hits}',
                      ),
                      _StatRow(
                        icon: Icons.whatshot,
                        label: '本塁打',
                        value: '${matchup.hr}',
                        highlight: matchup.hr >= 1,
                      ),
                      _StatRow(
                        icon: Icons.directions_walk,
                        label: '四死球',
                        value: '${matchup.bbHbp}',
                      ),
                      _StatRow(
                        icon: Icons.air,
                        label: '三振',
                        value: '${matchup.so}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 因縁カード生成ボタン
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onGenerateCard,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('因縁カードを生成'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.stitchRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _avgColor(double avg) {
    if (avg >= 0.300) return AppTheme.stitchRed;
    if (avg >= 0.200) return AppTheme.trophyGold;
    return AppTheme.fieldGreen;
  }
}

class _TeamDetailBody extends StatelessWidget {
  const _TeamDetailBody({
    required this.matchup,
    required this.onGenerateCard,
  });
  final TeamMatchup matchup;
  final VoidCallback onGenerateCard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 球場風ヘッダー
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A2647),
                  Color(0xFF0D47A1),
                  Color(0xFF1565C0),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0D47A1).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '因縁の対決',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.trophyGold.withValues(alpha: 0.8),
                    letterSpacing: 4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        matchup.teamAName,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // VS バッジ
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppTheme.stitchRed,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.stitchRed.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'VS',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        matchup.teamBName,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // ダイヤモンド装飾ライン
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 1,
                      color: AppTheme.trophyGold.withValues(alpha: 0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Transform.rotate(
                        angle: 0.785,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  AppTheme.trophyGold.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 1,
                      color: AppTheme.trophyGold.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 成績カード（野球カード風）
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // ゴールドのトップライン
                Container(
                  height: 3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFFD54F),
                        AppTheme.trophyGold,
                        Color(0xFFFF8F00),
                        AppTheme.trophyGold,
                        Color(0xFFFFD54F),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 勝率を大きく表示
                      Center(
                        child: Column(
                          children: [
                            Text(
                              '勝率',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              matchup.winRateA.toStringAsFixed(3),
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: _winRateColor(matchup.winRateA),
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(
                        color: AppTheme.trophyGold.withValues(alpha: 0.2),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.bar_chart,
                            size: 20,
                            color: AppTheme.fieldGreen,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '通算成績',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _StatRow(
                        icon: Icons.event,
                        label: '対戦数',
                        value: '${matchup.games}試合',
                      ),
                      _StatRow(
                        icon: Icons.emoji_events,
                        label: '戦績',
                        value:
                            '${matchup.winsA}勝${matchup.winsB}敗${matchup.draws}分',
                        highlight: matchup.winRateA >= 0.600,
                      ),
                      _StatRow(
                        icon: Icons.trending_up,
                        label: '勝率',
                        value: matchup.winRateA.toStringAsFixed(3),
                      ),
                      _StatRow(
                        icon: Icons.sports_score,
                        label: '得点',
                        value: '${matchup.runsA}',
                      ),
                      _StatRow(
                        icon: Icons.shield_outlined,
                        label: '失点',
                        value: '${matchup.runsB}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 因縁カード生成ボタン
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onGenerateCard,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('因縁カードを生成'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.stitchRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _winRateColor(double winRate) {
    if (winRate >= 0.600) return AppTheme.stitchRed;
    if (winRate >= 0.400) return AppTheme.trophyGold;
    return AppTheme.fieldGreen;
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: highlight
                ? AppTheme.stitchRed
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: highlight ? AppTheme.stitchRed : null,
            ),
          ),
        ],
      ),
    );
  }
}
