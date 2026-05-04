import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/localization_helpers.dart';

class PitchingInputSummaryCard extends StatelessWidget {
  const PitchingInputSummaryCard({super.key, required this.summary});

  final String summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.12),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.onPrimary.withValues(alpha: 0.16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.query_stats,
                  color: colorScheme.onPrimary,
                  size: 24,
                ),
              ),
            ),
            const Gap(14),
            Expanded(
              child: Text(
                summary,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w900,
                  height: 1.24,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PitchingInputPanel extends StatelessWidget {
  const PitchingInputPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.50),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: child,
      ),
    );
  }
}

class PitchingOutsCounter extends StatelessWidget {
  const PitchingOutsCounter({
    super.key,
    required this.outsPitched,
    required this.onChanged,
  });

  final int outsPitched;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.72),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.54),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.sports_baseball_outlined,
                size: 18,
                color: colorScheme.primary,
              ),
              const Gap(8),
              Text(
                l10n.pitchingInningsLabel,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const Gap(12),
          Row(
            children: [
              IconButton.filledTonal(
                tooltip: l10n.decreaseOneOutTooltip,
                onPressed: () => onChanged(outsPitched - 1),
                icon: const Icon(Icons.remove),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      l10n.inningsFromOuts(outsPitched),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      l10n.outsLabel(outsPitched),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: l10n.increaseOneOutTooltip,
                onPressed: () => onChanged(outsPitched + 1),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const Gap(10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => onChanged(outsPitched + 1),
                child: Text(l10n.addOneThirdInningButton),
              ),
              OutlinedButton(
                onPressed: () => onChanged(outsPitched + 3),
                child: Text(l10n.addOneInningButton),
              ),
              TextButton(
                onPressed: () => onChanged(3),
                child: Text(l10n.resetOneInningButton),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PitchingCounterGrid extends StatelessWidget {
  const PitchingCounterGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth >= 520
            ? (constraints.maxWidth - 12) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: children
              .map((child) => SizedBox(width: itemWidth, child: child))
              .toList(),
        );
      },
    );
  }
}

class PitchingCounterTile extends StatelessWidget {
  const PitchingCounterTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.72),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.54),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
          ),
          IconButton.filledTonal(
            tooltip: l10n.decreaseLabelTooltip(label),
            onPressed: () => onChanged(value - 1),
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 48,
            child: Center(
              child: Text(
                '$value',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
          IconButton.filledTonal(
            tooltip: l10n.increaseLabelTooltip(label),
            onPressed: () => onChanged(value + 1),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
