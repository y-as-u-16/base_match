import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/theme/app_theme.dart';
import 'package:base_match/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:base_match/features/home/presentation/pages/home_page.dart';
import 'package:base_match/features/home/presentation/view_models/home_view_model.dart';

void main() {
  Widget buildSubject() {
    return ProviderScope(
      overrides: [
        currentUserProvider.overrideWithValue(null),
        myTeamsForHomeProvider.overrideWith((ref) async => []),
        recentGamesProvider.overrideWith((ref) async => []),
        matchupHighlightsProvider.overrideWith((ref) async => []),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const HomePage(),
      ),
    );
  }

  group('HomePage', () {
    testWidgets('AppBarに「base_match」が表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('base_match'), findsOneWidget);
    });

    testWidgets('「試合を記録」FABが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('試合を記録'), findsOneWidget);
    });

    testWidgets('ウェルカムメッセージが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.textContaining('ようこそ'), findsOneWidget);
    });

    testWidgets('セクションヘッダーが表示される（注目の因縁・自分のチーム）', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // 上部に表示されるセクションヘッダーのみ確認
      expect(find.text('注目の因縁'), findsOneWidget);
      expect(find.text('自分のチーム'), findsOneWidget);
    });

    testWidgets('クイックアクションカードが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('因縁を見る'), findsOneWidget);
      expect(find.text('チーム作成'), findsOneWidget);
    });

    testWidgets('チームが空の場合にEmptyStateが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(
        find.text('まずはチームを作ろう。因縁はそこから始まる。'),
        findsOneWidget,
      );
    });

    testWidgets('スクロールすると「直近の試合」セクションが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // ListViewをスクロールして下部の要素を表示
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      expect(find.text('直近の試合'), findsOneWidget);
    });
  });
}
