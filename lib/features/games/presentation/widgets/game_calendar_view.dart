import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/my_team.dart';

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
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = _dateKey(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final today = DateTime.now();
    final month = DateTime(today.year, today.month);
    final calendarDays = _buildCalendarDays(month);
    final gameCountsByDate = _countGamesByDate(widget.games);
    final weekdayLabels = _weekdayLabels(localeName);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month_outlined, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                DateFormat.yMMMM(localeName).format(month),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (final label in weekdayLabels)
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: calendarDays.length,
            itemBuilder: (context, index) {
              final day = calendarDays[index];
              if (day == null) {
                return const SizedBox.shrink();
              }

              final gameCount = gameCountsByDate[_dateKey(day)] ?? 0;
              return _CalendarDayCell(
                day: day,
                gameCount: gameCount,
                gameCountLabel: l10n.seasonGamesCount(gameCount),
                isSelected: DateUtils.isSameDay(day, _selectedDate),
                onTap: () {
                  setState(() {
                    _selectedDate = _dateKey(day);
                  });
                },
              );
            },
          ),
        ],
      ),
    );
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

  List<String> _weekdayLabels(String localeName) {
    final sunday = DateTime(2026, 1, 4);
    return [
      for (var i = 0; i < DateTime.daysPerWeek; i++)
        DateFormat.E(localeName).format(sunday.add(Duration(days: i))),
    ];
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.day,
    required this.gameCount,
    required this.gameCountLabel,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime day;
  final int gameCount;
  final String gameCountLabel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isToday = DateUtils.isSameDay(day, DateTime.now());
    final foregroundColor = isSelected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurface;

    return Semantics(
      selected: isSelected,
      button: true,
      child: DecoratedBox(
        key: ValueKey('calendar-day-${day.year}-${day.month}-${day.day}'),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerLowest,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : isToday
                ? colorScheme.primary.withValues(alpha: 0.45)
                : colorScheme.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${day.day}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (gameCount > 0) ...[
                    const SizedBox(height: 3),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        gameCountLabel,
                        maxLines: 1,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
