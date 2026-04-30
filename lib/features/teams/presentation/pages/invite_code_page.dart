import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/team.dart';
import '../view_models/team_view_model.dart';

// 招待コード発行ページ
class InviteCodePage extends ConsumerStatefulWidget {
  const InviteCodePage({super.key});

  @override
  ConsumerState<InviteCodePage> createState() => _InviteCodePageState();
}

class _InviteCodePageState extends ConsumerState<InviteCodePage> {
  final _formKey = GlobalKey<FormState>();
  Team? _selectedTeam;
  String? _generatedCode;

  @override
  Widget build(BuildContext context) {
    final myTeamsAsync = ref.watch(myTeamsProvider);
    final viewModelState = ref.watch(teamViewModelProvider);
    final theme = Theme.of(context);

    ref.listen(teamViewModelProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('招待コードの発行に失敗しました')),
        );
      } else if (prev?.isLoading == true && !next.isLoading && !next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('招待コードを発行しました')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('招待コード発行')),
      body: myTeamsAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => AppErrorWidget(
          message: 'チーム情報の読み込みに失敗しました',
          onRetry: () => ref.invalidate(myTeamsProvider),
        ),
        data: (teams) => SingleChildScrollView(
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
                const Gap(8),
                Text(
                  '招待コードを発行',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Gap(8),
                Text(
                  'チームメンバーを招待するためのコードを生成します',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Gap(28),
                DropdownButtonFormField<Team>(
                  initialValue: _selectedTeam,
                  decoration: const InputDecoration(
                    labelText: 'チームを選択',
                    prefixIcon: Icon(Icons.groups_outlined),
                  ),
                  items: teams.map((team) {
                    return DropdownMenuItem(
                      value: team,
                      child: Text(team.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTeam = value;
                      _generatedCode = null; // Reset code when team changes
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'チームを選択してください';
                    }
                    return null;
                  },
                ),
                const Gap(24),
                if (_generatedCode != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            '招待コード',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const Gap(8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _generatedCode!,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 3,
                                ),
                              ),
                              const Gap(8),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 20),
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: _generatedCode!),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('招待コードをコピーしました'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(24),
                ],
                FilledButton(
                  onPressed: viewModelState.isLoading || _selectedTeam == null
                      ? null
                      : _onGenerate,
                  child: viewModelState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('発行する'),
                ),
                const Gap(16),
                OutlinedButton(
                  onPressed: () => context.pop(),
                  child: const Text('完了'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onGenerate() async {
    if (!_formKey.currentState!.validate()) return;

    final code = await ref
        .read(teamViewModelProvider.notifier)
        .regenerateInviteCode(_selectedTeam!.id);

    if (code != null && mounted) {
      setState(() {
        _generatedCode = code;
      });
    }
  }
}