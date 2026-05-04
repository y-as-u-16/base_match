import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/localization_helpers.dart';
import '../view_models/game_view_model.dart';
import '../widgets/pitching_input_widgets.dart';

class PitchingInputPage extends ConsumerStatefulWidget {
  const PitchingInputPage({super.key, required this.gameId});

  final String gameId;

  @override
  ConsumerState<PitchingInputPage> createState() => _PitchingInputPageState();
}

class _PitchingInputPageState extends ConsumerState<PitchingInputPage> {
  final _pitcherNameController = TextEditingController(text: '自分');
  int _outsPitched = 3;
  int _runs = 0;
  int _earnedRuns = 0;
  int _hitsAllowed = 0;
  int _walks = 0;
  int _strikeouts = 0;
  int _homeRunsAllowed = 0;

  @override
  void dispose() {
    _pitcherNameController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final pitcherName = _pitcherNameController.text.trim();
    if (pitcherName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).playerNameRequired),
        ),
      );
      return;
    }

    await ref
        .read(localGameStoreProvider.notifier)
        .addPitchingAppearance(
          gameId: widget.gameId,
          pitcherName: pitcherName,
          outsPitched: _outsPitched,
          runs: _runs,
          earnedRuns: _earnedRuns,
          hitsAllowed: _hitsAllowed,
          walks: _walks,
          strikeouts: _strikeouts,
          homeRunsAllowed: _homeRunsAllowed,
        );
    if (!mounted) return;
    context.pop();
  }

  void _setOuts(int value) {
    setState(() => _outsPitched = value.clamp(1, 99));
  }

  void _setRuns(int value) {
    setState(() => _runs = value.clamp(0, 99));
  }

  void _setEarnedRuns(int value) {
    setState(() => _earnedRuns = value.clamp(0, 99));
  }

  void _setHitsAllowed(int value) {
    setState(() => _hitsAllowed = value.clamp(0, 99));
  }

  void _setWalks(int value) {
    setState(() => _walks = value.clamp(0, 99));
  }

  void _setStrikeouts(int value) {
    setState(() => _strikeouts = value.clamp(0, 99));
  }

  void _setHomeRunsAllowed(int value) {
    setState(() => _homeRunsAllowed = value.clamp(0, 99));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l10n.pitchingInputTitle),
        centerTitle: false,
        backgroundColor: colorScheme.surfaceContainerLowest,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          PitchingInputSummaryCard(
            summary: l10n.pitchingInputSummary(
              l10n.inningsFromOuts(_outsPitched),
              _runs,
              _earnedRuns,
            ),
          ),
          const Gap(14),
          PitchingInputPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _pitcherNameController,
                  decoration: InputDecoration(
                    labelText: l10n.pitcherNameLabel,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const Gap(14),
                PitchingOutsCounter(
                  outsPitched: _outsPitched,
                  onChanged: _setOuts,
                ),
                const Gap(18),
                PitchingCounterGrid(
                  children: [
                    PitchingCounterTile(
                      label: l10n.runsLabel,
                      value: _runs,
                      onChanged: _setRuns,
                    ),
                    PitchingCounterTile(
                      label: l10n.earnedRunsLabel,
                      value: _earnedRuns,
                      onChanged: _setEarnedRuns,
                    ),
                    PitchingCounterTile(
                      label: l10n.hitsAllowedLabel,
                      value: _hitsAllowed,
                      onChanged: _setHitsAllowed,
                    ),
                    PitchingCounterTile(
                      label: l10n.walksAllowedLabel,
                      value: _walks,
                      onChanged: _setWalks,
                    ),
                    PitchingCounterTile(
                      label: l10n.strikeoutsLabel,
                      value: _strikeouts,
                      onChanged: _setStrikeouts,
                    ),
                    PitchingCounterTile(
                      label: l10n.homeRunsAllowedLabel,
                      value: _homeRunsAllowed,
                      onChanged: _setHomeRunsAllowed,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: FilledButton.icon(
              onPressed: _onSubmit,
              icon: const Icon(Icons.save_outlined),
              label: Text(l10n.saveButton),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
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
