import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../view_models/game_view_model.dart';

class PitchingInputPage extends ConsumerStatefulWidget {
  const PitchingInputPage({super.key, required this.gameId});

  final String gameId;

  @override
  ConsumerState<PitchingInputPage> createState() => _PitchingInputPageState();
}

class _PitchingInputPageState extends ConsumerState<PitchingInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _outsController = TextEditingController();
  final _runsController = TextEditingController();
  final _earnedRunsController = TextEditingController();
  final _hitsAllowedController = TextEditingController();
  final _walksController = TextEditingController();
  final _strikeoutsController = TextEditingController();
  final _homeRunsAllowedController = TextEditingController();
  String _pitchingSide = AppConstants.sideHome;

  @override
  void dispose() {
    _outsController.dispose();
    _runsController.dispose();
    _earnedRunsController.dispose();
    _hitsAllowedController.dispose();
    _walksController.dispose();
    _strikeoutsController.dispose();
    _homeRunsAllowedController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(localGameStoreProvider.notifier)
        .addPitchingAppearance(
          gameId: widget.gameId,
          pitchingSide: _pitchingSide,
          outsPitched: int.parse(_outsController.text.trim()),
          runs: _intValue(_runsController),
          earnedRuns: _intValue(_earnedRunsController),
          hitsAllowed: _intValue(_hitsAllowedController),
          walks: _intValue(_walksController),
          strikeouts: _intValue(_strikeoutsController),
          homeRunsAllowed: _intValue(_homeRunsAllowedController),
        );
    context.pop();
  }

  int _intValue(TextEditingController controller) =>
      int.tryParse(controller.text.trim()) ?? 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('ピッチング入力')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('投球側', style: theme.textTheme.titleMedium),
              const Gap(8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: AppConstants.sideHome,
                    label: Text('自分側'),
                  ),
                  ButtonSegment(
                    value: AppConstants.sideAway,
                    label: Text('相手側'),
                  ),
                ],
                selected: {_pitchingSide},
                onSelectionChanged: (selected) {
                  setState(() => _pitchingSide = selected.first);
                },
              ),
              const Gap(24),
              _numberField(_outsController, '投球アウト数（1回 = 3）', required: true),
              const Gap(12),
              _numberField(_runsController, '失点'),
              const Gap(12),
              _numberField(_earnedRunsController, '自責点'),
              const Gap(12),
              _numberField(_hitsAllowedController, '被安打'),
              const Gap(12),
              _numberField(_walksController, '与四死球'),
              const Gap(12),
              _numberField(_strikeoutsController, '奪三振'),
              const Gap(12),
              _numberField(_homeRunsAllowedController, '被本塁打'),
              const Gap(32),
              FilledButton(onPressed: _onSubmit, child: const Text('登録する')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numberField(
    TextEditingController controller,
    String label, {
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      validator: required
          ? (value) {
              if (value == null || value.trim().isEmpty) return '入力してください';
              if (int.tryParse(value.trim()) == null) return '数値で入力してください';
              return null;
            }
          : null,
    );
  }
}
