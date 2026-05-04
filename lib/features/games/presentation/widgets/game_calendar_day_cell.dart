import 'package:flutter/material.dart';

class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    super.key,
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
    final hasGames = gameCount > 0;
    final foregroundColor = isSelected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurface;
    final mutedColor = isSelected
        ? colorScheme.onPrimaryContainer.withValues(alpha: 0.70)
        : colorScheme.onSurfaceVariant;

    return Semantics(
      selected: isSelected,
      button: true,
      child: DecoratedBox(
        key: ValueKey('calendar-day-${day.year}-${day.month}-${day.day}'),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : hasGames
              ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.62)
              : colorScheme.surfaceContainerLowest,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : isToday
                ? colorScheme.tertiary.withValues(alpha: 0.55)
                : hasGames
                ? colorScheme.primary.withValues(alpha: 0.28)
                : colorScheme.outlineVariant.withValues(alpha: 0.38),
            width: isSelected ? 1.4 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 6, 6, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${day.day}',
                          maxLines: 1,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: foregroundColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      if (isToday)
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                          child: const SizedBox(width: 6, height: 6),
                        ),
                    ],
                  ),
                  const Spacer(),
                  if (hasGames)
                    _GameCountPill(
                      label: gameCountLabel,
                      isSelected: isSelected,
                    )
                  else
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: mutedColor.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const SizedBox(width: 16, height: 3),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GameCountPill extends StatelessWidget {
  const _GameCountPill({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final foregroundColor = isSelected
        ? colorScheme.onPrimaryContainer
        : colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: foregroundColor.withValues(alpha: isSelected ? 0.14 : 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: foregroundColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                maxLines: 1,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
