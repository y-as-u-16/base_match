import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/my_team.dart';
import 'game_calendar_header.dart';
import 'game_calendar_month_grid.dart';
import 'selected_date_game_section.dart';

class GameCalendarView extends StatefulWidget {
  const GameCalendarView({
    super.key,
    required this.games,
    required this.myTeamById,
  });

  final List<Game> games;
  final Map<String, MyTeam> myTeamById;

  @override
  State<GameCalendarView> createState() => _GameCalendarViewState();
}

class _GameCalendarViewState extends State<GameCalendarView> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final today = _dateKey(DateTime.now());
    _focusedMonth = DateTime(today.year, today.month);
    _selectedDate = today;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final calendarDays = _buildCalendarDays(_focusedMonth);
    final gameCountsByDate = _countGamesByDate(widget.games);
    final selectedGames = _gamesOnDate(widget.games, _selectedDate);
    final weekdayLabels = _weekdayLabels(localeName);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.46),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GameCalendarHeader(
                    focusedMonthLabel: DateFormat.yMMMM(
                      localeName,
                    ).format(_focusedMonth),
                    previousMonthTooltip: l10n.previousMonthTooltip,
                    nextMonthTooltip: l10n.nextMonthTooltip,
                    onPreviousMonth: () => _changeMonth(-1),
                    onNextMonth: () => _changeMonth(1),
                  ),
                  const SizedBox(height: 12),
                  CalendarMonthGrid(
                    days: calendarDays,
                    weekdayLabels: weekdayLabels,
                    gameCountsByDate: gameCountsByDate,
                    selectedDate: _selectedDate,
                    gameCountLabelBuilder: l10n.seasonGamesCount,
                    onDateSelected: (day) {
                      setState(() {
                        _selectedDate = _dateKey(day);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          SelectedDateGameSection(
            selectedDate: _selectedDate,
            games: selectedGames,
            myTeamById: widget.myTeamById,
          ),
        ],
      ),
    );
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + offset,
      );
      _selectedDate = _focusedMonth;
    });
  }

  List<DateTime?> _buildCalendarDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingBlanks = firstDay.weekday % DateTime.daysPerWeek;
    final days = <DateTime?>[
      for (var i = 0; i < leadingBlanks; i++) null,
      for (var day = 1; day <= daysInMonth; day++)
        DateTime(month.year, month.month, day),
    ];
    final trailingBlanks =
        (DateTime.daysPerWeek - days.length % DateTime.daysPerWeek) %
        DateTime.daysPerWeek;

    return [...days, for (var i = 0; i < trailingBlanks; i++) null];
  }

  Map<DateTime, int> _countGamesByDate(List<Game> games) {
    final counts = <DateTime, int>{};
    for (final game in games) {
      final key = _dateKey(game.date);
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts;
  }

  DateTime _dateKey(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<Game> _gamesOnDate(List<Game> games, DateTime date) {
    return games.where((game) => DateUtils.isSameDay(game.date, date)).toList();
  }

  List<String> _weekdayLabels(String localeName) {
    final sunday = DateTime(2026, 1, 4);
    return [
      for (var i = 0; i < DateTime.daysPerWeek; i++)
        DateFormat.E(localeName).format(sunday.add(Duration(days: i))),
    ];
  }
}
