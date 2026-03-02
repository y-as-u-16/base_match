import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../view_models/team_view_model.dart';

class CreateTeamPage extends ConsumerStatefulWidget {
  const CreateTeamPage({super.key});

  @override
  ConsumerState<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends ConsumerState<CreateTeamPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _areaController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _onCreate() async {
    if (!_formKey.currentState!.validate()) return;

    final team = await ref.read(teamViewModelProvider.notifier).createTeam(
          name: _nameController.text.trim(),
          area: _areaController.text.trim().isEmpty
              ? null
              : _areaController.text.trim(),
        );

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
      appBar: AppBar(title: const Text('チームを作成')),
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
                  Icons.groups,
                  size: 36,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const Gap(8),
              Text(
                '新しいチームを作成',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(28),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'チーム名',
                  prefixIcon: Icon(Icons.groups_outlined),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'チーム名を入力してください';
                  }
                  return null;
                },
              ),
              const Gap(16),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(
                  labelText: '活動エリア（任意）',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onCreate(),
              ),
              const Gap(8),
              Text(
                '招待コードはチーム作成後に自動生成されます',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(24),
              FilledButton(
                onPressed: state.isLoading ? null : _onCreate,
                child: state.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('作成する'),
              ),
              const Gap(16),
              OutlinedButton(
                onPressed: () => context.go('/teams/join'),
                child: const Text('招待コードで参加する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
