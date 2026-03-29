import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const env = String.fromEnvironment('ENV', defaultValue: 'local');
  final envFile = env == 'release' ? '.env' : '.env.local';
  await dotenv.load(fileName: envFile);

  var supabaseUrl = dotenv.env['SUPABASE_URL']!;

  // ローカル開発時、Androidエミュレータでは 127.0.0.1 でホストPCに
  // アクセスできないため、10.0.2.2 に自動変換する
  if (env == 'local' && Platform.isAndroid) {
    supabaseUrl = supabaseUrl.replaceAll('127.0.0.1', '10.0.2.2');
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const ProviderScope(child: BaseMatchApp()));
}

class BaseMatchApp extends ConsumerWidget {
  const BaseMatchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: '草野球マッチ',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
