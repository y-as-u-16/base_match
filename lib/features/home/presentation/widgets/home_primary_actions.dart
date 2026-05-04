import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';

class HomePrimaryActions extends StatelessWidget {
  const HomePrimaryActions({
    super.key,
    required this.onRecord,
    required this.onStats,
  });

  final VoidCallback onRecord;
  final VoidCallback onStats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;
        final recordButton = FilledButton.icon(
          onPressed: onRecord,
          icon: const Icon(Icons.add_circle_outline),
          label: Text(l10n.recordGameButton),
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            minimumSize: const Size.fromHeight(54),
            textStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        final statsButton = OutlinedButton.icon(
          onPressed: onStats,
          icon: const Icon(Icons.bar_chart_rounded),
          label: Text(l10n.viewStatsButton),
          style: OutlinedButton.styleFrom(
            backgroundColor: theme.colorScheme.surfaceContainerLowest,
            foregroundColor: theme.colorScheme.primary,
            side: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.54),
            ),
            minimumSize: const Size.fromHeight(54),
            textStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [recordButton, const SizedBox(height: 10), statsButton],
          );
        }

        return Row(
          children: [
            Expanded(child: recordButton),
            const SizedBox(width: 10),
            Expanded(child: statsButton),
          ],
        );
      },
    );
  }
}
