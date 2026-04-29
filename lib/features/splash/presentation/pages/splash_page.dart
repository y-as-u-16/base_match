import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    // Phase 1: Supabase は任意。.env が存在し、URL/ANON_KEY が揃っている場合のみ初期化する。
    // 設定が無い場合はローカル記録モードでアプリを起動する。
    const env = String.fromEnvironment('ENV', defaultValue: 'local');
    final envFile = env == 'release' ? '.env' : '.env.local';

    try {
      await dotenv.load(fileName: envFile);
    } catch (e) {
      // .env ファイルが無くても起動を続行する
      debugPrint('[SplashPage] $envFile が見つかりません。ローカル記録モードで起動します: $e');
    }

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl != null &&
        supabaseUrl.isNotEmpty &&
        supabaseAnonKey != null &&
        supabaseAnonKey.isNotEmpty) {
      var url = supabaseUrl;

      // ローカル開発時、Androidエミュレータでは 127.0.0.1 でホストPCに
      // アクセスできないため、10.0.2.2 に自動変換する
      if (env == 'local' && Platform.isAndroid) {
        url = url.replaceAll('127.0.0.1', '10.0.2.2');
      }

      try {
        await Supabase.initialize(url: url, anonKey: supabaseAnonKey);
      } catch (e) {
        debugPrint('[SplashPage] Supabase 初期化に失敗。ローカル記録モードで起動します: $e');
      }
    } else {
      debugPrint('[SplashPage] SUPABASE_URL / SUPABASE_ANON_KEY が未設定。ローカル記録モードで起動します。');
    }

    // 最低1.5秒はスプラッシュを表示
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
          child: Image.asset(
            'assets/splash.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
