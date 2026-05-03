import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';

class RecordEmptyState extends StatelessWidget {
  const RecordEmptyState({super.key, required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Icon(
                      Icons.sports_baseball_outlined,
                      color: colorScheme.onPrimaryContainer,
                      size: 34,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.emptyGamesTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.emptyGamesSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onCreate,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.createGameButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
