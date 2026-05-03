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
