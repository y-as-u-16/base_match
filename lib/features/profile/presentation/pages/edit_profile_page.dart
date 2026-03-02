import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/view_models/auth_view_model.dart';
import '../view_models/profile_view_model.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _photoUrlController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    await ref.read(profileUpdateProvider.notifier).updateProfile(
          userId: currentUser.id,
          displayName: _displayNameController.text.trim(),
          photoUrl: _photoUrlController.text.trim().isEmpty
              ? null
              : _photoUrlController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final updateState = ref.watch(profileUpdateProvider);
    final theme = Theme.of(context);

    profileAsync.whenData((profile) {
      if (profile != null && !_initialized) {
        _displayNameController.text = profile.displayName;
        _photoUrlController.text = profile.photoUrl ?? '';
        _initialized = true;
      }
    });

    ref.listen(profileUpdateProvider, (prev, next) {
      if (next.isSuccess) {
        ref.invalidate(profileProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('プロフィールを更新しました')),
        );
        context.pop();
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール編集'),
      ),
      body: profileAsync.when(
        loading: () => const LoadingWidget(),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('ログインしてください'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: theme.colorScheme.surface,
                        backgroundImage: profile.photoUrl != null
                            ? NetworkImage(profile.photoUrl!)
                            : null,
                        child: profile.photoUrl == null
                            ? Icon(
                                Icons.person,
                                size: 48,
                                color: theme.colorScheme.onSurfaceVariant,
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      labelText: '表示名',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '表示名を入力してください';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _photoUrlController,
                    decoration: InputDecoration(
                      labelText: '写真URL',
                      prefixIcon: const Icon(Icons.image_outlined),
                      helperText: 'プロフィール画像のURLを入力',
                      helperStyle: theme.textTheme.bodySmall,
                    ),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onSave(),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: updateState.isLoading ? null : _onSave,
                    child: updateState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('保存'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
