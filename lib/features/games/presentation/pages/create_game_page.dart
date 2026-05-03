import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/generated/app_localizations.dart';
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
  final _homeScoreController = TextEditingController(text: '0');
  final _awayScoreController = TextEditingController(text: '0');
  DateTime _selectedDate = DateTime.now();
  int _selectedInnings = 7;

  static const _inningsOptions = [3, 5, 7, 9];

  @override
  void dispose() {
    _homeTeamController.dispose();
    _awayTeamController.dispose();
    _locationController.dispose();
    _homeScoreController.dispose();
    _awayScoreController.dispose();
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

  Future<void> _onCreate() async {
    if (!_formKey.currentState!.validate()) return;

    final homeScore = int.parse(_homeScoreController.text.trim());
    final awayScore = int.parse(_awayScoreController.text.trim());
    final game = await ref
        .read(localGameStoreProvider.notifier)
        .createGame(
          date: _selectedDate,
          homeTeamName: _homeTeamController.text.trim(),
          awayTeamName: _awayTeamController.text.trim(),
          location: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
          innings: _selectedInnings,
          homeScore: homeScore,
          awayScore: awayScore,
        );
    if (!mounted) return;
    context.go('/games/${game.id}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createGameTitle)),
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
                title: Text(l10n.gameDateLabel),
                subtitle: Text(dateFormat.format(_selectedDate)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickDate,
              ),
              const Gap(16),
              TextFormField(
                controller: _homeTeamController,
                decoration: InputDecoration(
                  labelText: l10n.homeTeamNameLabel,
                  prefixIcon: const Icon(Icons.home_outlined),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.homeTeamNameRequired
                    : null,
              ),
              const Gap(16),
              TextFormField(
                controller: _awayTeamController,
                decoration: InputDecoration(
                  labelText: l10n.awayTeamNameLabel,
                  prefixIcon: const Icon(Icons.groups_outlined),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.awayTeamNameRequired
                    : null,
              ),
              const Gap(16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _homeScoreController,
                      decoration: InputDecoration(
                        labelText: l10n.homeScoreLabel,
                        prefixIcon: const Icon(Icons.scoreboard_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _scoreValidator,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: TextFormField(
                      controller: _awayScoreController,
                      decoration: InputDecoration(
                        labelText: l10n.awayScoreLabel,
                        prefixIcon: const Icon(Icons.scoreboard_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _scoreValidator,
                    ),
                  ),
                ],
              ),
              const Gap(16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: l10n.locationOptionalLabel,
                  prefixIcon: const Icon(Icons.stadium_outlined),
                ),
              ),
              const Gap(24),
              Text(l10n.inningsCountLabel, style: theme.textTheme.titleMedium),
              const Gap(8),
              SegmentedButton<int>(
                segments: _inningsOptions
                    .map(
                      (i) => ButtonSegment(
                        value: i,
                        label: Text(l10n.inningsShort(i)),
                      ),
                    )
                    .toList(),
                selected: {_selectedInnings},
                onSelectionChanged: (selected) {
                  setState(() => _selectedInnings = selected.first);
                },
              ),
              const Gap(32),
              FilledButton(
                onPressed: _onCreate,
                child: Text(l10n.createButton),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _scoreValidator(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return AppLocalizations.of(context).scoreRequired;
    final score = int.tryParse(text);
    if (score == null || score < 0) {
      return AppLocalizations.of(context).scoreMustBeNonNegative;
    }
    return null;
  }
}
