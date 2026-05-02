import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../games/presentation/view_models/game_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.brandName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.homeHeadline,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.homeDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => context.go('/games/create'),
            icon: const Icon(Icons.add),
            label: Text(l10n.recordGameButton),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.go('/stats'),
            icon: const Icon(Icons.bar_chart),
            label: Text(l10n.viewStatsButton),
          ),
          const SizedBox(height: 28),
          Text(
            l10n.recentGamesTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (games.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  l10n.homeEmptyGames,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            )
          else
            ...games
                .take(3)
                .map(
                  (game) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.sports_baseball),
                        title: Text(
                          '${game.homeTeamName} vs ${game.awayTeamName}',
                        ),
                        subtitle: Text(
                          '${game.date.year}/${game.date.month.toString().padLeft(2, '0')}/${game.date.day.toString().padLeft(2, '0')}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.go('/games/${game.id}'),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
