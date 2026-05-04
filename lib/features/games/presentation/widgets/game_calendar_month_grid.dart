import 'package:flutter/material.dart';

import 'game_calendar_day_cell.dart';

class CalendarMonthGrid extends StatelessWidget {
  const CalendarMonthGrid({
    super.key,
    required this.days,
    required this.weekdayLabels,
    required this.gameCountsByDate,
    required this.selectedDate,
    required this.gameCountLabelBuilder,
    required this.onDateSelected,
  });

  final List<DateTime?> days;
  final List<String> weekdayLabels;
  final Map<DateTime, int> gameCountsByDate;
  final DateTime selectedDate;
  final String Function(int count) gameCountLabelBuilder;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                for (final label in weekdayLabels)
                  Expanded(
                    child: Center(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 7,
            crossAxisSpacing: 7,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];
            if (day == null) {
              return const SizedBox.shrink();
            }

            final gameCount = gameCountsByDate[_dateKey(day)] ?? 0;
            return CalendarDayCell(
              day: day,
              gameCount: gameCount,
              gameCountLabel: gameCountLabelBuilder(gameCount),
              isSelected: DateUtils.isSameDay(day, selectedDate),
              onTap: () => onDateSelected(day),
            );
          },
        ),
      ],
    );
  }

  DateTime _dateKey(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
