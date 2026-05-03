import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/my_team.dart';
import '../view_models/my_team_view_model.dart';

Future<MyTeam?> showCreateMyTeamSheet(BuildContext context) {
  return showModalBottomSheet<MyTeam>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const _CreateMyTeamSheet(),
  );
}

class TeamsPage extends ConsumerWidget {
  const TeamsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(myTeamsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myTeamsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTeamSheetWithMessage(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.addMyTeamButton),
      ),
      body: teams.isEmpty
          ? _EmptyMyTeams(
              onCreate: () => _showCreateTeamSheetWithMessage(context),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: teams.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final team = teams[index];
                return _MyTeamCard(team: team);
              },
            ),
    );
  }

  Future<void> _showCreateTeamSheetWithMessage(BuildContext context) async {
    final created = await showCreateMyTeamSheet(context);
    if (created == null || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).myTeamCreatedMessage),
      ),
    );
  }
}

class _EmptyMyTeams extends StatelessWidget {
  const _EmptyMyTeams({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Icon(
                      Icons.groups_outlined,
                      color: colorScheme.onPrimaryContainer,
                      size: 34,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.emptyMyTeamsTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.emptyMyTeamsSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onCreate,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addMyTeamButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MyTeamCard extends StatelessWidget {
  const _MyTeamCard({required this.team});

  final MyTeam team;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  Icons.shield_outlined,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (team.isDefault) ...[
                    const SizedBox(height: 8),
                    _DefaultTeamBadge(label: l10n.defaultMyTeamBadge),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DefaultTeamBadge extends StatelessWidget {
  const _DefaultTeamBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onTertiaryContainer,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _CreateMyTeamSheet extends ConsumerStatefulWidget {
  const _CreateMyTeamSheet();

  @override
  ConsumerState<_CreateMyTeamSheet> createState() => _CreateMyTeamSheetState();
}

class _CreateMyTeamSheetState extends ConsumerState<_CreateMyTeamSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  var _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final team = await ref
          .read(myTeamStoreProvider.notifier)
          .createMyTeam(name: _nameController.text);
      if (!mounted) return;
      Navigator.of(context).pop(team);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, bottomInset + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const SizedBox(width: 40, height: 4),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.addMyTeamTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                onPressed: _isSaving
                    ? null
                    : () => Navigator.of(context).pop(false),
                icon: const Icon(Icons.close),
                tooltip: l10n.cancelButton,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.myTeamNameLabel),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                if (!_isSaving) _submit();
              },
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.myTeamNameRequired
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSaving
                      ? null
                      : () => Navigator.of(context).pop(false),
                  child: Text(l10n.cancelButton),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: _isSaving ? null : _submit,
                  child: Text(l10n.addButton),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
