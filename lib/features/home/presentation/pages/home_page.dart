import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../games/presentation/view_models/game_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('base_match')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'ローカル記録',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ログインなしで試合、打席、ピッチング成績を端末内に記録します。',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => context.go('/games/create'),
            icon: const Icon(Icons.add),
            label: const Text('試合を記録する'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.go('/stats'),
            icon: const Icon(Icons.bar_chart),
            label: const Text('成績を見る'),
          ),
          const SizedBox(height: 28),
          Text(
            '直近の試合',
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
                  'まだ試合がありません。最初の試合を記録してください。',
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
