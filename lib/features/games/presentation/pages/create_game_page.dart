import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/my_team.dart';
import 'teams_page.dart';
import '../view_models/game_view_model.dart';
import '../view_models/my_team_view_model.dart';

class CreateGamePage extends ConsumerStatefulWidget {
  const CreateGamePage({super.key});

  @override
  ConsumerState<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends ConsumerState<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();
  final _awayTeamController = TextEditingController();
  final _locationController = TextEditingController();
  final _homeScoreController = TextEditingController(text: '0');
  final _awayScoreController = TextEditingController(text: '0');
  DateTime _selectedDate = DateTime.now();
  int _selectedInnings = 7;
  String? _selectedMyTeamId;

  static const _inningsOptions = [3, 5, 7, 9];

  @override
  void dispose() {
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

    final selectedMyTeamId = _effectiveSelectedMyTeamId(
      ref.read(myTeamsProvider),
    );
    if (selectedMyTeamId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).selectMyTeamRequired),
        ),
      );
      return;
    }

    final homeScore = int.parse(_homeScoreController.text.trim());
    final awayScore = int.parse(_awayScoreController.text.trim());
    final game = await ref
        .read(localGameStoreProvider.notifier)
        .createGame(
          date: _selectedDate,
          myTeamId: selectedMyTeamId,
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

  Future<void> _onAddMyTeam() async {
    final team = await showCreateMyTeamSheet(context);
    if (team == null || !mounted) return;

    setState(() => _selectedMyTeamId = team.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).myTeamCreatedMessage),
      ),
    );
  }

  String? _effectiveSelectedMyTeamId(List<MyTeam> teams) {
    if (teams.isEmpty) return null;
    final selectedMyTeamId = _selectedMyTeamId;
    if (selectedMyTeamId != null &&
        teams.any((team) => team.id == selectedMyTeamId)) {
      return selectedMyTeamId;
    }
    return teams.where((team) => team.isDefault).firstOrNull?.id ??
        teams.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');
    final l10n = AppLocalizations.of(context);
    final myTeams = ref.watch(myTeamsProvider);
    final selectedMyTeamId = _effectiveSelectedMyTeamId(myTeams);

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
              myTeams.isEmpty
                  ? _EmptyMyTeamSelector(onCreate: _onAddMyTeam)
                  : _MyTeamSelector(
                      teams: myTeams,
                      selectedTeamId: selectedMyTeamId,
                      onChanged: (value) {
                        setState(() => _selectedMyTeamId = value);
                      },
                      onCreate: _onAddMyTeam,
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

class _MyTeamSelector extends StatelessWidget {
  const _MyTeamSelector({
    required this.teams,
    required this.selectedTeamId,
    required this.onChanged,
    required this.onCreate,
  });

  final List<MyTeam> teams;
  final String? selectedTeamId;
  final ValueChanged<String?> onChanged;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          key: ValueKey(selectedTeamId),
          initialValue: selectedTeamId,
          decoration: InputDecoration(
            labelText: l10n.myTeamSelectLabel,
            prefixIcon: const Icon(Icons.home_outlined),
          ),
          items: teams
              .map(
                (team) => DropdownMenuItem(
                  value: team.id,
                  child: Text(
                    team.isDefault
                        ? '${team.name} (${l10n.defaultMyTeamBadge})'
                        : team.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: (value) =>
              value == null ? l10n.selectMyTeamRequired : null,
        ),
        const Gap(8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: Text(l10n.addMyTeamButton),
          ),
        ),
      ],
    );
  }
}

class _EmptyMyTeamSelector extends StatelessWidget {
  const _EmptyMyTeamSelector({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.groups_outlined,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.noMyTeamsForGameTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    l10n.noMyTeamsForGameSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const Gap(12),
                  FilledButton.icon(
                    onPressed: onCreate,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addMyTeamButton),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
