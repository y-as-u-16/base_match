import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../view_models/team_view_model.dart';

class JoinTeamPage extends ConsumerStatefulWidget {
  const JoinTeamPage({super.key});

  @override
  ConsumerState<JoinTeamPage> createState() => _JoinTeamPageState();
}

class _JoinTeamPageState extends ConsumerState<JoinTeamPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onJoin() async {
    if (!_formKey.currentState!.validate()) return;

    final team = await ref
        .read(teamViewModelProvider.notifier)
        .joinTeamByInviteCode(_codeController.text.trim());

    if (team != null && mounted) {
      ref.invalidate(myTeamsProvider);
      context.go('/teams/${team.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teamViewModelProvider);
    final theme = Theme.of(context);

    ref.listen(teamViewModelProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('チームに参加')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.group_add,
                  size: 36,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const Gap(12),
              Text(
                'チームメンバーから共有された\n招待コードを入力してください',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(28),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: '招待コード',
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                ),
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onJoin(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '招待コードを入力してください';
                  }
                  return null;
                },
              ),
              const Gap(24),
              FilledButton(
                onPressed: state.isLoading ? null : _onJoin,
                child: state.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('参加する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
