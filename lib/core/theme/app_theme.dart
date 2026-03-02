import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // -- 野球テーマ カラーパレット --
  // 球場の芝（深い緑）
  static const _fieldGreen = Color(0xFF1B4332);
  // グローブ・バットの革（ディープブラウン）
  static const _leatherBrown = Color(0xFF5C4033);
  // 野球ボールの縫い目（レッド）
  static const _stitchRed = Color(0xFFC62828);
  // ベースの白（オフホワイト）
  static const _baseWhite = Color(0xFFFFF8F0);
  // トロフィー・ゴールド
  static const _trophyGold = Color(0xFFD4A017);

  // -- Light Theme --
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _fieldGreen,
      secondary: _leatherBrown,
      tertiary: _stitchRed,
      surface: _baseWhite,
      brightness: Brightness.light,
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  // -- Dark Theme --
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _fieldGreen,
      secondary: _leatherBrown,
      tertiary: _stitchRed,
      brightness: Brightness.dark,
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final isLight = brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // -- AppBar（球場の電光掲示板風） --
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: isLight ? _fieldGreen : colorScheme.surface,
        foregroundColor: isLight ? Colors.white : colorScheme.onSurface,
        elevation: 2,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.3),
        scrolledUnderElevation: 3,
        titleTextStyle: TextStyle(
          color: isLight ? Colors.white : colorScheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
      ),

      // -- Card（野球カード風） --
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
      ),

      // -- Input --
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // -- FilledButton（太めフォント、やや丸み） --
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // -- ElevatedButton --
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // -- OutlinedButton --
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide(color: colorScheme.outline),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // -- TextButton --
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // -- Chip --
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // -- ListTile --
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),

      // -- Divider --
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        space: 1,
        thickness: 1,
      ),

      // -- SnackBar --
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // -- Dialog --
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // -- TabBar --
      tabBarTheme: TabBarThemeData(
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),

      // -- NavigationBar (Bottom) --
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: _stitchRed.withValues(alpha: 0.15),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: _stitchRed);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: _stitchRed,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          );
        }),
      ),

      // -- SegmentedButton --
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // テーマカラーをアプリ全体で参照するための定数
  static const Color fieldGreen = _fieldGreen;
  static const Color leatherBrown = _leatherBrown;
  static const Color stitchRed = _stitchRed;
  static const Color baseWhite = _baseWhite;
  static const Color trophyGold = _trophyGold;
}
