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
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<GamesViewMode>(
          segments: [
            ButtonSegment(
              value: GamesViewMode.list,
              icon: const Icon(Icons.view_list_outlined),
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
    );
  }
}
