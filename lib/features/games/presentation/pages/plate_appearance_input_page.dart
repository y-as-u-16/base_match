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
  int _inning = 1;
  int _rbi = 0;
  _ResultOption? _selectedResult;

  static const _hitOptions = [
    _ResultOption(
      type: AppConstants.resultHit,
      detail: AppConstants.detailSingle,
      label: '単打',
      icon: Icons.looks_one_outlined,
    ),
    _ResultOption(
      type: AppConstants.resultHit,
      detail: AppConstants.detailDouble,
      label: '二塁打',
      icon: Icons.looks_two_outlined,
    ),
    _ResultOption(
      type: AppConstants.resultHit,
      detail: AppConstants.detailTriple,
      label: '三塁打',
      icon: Icons.looks_3_outlined,
    ),
    _ResultOption(
      type: AppConstants.resultHit,
      detail: AppConstants.detailHr,
      label: '本塁打',
      icon: Icons.sports_baseball,
    ),
  ];

  static const _outOptions = [
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailK,
      label: '三振',
      icon: Icons.close,
    ),
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailGround,
      label: 'ゴロ',
      icon: Icons.south_east,
    ),
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailFly,
      label: 'フライ',
      icon: Icons.north_east,
    ),
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailLine,
      label: 'ライナー',
      icon: Icons.trending_flat,
    ),
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailDp,
      label: '併殺',
      icon: Icons.keyboard_double_arrow_right,
    ),
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailSacBunt,
      label: '犠打',
      icon: Icons.arrow_forward,
    ),
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailSacFly,
      label: '犠飛',
      icon: Icons.upload,
    ),
    _ResultOption(
      type: AppConstants.resultOut,
      detail: AppConstants.detailOther,
      label: 'その他',
      icon: Icons.more_horiz,
    ),
  ];

  static const _onBaseOptions = [
    _ResultOption(
      type: AppConstants.resultWalk,
      detail: AppConstants.detailBb,
      label: '四球',
      icon: Icons.radio_button_unchecked,
    ),
    _ResultOption(
      type: AppConstants.resultWalk,
      detail: AppConstants.detailHbp,
      label: '死球',
      icon: Icons.personal_injury_outlined,
    ),
    _ResultOption(
      type: AppConstants.resultError,
      detail: AppConstants.detailE,
      label: 'エラー',
      icon: Icons.error_outline,
    ),
  ];

  Future<void> _onSubmit() async {
    final result = _selectedResult;
    if (result == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('打席結果を選択してください')));
      return;
    }

    await ref
        .read(localGameStoreProvider.notifier)
        .addPlateAppearance(
          gameId: widget.gameId,
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
    final selectedLabel = _selectedResult?.label ?? '未選択';

    return Scaffold(
      appBar: AppBar(title: const Text('打席入力')),
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
                    '$_inning回 / $selectedLabel / 打点 $_rbi',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          _StepperRow(
            label: 'イニング',
            valueLabel: '$_inning回',
            onDecrease: () => _setInning(_inning - 1),
            onIncrease: () => _setInning(_inning + 1),
          ),
          const Gap(12),
          _StepperRow(
            label: '打点',
            valueLabel: '$_rbi',
            onDecrease: () => _setRbi(_rbi - 1),
            onIncrease: () => _setRbi(_rbi + 1),
          ),
          const Gap(24),
          _ResultSection(
            title: 'ヒット',
            options: _hitOptions,
            selected: _selectedResult,
            onSelected: _selectResult,
          ),
          const Gap(20),
          _ResultSection(
            title: 'アウト',
            options: _outOptions,
            selected: _selectedResult,
            onSelected: _selectResult,
          ),
          const Gap(20),
          _ResultSection(
            title: '出塁・その他',
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
            label: const Text('登録する'),
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
              label: Text(option.label),
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
            tooltip: '$labelを減らす',
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
            tooltip: '$labelを増やす',
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
    required this.label,
    required this.icon,
  });

  final String type;
  final String detail;
  final String label;
  final IconData icon;
}
