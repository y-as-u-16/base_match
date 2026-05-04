import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/localization_helpers.dart';
import '../view_models/game_view_model.dart';
import '../widgets/plate_appearance_input_widgets.dart';

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
  PlateAppearanceResultOption? _selectedResult;

  static const _hitOptions = [
    PlateAppearanceResultOption(
      type: AppConstants.resultHit,
      detail: AppConstants.detailSingle,
      icon: Icons.looks_one_outlined,
    ),
    PlateAppearanceResultOption(
      type: AppConstants.resultHit,
      detail: AppConstants.detailDouble,
      icon: Icons.looks_two_outlined,
    ),
    PlateAppearanceResultOption(
      type: AppConstants.resultHit,
      detail: AppConstants.detailTriple,
      icon: Icons.looks_3_outlined,
    ),
    PlateAppearanceResultOption(
      type: AppConstants.resultHit,
      detail: AppConstants.detailHr,
      icon: Icons.sports_baseball,
    ),
  ];

  static const _outOptions = [
    PlateAppearanceResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailK,
      icon: Icons.close,
    ),
    PlateAppearanceResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailGround,
      icon: Icons.south_east,
    ),
    PlateAppearanceResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailFly,
      icon: Icons.north_east,
    ),
    PlateAppearanceResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailLine,
      icon: Icons.trending_flat,
    ),
    PlateAppearanceResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailDp,
      icon: Icons.keyboard_double_arrow_right,
    ),
    PlateAppearanceResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailSacBunt,
      icon: Icons.arrow_forward,
    ),
    PlateAppearanceResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailSacFly,
      icon: Icons.upload,
    ),
    PlateAppearanceResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailOther,
      icon: Icons.more_horiz,
    ),
  ];

  static const _onBaseOptions = [
    PlateAppearanceResultOption(
      type: AppConstants.resultWalk,
      detail: AppConstants.detailBb,
      icon: Icons.radio_button_unchecked,
    ),
    PlateAppearanceResultOption(
      type: AppConstants.resultWalk,
      detail: AppConstants.detailHbp,
      icon: Icons.personal_injury_outlined,
    ),
    PlateAppearanceResultOption(
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

  void _selectResult(PlateAppearanceResultOption result) {
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
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final selectedLabel = _selectedResult == null
        ? l10n.notSelectedLabel
        : l10n.resultDetailLabel(_selectedResult!.detail);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l10n.plateAppearanceInputTitle),
        centerTitle: false,
        backgroundColor: colorScheme.surfaceContainerLowest,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          PlateAppearanceSummaryCard(
            text: l10n.plateAppearanceSummary(_inning, selectedLabel, _rbi),
          ),
          const Gap(14),
          PlateAppearanceInputPanel(
            children: [
              TextField(
                controller: _batterNameController,
                decoration: InputDecoration(
                  labelText: l10n.batterNameLabel,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const Gap(12),
              PlateAppearanceStepperRow(
                label: l10n.inningLabel,
                valueLabel: l10n.inningsShort(_inning),
                onDecrease: () => _setInning(_inning - 1),
                onIncrease: () => _setInning(_inning + 1),
              ),
              const Gap(12),
              PlateAppearanceStepperRow(
                label: l10n.rbiLabel,
                valueLabel: '$_rbi',
                onDecrease: () => _setRbi(_rbi - 1),
                onIncrease: () => _setRbi(_rbi + 1),
              ),
            ],
          ),
          const Gap(18),
          PlateAppearanceInputPanel(
            children: [
              PlateAppearanceResultSection(
                title: l10n.hitSectionTitle,
                options: _hitOptions,
                selected: _selectedResult,
                onSelected: _selectResult,
              ),
              const Gap(22),
              PlateAppearanceResultSection(
                title: l10n.outSectionTitle,
                options: _outOptions,
                selected: _selectedResult,
                onSelected: _selectResult,
              ),
              const Gap(22),
              PlateAppearanceResultSection(
                title: l10n.onBaseSectionTitle,
                options: _onBaseOptions,
                selected: _selectedResult,
                onSelected: _selectResult,
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.96),
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.55),
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: FilledButton.icon(
              onPressed: _selectedResult == null ? null : _onSubmit,
              icon: const Icon(Icons.save_outlined),
              label: Text(l10n.saveButton),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                disabledBackgroundColor: colorScheme.surfaceContainerHighest,
                disabledForegroundColor: colorScheme.onSurfaceVariant,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
