import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../view_models/game_view_model.dart';
import '../view_models/my_team_view_model.dart';
import '../widgets/game_calendar_view.dart';
import '../widgets/record_page_header.dart';

class GamesPage extends ConsumerStatefulWidget {
  const GamesPage({super.key});

  @override
  ConsumerState<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends ConsumerState<GamesPage> {
  DateTime _calendarSelectedDate = _dateKey(DateTime.now());

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
        onPressed: () => context.go(_createGameLocation()),
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
            child: Column(
              children: [
                RecordPageHeader(gameCount: games.length),
                Expanded(
                  child: GameCalendarView(
                    key: const ValueKey('games-calendar-view'),
                    games: games,
                    myTeamById: myTeamById,
                    selectedDate: _calendarSelectedDate,
                    onSelectedDateChanged: (date) {
                      setState(() {
                        _calendarSelectedDate = _dateKey(date);
                      });
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

  String _createGameLocation() {
    final date = _calendarSelectedDate;
    final dateQuery =
        '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
    return '/games/create?date=$dateQuery';
  }

  static DateTime _dateKey(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
