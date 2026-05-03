import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    group('color constants', () {
      test('fieldGreen が期待した値である', () {
        expect(AppTheme.fieldGreen, const Color(0xFF1B4332));
      });

      test('leatherBrown が期待した値である', () {
        expect(AppTheme.leatherBrown, const Color(0xFF5C4033));
      });

      test('stitchRed が期待した値である', () {
        expect(AppTheme.stitchRed, const Color(0xFFC62828));
      });

      test('baseWhite が期待した値である', () {
        expect(AppTheme.baseWhite, const Color(0xFFFFF8F0));
      });

      test('trophyGold が期待した値である', () {
        expect(AppTheme.trophyGold, const Color(0xFFD4A017));
      });
    });

    group('light theme', () {
      late ThemeData theme;

      setUp(() {
        theme = AppTheme.light;
      });

      test('ライトテーマとして生成される', () {
        expect(theme, isNotNull);
        expect(theme.brightness, Brightness.light);
      });

      test('Material 3 を使用する', () {
        expect(theme.useMaterial3, isTrue);
      });

      test('AppBar は緑の背景と白い前景色を使用する', () {
        expect(theme.appBarTheme.backgroundColor, AppTheme.fieldGreen);
        expect(theme.appBarTheme.foregroundColor, Colors.white);
      });

      test('AppBar のタイトルを中央寄せにする', () {
        expect(theme.appBarTheme.centerTitle, isTrue);
      });

      test('AppBar のタイトル文字色に白を使用する', () {
        expect(theme.appBarTheme.titleTextStyle?.color, Colors.white);
      });
    });

    group('dark theme', () {
      late ThemeData theme;

      setUp(() {
        theme = AppTheme.dark;
      });

      test('ダークテーマとして生成される', () {
        expect(theme, isNotNull);
        expect(theme.brightness, Brightness.dark);
      });

      test('Material 3 を使用する', () {
        expect(theme.useMaterial3, isTrue);
      });

      test('AppBar のタイトルを中央寄せにする', () {
        expect(theme.appBarTheme.centerTitle, isTrue);
      });
    });
  });
}
