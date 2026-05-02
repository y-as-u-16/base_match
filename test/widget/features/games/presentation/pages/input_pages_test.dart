import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/theme/app_theme.dart';
import 'package:base_match/features/games/presentation/pages/pitching_input_page.dart';
import 'package:base_match/features/games/presentation/pages/plate_appearance_input_page.dart';

void main() {
  group('PlateAppearanceInputPage', () {
    testWidgets('打席結果を選び、イニングと打点をボタンで変更できる', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: PlateAppearanceInputPage(gameId: 'game-1')),
        ),
      );

      expect(find.text('打席入力'), findsOneWidget);
      expect(find.text('1回 / 未選択 / 打点 0'), findsOneWidget);
      expect(find.text('単打'), findsOneWidget);
      expect(find.text('三振'), findsOneWidget);

      await tester.tap(find.byTooltip('イニングを増やす'));
      await tester.tap(find.byTooltip('打点を増やす'));
      await tester.tap(find.widgetWithText(ChoiceChip, '単打'));
      await tester.pumpAndSettle();

      expect(find.text('2回 / 単打 / 打点 1'), findsOneWidget);
    });
  });

  group('PitchingInputPage', () {
    testWidgets('投球回と投手成績をボタンで変更できる', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light,
            home: const PitchingInputPage(gameId: 'game-1'),
          ),
        ),
      );

      expect(find.text('ピッチング入力'), findsOneWidget);
      expect(find.text('投球回 1回 / 失点 0 / 自責 0'), findsOneWidget);
      expect(find.text('3 アウト'), findsOneWidget);

      await tester.tap(find.byTooltip('1アウト増やす'));
      await tester.tap(find.byTooltip('失点を増やす'));
      await tester.tap(find.byTooltip('自責点を増やす'));
      await tester.pumpAndSettle();

      expect(find.text('投球回 1回1/3 / 失点 1 / 自責 1'), findsOneWidget);
      expect(find.text('4 アウト'), findsOneWidget);
    });
  });
}
