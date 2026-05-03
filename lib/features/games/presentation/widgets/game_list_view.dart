import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/my_team.dart';
import 'game_record_card.dart';

class GameListView extends StatelessWidget {
  const GameListView({
    super.key,
    required this.games,
    required this.myTeamById,
  });

  final List<Game> games;
  final Map<String, MyTeam> myTeamById;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd');
    final l10n = AppLocalizations.of(context);

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      itemCount: games.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final game = games[index];
        return GameRecordCard(
          title:
              '${myTeamById[game.myTeamId]?.name ?? l10n.unknownMyTeamLabel} vs ${game.awayTeamName}',
          date: dateFormat.format(game.date),
          location: game.location,
          homeScore: game.homeScore ?? 0,
          awayScore: game.awayScore ?? 0,
          onTap: () => context.go('/games/${game.id}'),
        );
      },
    );
  }
}
