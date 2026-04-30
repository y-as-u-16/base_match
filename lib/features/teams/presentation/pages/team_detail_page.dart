import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../games/presentation/view_models/game_view_model.dart';
import '../view_models/team_view_model.dart';
import '../../../auth/presentation/view_models/auth_view_model.dart';

class TeamDetailPage extends ConsumerWidget {
  const TeamDetailPage({super.key, required this.teamId});

  final String teamId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAsync = ref.watch(teamDetailProvider(teamId));
    final membersAsync = ref.watch(teamMembersProvider(teamId));
    final gamesAsync = ref.watch(gamesByTeamProvider(teamId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('チーム詳細')),
      body: teamAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => AppErrorWidget(
          message: 'チーム情報の読み込みに失敗しました',
          onRetry: () => ref.invalidate(teamDetailProvider(teamId)),
        ),
        data: (team) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Team info header
              Container(
                width: double.infinity,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.groups,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                team.name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (team.area != null)
                                Text(
                                  team.area!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    Divider(color: Colors.white.withValues(alpha: 0.2)),
                    const Gap(8),
                    Text(
                      '招待コード',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const Gap(4),
                    Row(
                      children: [
                        Text(
                          team.inviteCode,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                          ),
                        ),
                        const Gap(8),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20,
                              color: Colors.white70),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: team.inviteCode),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('招待コードをコピーしました'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(16),
              // Regenerate invite code button (owner/admin only)
          
              membersAsync.maybeWhen(
                data: (members) {
                  final currentUserRole = members
                      .where((m) => m.userId == ref.watch(currentUserProvider)?.id)
                      .map((m) => m.role)
                      .firstWhere((_) => true, orElse: () => '');
                  if (currentUserRole == 'owner' || currentUserRole == 'admin') {
                    return OutlinedButton.icon(
                      onPressed: () => context.go('/teams/invite-code'),
                      icon: const Icon(Icons.refresh),
                      label: const Text('招待コードを再発行'),
                    );
                  }
                  return const SizedBox.shrink();
                },
                orElse: () => const SizedBox.shrink(),
              ),
              const Gap(24),

              // Members section
              Row(
                children: [
                  Icon(Icons.people_outline, size: 20,
                      color: theme.colorScheme.onSurfaceVariant),
                  const Gap(8),
                  Text(
                    'メンバー',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Gap(8),
              membersAsync.when(
                loading: () => const SizedBox(
                  height: 60,
                  child: LoadingWidget(),
                ),
                error: (e, _) => AppErrorWidget(
                  message: 'メンバーの読み込みに失敗しました',
                  onRetry: () =>
                      ref.invalidate(teamMembersProvider(teamId)),
                ),
                data: (members) => Card(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: members.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        title: Text(
                          member.displayName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: member.role == AppConstants.roleOwner
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'オーナー',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color:
                                        theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : null,
                      );
                    },
                  ),
                ),
              ),
              const Gap(24),

              // Games section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.sports_baseball_outlined, size: 20,
                          color: theme.colorScheme.onSurfaceVariant),
                      const Gap(8),
                      Text(
                        '試合一覧',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () =>
                        context.go('/games/create?teamId=$teamId'),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('試合を追加'),
                  ),
                ],
              ),
              const Gap(8),
              gamesAsync.when(
                loading: () => const SizedBox(
                  height: 60,
                  child: LoadingWidget(),
                ),
                error: (e, _) => AppErrorWidget(
                  message: '試合の読み込みに失敗しました',
                  onRetry: () =>
                      ref.invalidate(gamesByTeamProvider(teamId)),
                ),
                data: (games) => games.isEmpty
                    ? const Card(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: EmptyStateWidget(
                            icon: Icons.sports_baseball_outlined,
                            title: 'まだ試合がありません',
                          ),
                        ),
                      )
                    : Card(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: games.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final game = games[index];
                            final dateStr =
                                '${game.date.year}/${game.date.month}/${game.date.day}';
                            final statusLabel =
                                game.status == AppConstants.statusFinal
                                    ? '確定'
                                    : '下書き';
                            final scoreText =
                                game.status == AppConstants.statusFinal
                                    ? '${game.homeScore} - ${game.awayScore}'
                                    : statusLabel;

                            return ListTile(
                              title: Text(
                                dateStr,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: game.location != null
                                  ? Text(game.location!)
                                  : null,
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: game.status ==
                                          AppConstants.statusFinal
                                      ? theme.colorScheme.primaryContainer
                                      : theme
                                          .colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  scoreText,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              onTap: () =>
                                  context.go('/games/${game.id}'),
                            );
                          },
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
