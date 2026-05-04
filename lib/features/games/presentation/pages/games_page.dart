import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../view_models/game_view_model.dart';
import '../view_models/my_team_view_model.dart';
import '../widgets/game_calendar_view.dart';
import '../widgets/game_list_view.dart';
import '../widgets/games_view_mode_selector.dart';
import '../widgets/record_empty_state.dart';
import '../widgets/record_page_header.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l10n.recordTitle),
        centerTitle: false,
        backgroundColor: colorScheme.surfaceContainerLowest,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/games/create'),
        icon: const Icon(Icons.add),
        label: Text(l10n.addGameButton),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      body: ColoredBox(
        color: colorScheme.surfaceContainerLowest,
        child: SafeArea(
          top: false,
          child: SizedBox.expand(
            child: games.isEmpty
                ? RecordEmptyState(onCreate: () => context.go('/games/create'))
                : Column(
                    children: [
                      RecordPageHeader(gameCount: games.length),
                      GamesViewModeSelector(
                        viewMode: _viewMode,
                        onChanged: (viewMode) {
                          setState(() {
                            _viewMode = viewMode;
                          });
                        },
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: switch (_viewMode) {
                            GamesViewMode.list => GameListView(
                              key: const ValueKey('games-list-view'),
                              games: games,
                              myTeamById: myTeamById,
                            ),
                            GamesViewMode.calendar => GameCalendarView(
                              key: const ValueKey('games-calendar-view'),
                              games: games,
                              myTeamById: myTeamById,
                            ),
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
