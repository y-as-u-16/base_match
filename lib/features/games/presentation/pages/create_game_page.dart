import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../view_models/game_view_model.dart';

class CreateGamePage extends ConsumerStatefulWidget {
  const CreateGamePage({super.key});

  @override
  ConsumerState<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends ConsumerState<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();
  final _homeTeamController = TextEditingController();
  final _awayTeamController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _selectedInnings = 7;
  int? _gameNumber;

  static const _inningsOptions = [3, 5, 7, 9];

  @override
  void dispose() {
    _homeTeamController.dispose();
    _awayTeamController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _onCreate() {
    if (!_formKey.currentState!.validate()) return;

    final game = ref
        .read(localGameStoreProvider.notifier)
        .createGame(
          date: _selectedDate,
          homeTeamName: _homeTeamController.text.trim(),
          awayTeamName: _awayTeamController.text.trim(),
          location: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
          innings: _selectedInnings,
          gameNumber: _gameNumber,
        );
    context.go('/games/${game.id}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Scaffold(
      appBar: AppBar(title: const Text('試合を作成')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text('試合日'),
                subtitle: Text(dateFormat.format(_selectedDate)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickDate,
              ),
              const Gap(16),
              TextFormField(
                controller: _homeTeamController,
                decoration: const InputDecoration(
                  labelText: '自チーム名',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'チーム名を入力してください'
                    : null,
              ),
              const Gap(16),
              TextFormField(
                controller: _awayTeamController,
                decoration: const InputDecoration(
                  labelText: '相手チーム名',
                  prefixIcon: Icon(Icons.groups_outlined),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? '相手チーム名を入力してください'
                    : null,
              ),
              const Gap(16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: '球場（任意）',
                  prefixIcon: Icon(Icons.stadium_outlined),
                ),
              ),
              const Gap(24),
              Text('イニング数', style: theme.textTheme.titleMedium),
              const Gap(8),
              SegmentedButton<int>(
                segments: _inningsOptions
                    .map((i) => ButtonSegment(value: i, label: Text('$i回')))
                    .toList(),
                selected: {_selectedInnings},
                onSelectionChanged: (selected) {
                  setState(() => _selectedInnings = selected.first);
                },
              ),
              const Gap(24),
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
                    final value = selected.first;
                    _gameNumber = value == 0 ? null : value;
                  });
                },
              ),
              const Gap(32),
              FilledButton(onPressed: _onCreate, child: const Text('作成する')),
            ],
          ),
        ),
      ),
    );
  }
}
