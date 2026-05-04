import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../games/presentation/view_models/game_view_model.dart';
import '../../../games/presentation/view_models/my_team_view_model.dart';
import '../models/season_summary.dart';
import '../widgets/home_hero.dart';
import '../widgets/home_primary_actions.dart';
import '../widgets/home_recent_games_section.dart';
import '../widgets/season_summary_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesProvider);
    final localGameState = ref.watch(localGameStoreProvider);
    final myTeamById = ref.watch(myTeamByIdProvider);
    final l10n = AppLocalizations.of(context);
    final summary = SeasonSummary.fromRecords(
      games: games,
      plateAppearances: localGameState.plateAppearances,
      pitchingAppearances: localGameState.pitchingAppearances,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navHome)),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          HomeHero(summary: summary),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomePrimaryActions(
                  onRecord: () => context.go('/games/create'),
                  onStats: () => context.go('/stats'),
                ),
                const SizedBox(height: 16),
                SeasonSummaryCard(summary: summary),
                const SizedBox(height: 22),
                HomeRecentGamesSection(
                  games: games,
                  myTeamById: myTeamById,
                  onGameTap: (gameId) => context.go('/games/$gameId'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
