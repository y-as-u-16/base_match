import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routing/app_router.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _initialize();
  }

  Future<void> _initialize() async {
    // MVP1 はローカル専用。外部サービス初期化は行わない。
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    // アプリ初期化完了フラグをONにする → ルーターがホームへ遷移させる
    ref.read(isInitializedProvider.notifier).state = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4332),
      body: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Image.asset('assets/splash.png', width: 200, height: 200),
        ),
      ),
    );
  }
}
