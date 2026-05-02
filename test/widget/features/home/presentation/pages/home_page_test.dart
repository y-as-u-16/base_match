import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/theme/app_theme.dart';
import 'package:base_match/features/home/presentation/pages/home_page.dart';

void main() {
  Widget buildSubject() {
    return ProviderScope(
      child: MaterialApp(theme: AppTheme.light, home: const HomePage()),
    );
  }

  group('HomePage', () {
    testWidgets('ローカル記録の主要導線が表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('base_match'), findsOneWidget);
      expect(find.text('ローカル記録'), findsOneWidget);
      expect(find.text('試合を記録する'), findsOneWidget);
      expect(find.text('成績を見る'), findsOneWidget);
    });

    testWidgets('試合がない場合の空状態が表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('直近の試合'), findsOneWidget);
      expect(find.text('まだ試合がありません。最初の試合を記録してください。'), findsOneWidget);
    });
  });
}
