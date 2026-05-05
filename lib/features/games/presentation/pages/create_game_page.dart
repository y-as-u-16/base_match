import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/my_team.dart';
import '../view_models/game_view_model.dart';
import '../view_models/my_team_view_model.dart';
import '../widgets/create_game_page_widgets.dart';
import '../widgets/create_my_team_sheet.dart';

class CreateGamePage extends ConsumerStatefulWidget {
  const CreateGamePage({super.key, this.initialDate});

  final DateTime? initialDate;

  @override
  ConsumerState<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends ConsumerState<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();
  final _awayTeamController = TextEditingController();
  final _locationController = TextEditingController();
  final _homeScoreController = TextEditingController(text: '0');
  final _awayScoreController = TextEditingController(text: '0');
  late DateTime _selectedDate;
  int _selectedInnings = 7;
  String? _selectedMyTeamId;

  static const _inningsOptions = [3, 5, 7, 9];

  @override
  void initState() {
    super.initState();
    final initialDate = widget.initialDate ?? DateTime.now();
    _selectedDate = DateTime(
      initialDate.year,
      initialDate.month,
      initialDate.day,
    );
  }

  @override
  void dispose() {
    _awayTeamController.dispose();
    _locationController.dispose();
    _homeScoreController.dispose();
    _awayScoreController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final minimumDate = DateTime(2000);
    final maximumDate = _dateKey(DateTime.now().add(const Duration(days: 365)));
    var selectedDate = _dateInRange(_selectedDate, minimumDate, maximumDate);

    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final materialLocalizations = MaterialLocalizations.of(context);

        return SafeArea(
          top: false,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 12, 6),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(materialLocalizations.cancelButtonLabel),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: () =>
                            Navigator.of(context).pop(selectedDate),
                        child: Text(materialLocalizations.okButtonLabel),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 216,
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      brightness: theme.brightness,
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: theme.textTheme.titleLarge
                            ?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0,
                            ),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: selectedDate,
                      minimumDate: minimumDate,
                      maximumDate: maximumDate,
                      onDateTimeChanged: (date) {
                        selectedDate = _dateKey(date);
                      },
                    ),
                  ),
                ),
                const Gap(12),
              ],
            ),
          ),
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = _dateKey(picked));
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

  DateTime _dateInRange(
    DateTime date,
    DateTime minimumDate,
    DateTime maximumDate,
  ) {
    final normalizedDate = _dateKey(date);
    if (normalizedDate.isBefore(minimumDate)) return minimumDate;
    if (normalizedDate.isAfter(maximumDate)) return maximumDate;
    return normalizedDate;
  }

  DateTime _dateKey(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');
    final l10n = AppLocalizations.of(context);
    final myTeams = ref.watch(myTeamsProvider);
    final selectedMyTeamId = _effectiveSelectedMyTeamId(myTeams);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l10n.createGameTitle),
        centerTitle: false,
        backgroundColor: colorScheme.surfaceContainerLowest,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CreateGameHeader(
                title: l10n.createGameTitle,
                dateLabel: dateFormat.format(_selectedDate),
                inningsLabel: l10n.inningsShort(_selectedInnings),
              ),
              const Gap(14),
              FormPanel(
                children: [
                  SectionHeading(
                    icon: Icons.event_available_outlined,
                    title: l10n.gameDateLabel,
                  ),
                  const Gap(10),
                  DatePickerTile(
                    label: l10n.gameDateLabel,
                    value: dateFormat.format(_selectedDate),
                    onTap: _pickDate,
                  ),
                  const Gap(20),
                  SectionHeading(
                    icon: Icons.shield_outlined,
                    title: l10n.myTeamSelectLabel,
                  ),
                  const Gap(10),
                  myTeams.isEmpty
                      ? EmptyMyTeamSelector(onCreate: _onAddMyTeam)
                      : MyTeamSelector(
                          teams: myTeams,
                          selectedTeamId: selectedMyTeamId,
                          onChanged: (value) {
                            setState(() => _selectedMyTeamId = value);
                          },
                          onCreate: _onAddMyTeam,
                        ),
                  const Gap(20),
                  SectionHeading(
                    icon: Icons.groups_outlined,
                    title: l10n.awayTeamNameLabel,
                  ),
                  const Gap(10),
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
                  const Gap(14),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: l10n.locationOptionalLabel,
                      prefixIcon: const Icon(Icons.stadium_outlined),
                    ),
                  ),
                  const Gap(20),
                  SectionHeading(
                    icon: Icons.scoreboard_outlined,
                    title: '${l10n.homeScoreLabel} / ${l10n.awayScoreLabel}',
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _homeScoreController,
                          decoration: InputDecoration(
                            labelText: l10n.homeScoreLabel,
                            prefixIcon: const Icon(Icons.home_outlined),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: _scoreValidator,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: TextFormField(
                          controller: _awayScoreController,
                          decoration: InputDecoration(
                            labelText: l10n.awayScoreLabel,
                            prefixIcon: const Icon(Icons.flag_outlined),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: _scoreValidator,
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  SectionHeading(
                    icon: Icons.view_timeline_outlined,
                    title: l10n.inningsCountLabel,
                  ),
                  const Gap(10),
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
                ],
              ),
              const Gap(18),
              FilledButton(
                onPressed: _onCreate,
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
