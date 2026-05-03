import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/localization_helpers.dart';
import '../view_models/game_view_model.dart';

class PlateAppearanceInputPage extends ConsumerStatefulWidget {
  const PlateAppearanceInputPage({super.key, required this.gameId});

  final String gameId;

  @override
  ConsumerState<PlateAppearanceInputPage> createState() =>
      _PlateAppearanceInputPageState();
}

class _PlateAppearanceInputPageState
    extends ConsumerState<PlateAppearanceInputPage> {
  final _batterNameController = TextEditingController(text: '自分');
  int _inning = 1;
  int _rbi = 0;
  _ResultOption? _selectedResult;

  static const _hitOptions = [
    _ResultOption(
      type: AppConstants.resultHit,
      detail: AppConstants.detailSingle,
      icon: Icons.looks_one_outlined,
    ),
    _ResultOption(
      type: AppConstants.resultHit,
      detail: AppConstants.detailDouble,
      icon: Icons.looks_two_outlined,
    ),
    _ResultOption(
      type: AppConstants.resultHit,
      detail: AppConstants.detailTriple,
      icon: Icons.looks_3_outlined,
    ),
    _ResultOption(
      type: AppConstants.resultHit,
      detail: AppConstants.detailHr,
      icon: Icons.sports_baseball,
    ),
  ];

  static const _outOptions = [
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailK,
      icon: Icons.close,
    ),
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailGround,
      icon: Icons.south_east,
    ),
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailFly,
      icon: Icons.north_east,
    ),
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailLine,
      icon: Icons.trending_flat,
    ),
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailDp,
      icon: Icons.keyboard_double_arrow_right,
    ),
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailSacBunt,
      icon: Icons.arrow_forward,
    ),
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailSacFly,
      icon: Icons.upload,
    ),
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailOther,
      icon: Icons.more_horiz,
    ),
  ];

  static const _onBaseOptions = [
    _ResultOption(
      type: AppConstants.resultWalk,
      detail: AppConstants.detailBb,
      icon: Icons.radio_button_unchecked,
    ),
    _ResultOption(
      type: AppConstants.resultWalk,
      detail: AppConstants.detailHbp,
      icon: Icons.personal_injury_outlined,
    ),
    _ResultOption(
      type: AppConstants.resultError,
      detail: AppConstants.detailE,
      icon: Icons.error_outline,
    ),
  ];

  @override
  void dispose() {
    _batterNameController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final result = _selectedResult;
    final batterName = _batterNameController.text.trim();
    if (batterName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).playerNameRequired),
        ),
      );
      return;
    }
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).selectPlateAppearanceResultMessage,
          ),
        ),
      );
      return;
    }

    await ref
        .read(localGameStoreProvider.notifier)
        .addPlateAppearance(
          gameId: widget.gameId,
          batterName: batterName,
          inning: _inning,
          resultType: result.type,
          resultDetail: result.detail,
          rbi: _rbi,
        );
    if (!mounted) return;
    context.pop();
  }

  void _selectResult(_ResultOption result) {
    setState(() => _selectedResult = result);
  }

  void _setInning(int value) {
    setState(() => _inning = value.clamp(1, 99));
  }

  void _setRbi(int value) {
    setState(() => _rbi = value.clamp(0, 99));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final selectedLabel = _selectedResult == null
        ? l10n.notSelectedLabel
        : l10n.resultDetailLabel(_selectedResult!.detail);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.plateAppearanceInputTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.fact_check_outlined),
                const Gap(12),
                Expanded(
                  child: Text(
                    l10n.plateAppearanceSummary(_inning, selectedLabel, _rbi),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          TextField(
            controller: _batterNameController,
            decoration: InputDecoration(
              labelText: l10n.batterNameLabel,
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),
          const Gap(12),
          _StepperRow(
            label: l10n.inningLabel,
            valueLabel: l10n.inningsShort(_inning),
            onDecrease: () => _setInning(_inning - 1),
            onIncrease: () => _setInning(_inning + 1),
          ),
          const Gap(12),
          _StepperRow(
            label: l10n.rbiLabel,
            valueLabel: '$_rbi',
            onDecrease: () => _setRbi(_rbi - 1),
            onIncrease: () => _setRbi(_rbi + 1),
          ),
          const Gap(24),
          _ResultSection(
            title: l10n.hitSectionTitle,
            options: _hitOptions,
            selected: _selectedResult,
            onSelected: _selectResult,
          ),
          const Gap(20),
          _ResultSection(
            title: l10n.outSectionTitle,
            options: _outOptions,
            selected: _selectedResult,
            onSelected: _selectResult,
          ),
          const Gap(20),
          _ResultSection(
            title: l10n.onBaseSectionTitle,
            options: _onBaseOptions,
            selected: _selectedResult,
            onSelected: _selectResult,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton.icon(
            onPressed: _selectedResult == null ? null : _onSubmit,
            icon: const Icon(Icons.save_outlined),
            label: Text(l10n.saveButton),
          ),
        ),
      ),
    );
  }
}

class _ResultSection extends StatelessWidget {
  const _ResultSection({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<_ResultOption> options;
  final _ResultOption? selected;
  final ValueChanged<_ResultOption> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const Gap(8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = option == selected;
            return ChoiceChip(
              avatar: Icon(option.icon, size: 18),
              label: Text(
                AppLocalizations.of(context).resultDetailLabel(option.detail),
              ),
              selected: isSelected,
              onSelected: (_) => onSelected(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _StepperRow extends StatelessWidget {
  const _StepperRow({
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton.filledTonal(
            tooltip: AppLocalizations.of(context).decreaseLabelTooltip(label),
            onPressed: onDecrease,
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 72,
            child: Center(
              child: Text(
                valueLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          IconButton.filledTonal(
            tooltip: AppLocalizations.of(context).increaseLabelTooltip(label),
            onPressed: onIncrease,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _ResultOption {
  const _ResultOption({
    required this.type,
    required this.detail,
    required this.icon,
  });

  final String type;
  final String detail;
  final IconData icon;
}
