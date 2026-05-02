import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/local_db/local_database.dart';
import 'package:base_match/core/local_db/local_database_provider.dart';
import 'package:base_match/core/theme/app_theme.dart';
import 'package:base_match/features/home/presentation/pages/home_page.dart';
import 'package:base_match/l10n/generated/app_localizations.dart';
import 'package:base_match/l10n/generated/app_localizations_ja.dart';

void main() {
  final l10n = AppLocalizationsJa();

  Widget buildSubject() {
    final database = LocalDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    return ProviderScope(
      overrides: [localDatabaseProvider.overrideWithValue(database)],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
      ),
    );
  }

  group('HomePage', () {
    testWidgets('ローカル記録の主要アクションを表示する', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text(l10n.brandName), findsOneWidget);
      expect(find.text(l10n.homeHeadline), findsOneWidget);
      expect(find.text(l10n.seasonSummaryTitle), findsOneWidget);
      expect(find.text(l10n.seasonGamesCount(0)), findsOneWidget);
      expect(find.text(l10n.seasonRecordLabel(0, 0, 0)), findsOneWidget);
      expect(find.text(l10n.recordGameButton), findsOneWidget);
      expect(find.text(l10n.viewStatsButton), findsOneWidget);
    });

    testWidgets('試合がない場合は空状態を表示する', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text(l10n.recentGamesTitle), findsOneWidget);
      expect(find.text(l10n.homeEmptyGames), findsOneWidget);
    });
  });
}
