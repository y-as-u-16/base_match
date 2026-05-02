import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _inningController = TextEditingController();
  final _rbiController = TextEditingController();
  String _battingSide = AppConstants.sideHome;
  String? _selectedResultType;
  String? _selectedResultDetail;

  static const _resultTypeOptions = [
    (AppConstants.resultHit, 'ヒット'),
    (AppConstants.resultOut, 'アウト'),
    (AppConstants.resultWalk, '四死球'),
    (AppConstants.resultError, 'エラー'),
  ];

  static const _resultDetailMap = <String, List<(String, String)>>{
    AppConstants.resultHit: [
      (AppConstants.detailSingle, '単打'),
      (AppConstants.detailDouble, '二塁打'),
      (AppConstants.detailTriple, '三塁打'),
      (AppConstants.detailHr, '本塁打'),
    ],
    AppConstants.resultOut: [
      (AppConstants.detailK, '三振'),
      (AppConstants.detailGround, 'ゴロ'),
      (AppConstants.detailFly, 'フライ'),
      (AppConstants.detailLine, 'ライナー'),
      (AppConstants.detailDp, '併殺'),
      (AppConstants.detailSacBunt, '犠打'),
      (AppConstants.detailSacFly, '犠飛'),
      (AppConstants.detailOther, 'その他'),
    ],
    AppConstants.resultWalk: [
      (AppConstants.detailBb, '四球'),
      (AppConstants.detailHbp, '死球'),
    ],
    AppConstants.resultError: [(AppConstants.detailE, 'エラー')],
  };

  @override
  void dispose() {
    _inningController.dispose();
    _rbiController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedResultType == null || _selectedResultDetail == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('結果を選択してください')));
      return;
    }

    ref
        .read(localGameStoreProvider.notifier)
        .addPlateAppearance(
          gameId: widget.gameId,
          battingSide: _battingSide,
          inning: int.tryParse(_inningController.text.trim()),
          resultType: _selectedResultType!,
          resultDetail: _selectedResultDetail!,
          rbi: int.tryParse(_rbiController.text.trim()),
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('打席入力')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('攻撃側', style: theme.textTheme.titleMedium),
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
                selected: {_battingSide},
                onSelectionChanged: (selected) {
                  setState(() => _battingSide = selected.first);
                },
              ),
              const Gap(24),
              TextFormField(
                controller: _inningController,
                decoration: const InputDecoration(
                  labelText: 'イニング（任意）',
                  prefixIcon: Icon(Icons.format_list_numbered),
                ),
                keyboardType: TextInputType.number,
              ),
              const Gap(24),
              Text('結果タイプ', style: theme.textTheme.titleMedium),
              const Gap(8),
              Wrap(
                spacing: 8,
                children: _resultTypeOptions.map((option) {
                  final (value, label) = option;
                  return ChoiceChip(
                    label: Text(label),
                    selected: _selectedResultType == value,
                    onSelected: (selected) {
                      setState(() {
                        _selectedResultType = selected ? value : null;
                        _selectedResultDetail = null;
                      });
                    },
                  );
                }).toList(),
              ),
              if (_selectedResultType != null) ...[
                const Gap(16),
                Text('結果詳細', style: theme.textTheme.titleMedium),
                const Gap(8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (_resultDetailMap[_selectedResultType] ?? []).map((
                    option,
                  ) {
                    final (value, label) = option;
                    return ChoiceChip(
                      label: Text(label),
                      selected: _selectedResultDetail == value,
                      onSelected: (selected) {
                        setState(
                          () => _selectedResultDetail = selected ? value : null,
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
              const Gap(24),
              TextFormField(
                controller: _rbiController,
                decoration: const InputDecoration(
                  labelText: '打点（任意）',
                  prefixIcon: Icon(Icons.scoreboard_outlined),
                ),
                keyboardType: TextInputType.number,
              ),
              const Gap(32),
              FilledButton(onPressed: _onSubmit, child: const Text('登録する')),
            ],
          ),
        ),
      ),
    );
  }
}
