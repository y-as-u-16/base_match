import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    group('カラー定数', () {
      test('fieldGreen の値が正しい', () {
        expect(AppTheme.fieldGreen, const Color(0xFF1B4332));
      });

      test('leatherBrown の値が正しい', () {
        expect(AppTheme.leatherBrown, const Color(0xFF5C4033));
      });

      test('stitchRed の値が正しい', () {
        expect(AppTheme.stitchRed, const Color(0xFFC62828));
      });

      test('baseWhite の値が正しい', () {
        expect(AppTheme.baseWhite, const Color(0xFFFFF8F0));
      });

      test('trophyGold の値が正しい', () {
        expect(AppTheme.trophyGold, const Color(0xFFD4A017));
      });
    });

    group('ライトテーマ', () {
      late ThemeData theme;

      setUp(() {
        theme = AppTheme.light;
      });

      test('正常に生成される', () {
        expect(theme, isNotNull);
        expect(theme.brightness, Brightness.light);
      });

      test('Material 3 が有効である', () {
        expect(theme.useMaterial3, isTrue);
      });

      test('AppBar が緑背景・白文字である', () {
        expect(theme.appBarTheme.backgroundColor, AppTheme.fieldGreen);
        expect(theme.appBarTheme.foregroundColor, Colors.white);
      });

      test('AppBar のタイトルが中央寄せである', () {
        expect(theme.appBarTheme.centerTitle, isTrue);
      });

      test('AppBar のタイトルテキストスタイルが白色である', () {
        expect(theme.appBarTheme.titleTextStyle?.color, Colors.white);
      });
    });

    group('ダークテーマ', () {
      late ThemeData theme;

      setUp(() {
        theme = AppTheme.dark;
      });

      test('正常に生成される', () {
        expect(theme, isNotNull);
        expect(theme.brightness, Brightness.dark);
      });

      test('Material 3 が有効である', () {
        expect(theme.useMaterial3, isTrue);
      });

      test('AppBar のタイトルが中央寄せである', () {
        expect(theme.appBarTheme.centerTitle, isTrue);
      });
    });
  });
}
