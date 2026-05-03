import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/local_db/local_database.dart';
import 'package:base_match/core/local_db/local_database_provider.dart';
import 'package:base_match/core/theme/app_theme.dart';
import 'package:base_match/features/games/presentation/pages/teams_page.dart';
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
        locale: const Locale('ja'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TeamsPage(),
      ),
    );
  }

  group('TeamsPage', () {
    testWidgets('自チームがない場合は空状態を表示する', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text(l10n.myTeamsTitle), findsOneWidget);
      expect(find.text(l10n.emptyMyTeamsTitle), findsOneWidget);
      expect(find.text(l10n.emptyMyTeamsSubtitle), findsOneWidget);
      expect(find.text(l10n.addMyTeamButton), findsNWidgets(2));
    });

    testWidgets('チーム名を入力して自チームを追加できる', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text(l10n.addMyTeamTitle), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, l10n.addButton));
      await tester.pumpAndSettle();

      expect(find.text(l10n.myTeamNameRequired), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'Tokyo Bears');
      await tester.tap(find.widgetWithText(FilledButton, l10n.addButton));
      await tester.pumpAndSettle();

      expect(find.text('Tokyo Bears'), findsOneWidget);
      expect(find.text(l10n.defaultMyTeamBadge), findsOneWidget);
      expect(find.text(l10n.myTeamCreatedMessage), findsOneWidget);
    });
  });
}
