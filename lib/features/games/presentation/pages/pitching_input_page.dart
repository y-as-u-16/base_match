import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/localization_helpers.dart';
import '../view_models/game_view_model.dart';

class PitchingInputPage extends ConsumerStatefulWidget {
  const PitchingInputPage({super.key, required this.gameId});

  final String gameId;

  @override
  ConsumerState<PitchingInputPage> createState() => _PitchingInputPageState();
}

class _PitchingInputPageState extends ConsumerState<PitchingInputPage> {
  int _outsPitched = 3;
  int _runs = 0;
  int _earnedRuns = 0;
  int _hitsAllowed = 0;
  int _walks = 0;
  int _strikeouts = 0;
  int _homeRunsAllowed = 0;

  Future<void> _onSubmit() async {
    await ref
        .read(localGameStoreProvider.notifier)
        .addPitchingAppearance(
          gameId: widget.gameId,
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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.pitchingInputTitle)),
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
                const Icon(Icons.query_stats),
                const Gap(12),
                Expanded(
                  child: Text(
                    l10n.pitchingInputSummary(
                      l10n.inningsFromOuts(_outsPitched),
                      _runs,
                      _earnedRuns,
                    ),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          _OutsCounter(outsPitched: _outsPitched, onChanged: _setOuts),
          const Gap(20),
          _CounterGrid(
            children: [
              _CounterTile(
                label: l10n.runsLabel,
                value: _runs,
                onChanged: _setRuns,
              ),
              _CounterTile(
                label: l10n.earnedRunsLabel,
                value: _earnedRuns,
                onChanged: _setEarnedRuns,
              ),
              _CounterTile(
                label: l10n.hitsAllowedLabel,
                value: _hitsAllowed,
                onChanged: _setHitsAllowed,
              ),
              _CounterTile(
                label: l10n.walksAllowedLabel,
                value: _walks,
                onChanged: _setWalks,
              ),
              _CounterTile(
                label: l10n.strikeoutsLabel,
                value: _strikeouts,
                onChanged: _setStrikeouts,
              ),
              _CounterTile(
                label: l10n.homeRunsAllowedLabel,
                value: _homeRunsAllowed,
                onChanged: _setHomeRunsAllowed,
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton.icon(
            onPressed: _onSubmit,
            icon: const Icon(Icons.save_outlined),
            label: Text(l10n.saveButton),
          ),
        ),
      ),
    );
  }
}

class _OutsCounter extends StatelessWidget {
  const _OutsCounter({required this.outsPitched, required this.onChanged});

  final int outsPitched;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pitchingInningsLabel,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const Gap(8),
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
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(l10n.outsLabel(outsPitched)),
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
          const Gap(8),
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

class _CounterGrid extends StatelessWidget {
  const _CounterGrid({required this.children});

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

class _CounterTile extends StatelessWidget {
  const _CounterTile({
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
    final l10n = AppLocalizations.of(context);
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
                  fontWeight: FontWeight.w900,
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
