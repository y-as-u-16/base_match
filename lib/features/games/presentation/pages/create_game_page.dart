import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../teams/presentation/view_models/team_view_model.dart';
import '../view_models/game_view_model.dart';

class CreateGamePage extends ConsumerStatefulWidget {
  const CreateGamePage({super.key, required this.teamId});

  final String teamId;

  @override
  ConsumerState<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends ConsumerState<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _awayTeamNameController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedAwayTeamId;
  bool _createNewAwayTeam = false;

  int _selectedInnings = 7;
  int? _gameNumber;

  static const _inningsOptions = [3, 5, 7, 9];

  @override
  void dispose() {
    _locationController.dispose();
    _awayTeamNameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _onCreate() async {
    if (!_formKey.currentState!.validate()) return;

    String awayTeamId;

    if (_createNewAwayTeam) {
      // Create a temporary away team
      final awayTeam =
          await ref.read(teamViewModelProvider.notifier).createTeam(
                name: _awayTeamNameController.text.trim(),
              );
      if (awayTeam == null) return;
      awayTeamId = awayTeam.id;
    } else {
      if (_selectedAwayTeamId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('対戦チームを選択してください')),
        );
        return;
      }
      awayTeamId = _selectedAwayTeamId!;
    }

    final game = await ref.read(gameViewModelProvider.notifier).createGame(
          date: _selectedDate,
          location: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
          homeTeamId: widget.teamId,
          awayTeamId: awayTeamId,
          innings: _selectedInnings,
          gameNumber: _gameNumber,
        );

    if (game != null && mounted) {
      ref.invalidate(gamesByTeamProvider(widget.teamId));
      context.go('/games/${game.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameViewModelProvider);
    final myTeams = ref.watch(myTeamsProvider);
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');

    ref.listen(gameViewModelProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('試合を作成')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text('試合日'),
                subtitle: Text(dateFormat.format(_selectedDate)),
                onTap: _pickDate,
                trailing: const Icon(Icons.chevron_right),
              ),
              const Gap(16),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: '球場（任意）',
                  prefixIcon: Icon(Icons.stadium_outlined),
                ),
              ),
              const Gap(24),

              // Innings selector
              Text('イニング数', style: theme.textTheme.titleMedium),
              const Gap(8),
              SegmentedButton<int>(
                segments: _inningsOptions
                    .map((i) => ButtonSegment(
                          value: i,
                          label: Text('$i回'),
                        ))
                    .toList(),
                selected: {_selectedInnings},
                onSelectionChanged: (selected) {
                  setState(() => _selectedInnings = selected.first);
                },
              ),
              const Gap(24),

              // Doubleheader (game number)
              Text('ダブルヘッダー', style: theme.textTheme.titleMedium),
              const Gap(8),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('なし')),
                  ButtonSegment(value: 1, label: Text('第1試合')),
                  ButtonSegment(value: 2, label: Text('第2試合')),
                ],
                selected: {_gameNumber ?? 0},
                onSelectionChanged: (selected) {
                  setState(() {
                    final val = selected.first;
                    _gameNumber = val == 0 ? null : val;
                  });
                },
              ),
              const Gap(24),

              // Away team selection
              Text('対戦チーム', style: theme.textTheme.titleMedium),
              const Gap(8),

              // Toggle: existing team vs new team
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: false,
                    label: Text('既存チーム'),
                  ),
                  ButtonSegment(
                    value: true,
                    label: Text('新規作成'),
                  ),
                ],
                selected: {_createNewAwayTeam},
                onSelectionChanged: (selected) {
                  setState(() {
                    _createNewAwayTeam = selected.first;
                    _selectedAwayTeamId = null;
                  });
                },
              ),
              const Gap(16),

              if (_createNewAwayTeam)
                TextFormField(
                  controller: _awayTeamNameController,
                  decoration: const InputDecoration(
                    labelText: '対戦チーム名',
                    prefixIcon: Icon(Icons.groups_outlined),
                  ),
                  validator: (value) {
                    if (_createNewAwayTeam &&
                        (value == null || value.trim().isEmpty)) {
                      return 'チーム名を入力してください';
                    }
                    return null;
                  },
                )
              else
                myTeams.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('エラー: $e'),
                  data: (teams) {
                    final otherTeams = teams
                        .where((t) => t.id != widget.teamId)
                        .toList();

                    if (otherTeams.isEmpty) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            '他のチームがありません。新規作成を選択してください。',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      );
                    }

                    return DropdownButtonFormField<String>(
                      initialValue: _selectedAwayTeamId,
                      decoration: const InputDecoration(
                        labelText: '対戦チームを選択',
                        prefixIcon: Icon(Icons.groups_outlined),
                      ),
                      items: otherTeams
                          .map((t) => DropdownMenuItem(
                                value: t.id,
                                child: Text(t.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => _selectedAwayTeamId = value);
                      },
                    );
                  },
                ),

              const Gap(32),
              FilledButton(
                onPressed: state.isLoading ? null : _onCreate,
                child: state.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('試合を作成'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
