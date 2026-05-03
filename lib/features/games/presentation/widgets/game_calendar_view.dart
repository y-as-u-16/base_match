import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/game.dart';
import '../../domain/entities/my_team.dart';

class GameCalendarView extends StatelessWidget {
  const GameCalendarView({
    super.key,
    required this.games,
    required this.myTeamById,
  });

  final List<Game> games;
  final Map<String, MyTeam> myTeamById;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final today = DateTime.now();
    final month = DateTime(today.year, today.month);
    final calendarDays = _buildCalendarDays(month);
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

              return _CalendarDayCell(day: day);
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

  List<String> _weekdayLabels(String localeName) {
    final sunday = DateTime(2026, 1, 4);
    return [
      for (var i = 0; i < DateTime.daysPerWeek; i++)
        DateFormat.E(localeName).format(sunday.add(Duration(days: i))),
    ];
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isToday = DateUtils.isSameDay(day, DateTime.now());

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isToday
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerLowest,
        border: Border.all(
          color: isToday ? colorScheme.primary : colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: theme.textTheme.labelLarge?.copyWith(
            color: isToday
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
