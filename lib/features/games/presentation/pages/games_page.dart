import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../view_models/game_view_model.dart';

class GamesPage extends ConsumerWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesProvider);
    final dateFormat = DateFormat('yyyy/MM/dd');
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recordTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/games/create'),
        icon: const Icon(Icons.add),
        label: Text(l10n.addGameButton),
      ),
      body: games.isEmpty
          ? EmptyStateWidget(
              icon: Icons.sports_baseball_outlined,
              title: l10n.emptyGamesTitle,
              subtitle: l10n.emptyGamesSubtitle,
              actionLabel: l10n.createGameButton,
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
