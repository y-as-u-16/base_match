import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../view_models/game_view_model.dart';
import '../view_models/my_team_view_model.dart';
import '../widgets/game_calendar_placeholder.dart';
import '../widgets/game_list_view.dart';
import '../widgets/games_view_mode_selector.dart';
import '../widgets/record_empty_state.dart';

class GamesPage extends ConsumerStatefulWidget {
  const GamesPage({super.key});

  @override
  ConsumerState<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends ConsumerState<GamesPage> {
  GamesViewMode _viewMode = GamesViewMode.list;

  @override
  Widget build(BuildContext context) {
    final games = ref.watch(gamesProvider);
    final myTeamById = ref.watch(myTeamByIdProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recordTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/games/create'),
        icon: const Icon(Icons.add),
        label: Text(l10n.addGameButton),
      ),
      body: games.isEmpty
          ? RecordEmptyState(onCreate: () => context.go('/games/create'))
          : Column(
              children: [
                GamesViewModeSelector(
                  viewMode: _viewMode,
                  onChanged: (viewMode) {
                    setState(() {
                      _viewMode = viewMode;
                    });
                  },
                ),
                Expanded(
                  child: switch (_viewMode) {
                    GamesViewMode.list => GameListView(
                      games: games,
                      myTeamById: myTeamById,
                    ),
                    GamesViewMode.calendar => const GameCalendarPlaceholder(),
                  },
                ),
              ],
            ),
    );
  }
}
