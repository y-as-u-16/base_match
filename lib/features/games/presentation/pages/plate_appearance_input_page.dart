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
  final _newBatterNameController = TextEditingController();
  final _newPitcherNameController = TextEditingController();

  String? _selectedBatterId;
  String? _selectedPitcherId;
  String? _selectedResultType;
  String? _selectedResultDetail;
  bool _createNewBatter = false;
  bool _createNewPitcher = false;

  // Which team the batter/pitcher belongs to
  String? _batterTeamId;
  String? _pitcherTeamId;

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
    AppConstants.resultError: [
      (AppConstants.detailE, 'エラー'),
    ],
  };

  static const _batterNameTemplates = [
    '相手1番',
    '相手2番',
    '相手3番',
    '相手4番',
    '相手5番',
    '相手6番',
    '相手7番',
    '相手8番',
    '相手9番',
  ];

  static const _pitcherNameTemplates = [
    '相手投手',
    '相手先発',
    '相手リリーフ',
  ];

  @override
  void dispose() {
    _inningController.dispose();
    _rbiController.dispose();
    _newBatterNameController.dispose();
    _newPitcherNameController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedResultType == null || _selectedResultDetail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('結果を選択してください')),
      );
      return;
    }

    final vm = ref.read(gameViewModelProvider.notifier);
    String batterId;
    String pitcherId;

    // Create temp batter if needed
    if (_createNewBatter) {
      if (_batterTeamId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('バッターのチームを選択してください')),
        );
        return;
      }
      final player = await vm.createTempPlayer(
        teamId: _batterTeamId!,
        displayName: _newBatterNameController.text.trim(),
      );
      if (player == null) return;
      batterId = player.id;
    } else {
      if (_selectedBatterId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('バッターを選択してください')),
        );
        return;
      }
      batterId = _selectedBatterId!;
    }

    if (!mounted) return;

    // Create temp pitcher if needed
    if (_createNewPitcher) {
      if (_pitcherTeamId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ピッチャーのチームを選択してください')),
        );
        return;
      }
      final player = await vm.createTempPlayer(
        teamId: _pitcherTeamId!,
        displayName: _newPitcherNameController.text.trim(),
      );
      if (player == null || !mounted) return;
      pitcherId = player.id;
    } else {
      if (_selectedPitcherId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ピッチャーを選択してください')),
        );
        return;
      }
      pitcherId = _selectedPitcherId!;
    }

    final inning = _inningController.text.trim().isEmpty
        ? null
        : int.tryParse(_inningController.text.trim());
    final rbi = _rbiController.text.trim().isEmpty
        ? null
        : int.tryParse(_rbiController.text.trim());

    final pa = await vm.addPlateAppearance(
      gameId: widget.gameId,
      inning: inning,
      batterPlayerId: batterId,
      pitcherPlayerId: pitcherId,
      resultType: _selectedResultType!,
      resultDetail: _selectedResultDetail!,
      rbi: rbi,
    );

    if (pa != null && mounted) {
      ref.invalidate(plateAppearancesProvider(widget.gameId));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('打席を記録した! 因縁が深まる...')),
      );
      await _showContinueDialog();
    }
  }

  Future<void> _showContinueDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('打席を登録しました'),
        content: const Text('続けてもう1打席入力しますか?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('完了'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('もう1打席追加'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (result == true) {
      _resetFormKeepPitcher();
    } else {
      context.pop();
    }
  }

  void _resetFormKeepPitcher() {
    setState(() {
      _inningController.clear();
      _rbiController.clear();
      _newBatterNameController.clear();
      _selectedBatterId = null;
      _selectedResultType = null;
      _selectedResultDetail = null;
      _createNewBatter = false;
      // Keep pitcher-related state: _selectedPitcherId, _createNewPitcher,
      // _newPitcherNameController, _pitcherTeamId
    });
  }

  void _showNameTemplates(
    TextEditingController controller,
    List<String> templates,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '表示名テンプレート',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ...templates.map(
              (name) => ListTile(
                title: Text(name),
                leading: const Icon(Icons.person_outline),
                onTap: () {
                  controller.text = name;
                  Navigator.pop(sheetContext);
                },
              ),
            ),
            const Gap(8),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerSelector({
    required String label,
    required String? selectedId,
    required bool createNew,
    required TextEditingController nameController,
    required String? teamId,
    required String homeTeamId,
    required String awayTeamId,
    required ValueChanged<String?> onPlayerChanged,
    required ValueChanged<bool> onCreateNewChanged,
    required ValueChanged<String?> onTeamChanged,
    required List<String> nameTemplates,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleMedium),
        const Gap(8),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: false, label: Text('既存選手')),
            ButtonSegment(value: true, label: Text('新規作成')),
          ],
          selected: {createNew},
          onSelectionChanged: (s) => onCreateNewChanged(s.first),
        ),
        const Gap(12),
        if (createNew) ...[
          // Team selector for new player
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: homeTeamId, label: const Text('ホーム')),
              ButtonSegment(value: awayTeamId, label: const Text('アウェイ')),
            ],
            selected: teamId != null ? {teamId} : {},
            onSelectionChanged: (s) => onTeamChanged(s.first),
            emptySelectionAllowed: true,
          ),
          const Gap(12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: '$label名',
                    prefixIcon: const Icon(Icons.person_add_outlined),
                  ),
                  validator: (value) {
                    if (createNew && (value == null || value.trim().isEmpty)) {
                      return '名前を入力してください';
                    }
                    return null;
                  },
                ),
              ),
              const Gap(8),
              IconButton.filled(
                onPressed: () =>
                    _showNameTemplates(nameController, nameTemplates),
                icon: const Icon(Icons.list_alt),
                tooltip: 'テンプレートから選択',
              ),
            ],
          ),
        ] else ...[
          // Team selector for existing player
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: homeTeamId, label: const Text('ホーム')),
              ButtonSegment(value: awayTeamId, label: const Text('アウェイ')),
            ],
            selected: teamId != null ? {teamId} : {},
            onSelectionChanged: (s) {
              onTeamChanged(s.first);
              onPlayerChanged(null);
            },
            emptySelectionAllowed: true,
          ),
          const Gap(12),
          if (teamId != null)
            Consumer(
              builder: (context, ref, _) {
                final playersAsync =
                    ref.watch(playersForTeamProvider(teamId));
                return playersAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('エラー: $e'),
                  data: (players) => DropdownButtonFormField<String>(
                    initialValue: selectedId,
                    decoration: InputDecoration(
                      labelText: '$labelを選択',
                      prefixIcon: const Icon(Icons.person_outlined),
                    ),
                    items: players
                        .map((p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(
                                '${p.displayName}${p.isTemp ? " (仮)" : ""}',
                              ),
                            ))
                        .toList(),
                    onChanged: onPlayerChanged,
                  ),
                );
              },
            ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameViewModelProvider);
    final gameAsync = ref.watch(gameDetailProvider(widget.gameId));
    final theme = Theme.of(context);

    ref.listen(gameViewModelProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('打席入力')),
      body: gameAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('エラー: $e')),
        data: (game) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Inning (optional)
                TextFormField(
                  controller: _inningController,
                  decoration: const InputDecoration(
                    labelText: 'イニング（任意）',
                    prefixIcon: Icon(Icons.format_list_numbered),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const Gap(24),

                // Batter selector
                _buildPlayerSelector(
                  label: 'バッター',
                  selectedId: _selectedBatterId,
                  createNew: _createNewBatter,
                  nameController: _newBatterNameController,
                  teamId: _batterTeamId,
                  homeTeamId: game.homeTeamId,
                  awayTeamId: game.awayTeamId,
                  onPlayerChanged: (v) =>
                      setState(() => _selectedBatterId = v),
                  onCreateNewChanged: (v) => setState(() {
                    _createNewBatter = v;
                    _selectedBatterId = null;
                  }),
                  onTeamChanged: (v) =>
                      setState(() => _batterTeamId = v),
                  nameTemplates: _batterNameTemplates,
                ),
                const Gap(24),

                // Pitcher selector
                _buildPlayerSelector(
                  label: 'ピッチャー',
                  selectedId: _selectedPitcherId,
                  createNew: _createNewPitcher,
                  nameController: _newPitcherNameController,
                  teamId: _pitcherTeamId,
                  homeTeamId: game.homeTeamId,
                  awayTeamId: game.awayTeamId,
                  onPlayerChanged: (v) =>
                      setState(() => _selectedPitcherId = v),
                  onCreateNewChanged: (v) => setState(() {
                    _createNewPitcher = v;
                    _selectedPitcherId = null;
                  }),
                  onTeamChanged: (v) =>
                      setState(() => _pitcherTeamId = v),
                  nameTemplates: _pitcherNameTemplates,
                ),
                const Gap(24),

                // Result type
                Text('結果タイプ', style: theme.textTheme.titleMedium),
                const Gap(8),
                Wrap(
                  spacing: 8,
                  children: _resultTypeOptions.map((option) {
                    final (value, label) = option;
                    final selected = _selectedResultType == value;
                    return ChoiceChip(
                      label: Text(label),
                      selected: selected,
                      onSelected: (s) {
                        setState(() {
                          _selectedResultType = s ? value : null;
                          _selectedResultDetail = null;
                        });
                      },
                    );
                  }).toList(),
                ),
                const Gap(16),

                // Result detail
                if (_selectedResultType != null) ...[
                  Text('結果詳細', style: theme.textTheme.titleMedium),
                  const Gap(8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        (_resultDetailMap[_selectedResultType] ?? [])
                            .map((option) {
                      final (value, label) = option;
                      final selected = _selectedResultDetail == value;
                      return ChoiceChip(
                        label: Text(label),
                        selected: selected,
                        onSelected: (s) {
                          setState(
                            () => _selectedResultDetail =
                                s ? value : null,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const Gap(16),
                ],

                // RBI (optional)
                TextFormField(
                  controller: _rbiController,
                  decoration: const InputDecoration(
                    labelText: '打点（任意）',
                    prefixIcon: Icon(Icons.scoreboard_outlined),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const Gap(32),

                FilledButton(
                  onPressed: state.isLoading ? null : _onSubmit,
                  child: state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('登録する'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
