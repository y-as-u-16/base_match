import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../view_models/auth_view_model.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authViewModelProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final theme = Theme.of(context);

    ref.listen(authViewModelProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.4, 1.0],
            colors: [
              AppTheme.fieldGreen,
              AppTheme.fieldGreen.withValues(alpha: 0.6),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hero section -- 野球ボール + 縫い目パターン背景
                    Center(
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: CustomPaint(
                          painter: _BaseballStitchPainter(
                            color: AppTheme.stitchRed.withValues(alpha: 0.15),
                          ),
                          child: Center(
                            child: Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.fieldGreen,
                                    AppTheme.fieldGreen.withValues(alpha: 0.8),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.fieldGreen
                                        .withValues(alpha: 0.4),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.sports_baseball,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Text(
                      'base_match',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        color: Colors.white,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      'あいつとの因縁、忘れてないか?',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(44),

                    // Form fields
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'メールアドレス',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'メールアドレスを入力してください';
                        }
                        return null;
                      },
                    ),
                    const Gap(16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'パスワード',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(
                                () => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _onLogin(),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'パスワードは6文字以上で入力してください';
                        }
                        return null;
                      },
                    ),
                    const Gap(28),

                    // Login button（野球配色）
                    FilledButton(
                      onPressed: authState.isLoading ? null : _onLogin,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.stitchRed,
                        foregroundColor: Colors.white,
                      ),
                      child: authState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('ログイン'),
                    ),
                    const Gap(12),
                    TextButton(
                      onPressed: () => context.go('/sign-up'),
                      child: const Text('アカウントを作成する'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 野球ボールの縫い目パターンを描画するカスタムペインター
class _BaseballStitchPainter extends CustomPainter {
  _BaseballStitchPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    // 左側の縫い目カーブ
    for (int i = 0; i < 6; i++) {
      final angle = -math.pi / 3 + (i * math.pi / 9);
      final x1 = centerX + radius * 0.6 * math.cos(angle + math.pi);
      final y1 = centerY + radius * 0.8 * math.sin(angle + math.pi);
      final x2 = centerX + radius * 0.8 * math.cos(angle + math.pi);
      final y2 = centerY + radius * 0.6 * math.sin(angle + math.pi);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }

    // 右側の縫い目カーブ
    for (int i = 0; i < 6; i++) {
      final angle = -math.pi / 3 + (i * math.pi / 9);
      final x1 = centerX + radius * 0.6 * math.cos(angle);
      final y1 = centerY + radius * 0.8 * math.sin(angle);
      final x2 = centerX + radius * 0.8 * math.cos(angle);
      final y2 = centerY + radius * 0.6 * math.sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BaseballStitchPainter oldDelegate) =>
      color != oldDelegate.color;
}
