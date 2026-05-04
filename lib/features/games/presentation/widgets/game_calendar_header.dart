import 'package:flutter/material.dart';

class GameCalendarHeader extends StatelessWidget {
  const GameCalendarHeader({
    super.key,
    required this.focusedMonthLabel,
    required this.previousMonthTooltip,
    required this.nextMonthTooltip,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final String focusedMonthLabel;
  final String previousMonthTooltip;
  final String nextMonthTooltip;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        _MonthIconButton(
          tooltip: previousMonthTooltip,
          icon: Icons.chevron_left,
          onPressed: onPreviousMonth,
        ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.42),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.calendar_month_outlined,
                      size: 18,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      focusedMonthLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _MonthIconButton(
          tooltip: nextMonthTooltip,
          icon: Icons.chevron_right,
          onPressed: onNextMonth,
        ),
      ],
    );
  }
}

class _MonthIconButton extends StatelessWidget {
  const _MonthIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: IconButton.filledTonal(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon),
        style: IconButton.styleFrom(
          fixedSize: const Size(42, 42),
          backgroundColor: colorScheme.surfaceContainerLow,
          foregroundColor: colorScheme.onSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
