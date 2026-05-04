import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/localization_helpers.dart';

class PlateAppearanceSummaryCard extends StatelessWidget {
  const PlateAppearanceSummaryCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.16),
              ),
            ),
            child: Icon(
              Icons.fact_check_outlined,
              color: colorScheme.onPrimaryContainer,
              size: 21,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w900,
                height: 1.32,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlateAppearanceInputPanel extends StatelessWidget {
  const PlateAppearanceInputPanel({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.045),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class PlateAppearanceResultSection extends StatelessWidget {
  const PlateAppearanceResultSection({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<PlateAppearanceResultOption> options;
  final PlateAppearanceResultOption? selected;
  final ValueChanged<PlateAppearanceResultOption> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        const Gap(10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = option == selected;
            return ChoiceChip(
              avatar: Icon(
                option.icon,
                size: 18,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
              label: Text(
                AppLocalizations.of(context).resultDetailLabel(option.detail),
              ),
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
              selected: isSelected,
              onSelected: (_) => onSelected(option),
              backgroundColor: colorScheme.surfaceContainerLowest,
              selectedColor: colorScheme.primaryContainer,
              side: BorderSide(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.34)
                    : colorScheme.outlineVariant.withValues(alpha: 0.72),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              showCheckmark: false,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class PlateAppearanceStepperRow extends StatelessWidget {
  const PlateAppearanceStepperRow({
    super.key,
    required this.label,
    required this.valueLabel,
    required this.onDecrease,
    required this.onIncrease,
  });

  final String label;
  final String valueLabel;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.72),
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
            tooltip: AppLocalizations.of(context).decreaseLabelTooltip(label),
            onPressed: onDecrease,
            icon: const Icon(Icons.remove),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest,
              foregroundColor: colorScheme.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(
            width: 72,
            child: Center(
              child: Text(
                valueLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
          IconButton.filledTonal(
            tooltip: AppLocalizations.of(context).increaseLabelTooltip(label),
            onPressed: onIncrease,
            icon: const Icon(Icons.add),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlateAppearanceResultOption {
  const PlateAppearanceResultOption({
    required this.type,
    required this.detail,
    required this.icon,
  });

  final String type;
  final String detail;
  final IconData icon;
}
