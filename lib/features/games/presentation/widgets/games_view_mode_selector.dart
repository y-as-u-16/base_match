import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';

enum GamesViewMode { list, calendar }

class GamesViewModeSelector extends StatelessWidget {
  const GamesViewModeSelector({
    super.key,
    required this.viewMode,
    required this.onChanged,
  });

  final GamesViewMode viewMode;
  final ValueChanged<GamesViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.48),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<GamesViewMode>(
              showSelectedIcon: false,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                side: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return BorderSide(
                      color: colorScheme.primary.withValues(alpha: 0.88),
                    );
                  }
                  return BorderSide(color: Colors.transparent);
                }),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return colorScheme.primaryContainer;
                  }
                  return Colors.transparent;
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return colorScheme.onPrimaryContainer;
                  }
                  return colorScheme.onSurfaceVariant;
                }),
                textStyle: WidgetStatePropertyAll(
                  theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              segments: [
                ButtonSegment(
                  value: GamesViewMode.list,
                  icon: const Icon(Icons.view_agenda_outlined),
                  label: Text(l10n.gamesListViewLabel),
                ),
                ButtonSegment(
                  value: GamesViewMode.calendar,
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: Text(l10n.gamesCalendarViewLabel),
                ),
              ],
              selected: {viewMode},
              onSelectionChanged: (selected) => onChanged(selected.single),
            ),
          ),
        ),
      ),
    );
  }
}
