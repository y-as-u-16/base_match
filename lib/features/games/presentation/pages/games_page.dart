import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/empty_state_widget.dart';
import '../view_models/game_view_model.dart';

class GamesPage extends ConsumerWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesProvider);
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Scaffold(
      appBar: AppBar(title: const Text('記録')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/games/create'),
        icon: const Icon(Icons.add),
        label: const Text('試合を追加'),
      ),
      body: games.isEmpty
          ? EmptyStateWidget(
              icon: Icons.sports_baseball_outlined,
              title: 'まだ試合がありません',
              subtitle: '試合を作成して、打席やピッチング成績を記録します。',
              actionLabel: '試合を作成する',
              onAction: () => context.go('/games/create'),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: games.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final game = games[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.scoreboard_outlined),
                    title: Text('${game.homeTeamName} vs ${game.awayTeamName}'),
                    subtitle: Text(dateFormat.format(game.date)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/games/${game.id}'),
                  ),
                );
              },
            ),
    );
  }
}
