import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:base_match/core/local_db/local_database.dart';
import 'package:base_match/core/local_db/local_database_provider.dart';
import 'package:base_match/core/theme/app_theme.dart';
import 'package:base_match/features/games/data/repositories/local_my_team_repository.dart';
import 'package:base_match/features/games/presentation/pages/create_game_page.dart';
import 'package:base_match/l10n/generated/app_localizations.dart';
import 'package:base_match/l10n/generated/app_localizations_ja.dart';

void main() {
  final l10n = AppLocalizationsJa();

  Widget buildSubject(LocalDatabase database) {
    final router = GoRouter(
      initialLocation: '/games/create',
      routes: [
        GoRoute(
          path: '/games/create',
          builder: (context, state) => const CreateGamePage(),
        ),
        GoRoute(
          path: '/games/:gameId',
          builder: (context, state) => const Text('created-game'),
        ),
      ],
    );
    addTearDown(router.dispose);

    return ProviderScope(
      overrides: [localDatabaseProvider.overrideWithValue(database)],
      child: MaterialApp.router(
        theme: AppTheme.light,
        locale: const Locale('ja'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
  }

  group('CreateGamePage', () {
    testWidgets('自チームがない場合は試合作成画面から追加してそのまま試合を作成できる', (tester) async {
      final database = LocalDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);

      await tester.pumpWidget(buildSubject(database));
      await tester.pumpAndSettle();

      expect(find.text(l10n.noMyTeamsForGameTitle), findsOneWidget);
      expect(find.text(l10n.noMyTeamsForGameSubtitle), findsOneWidget);

      await tester.ensureVisible(find.text(l10n.addMyTeamButton));
      await tester.tap(find.text(l10n.addMyTeamButton));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, l10n.myTeamNameLabel),
        'Tokyo Bears',
      );
      await tester.tap(find.widgetWithText(FilledButton, l10n.addButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Tokyo Bears (${l10n.defaultMyTeamBadge})'),
        findsOneWidget,
      );
      expect(find.text(l10n.myTeamCreatedMessage), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, l10n.awayTeamNameLabel),
        'Osaka Tigers',
      );
      await tester.ensureVisible(
        find.widgetWithText(FilledButton, l10n.createButton),
      );
      await tester.tap(find.widgetWithText(FilledButton, l10n.createButton));
      await tester.pumpAndSettle();

      expect(find.text('created-game'), findsOneWidget);

      final teams = await database.select(database.localMyTeams).get();
      final games = await database.select(database.localGames).get();
      expect(teams, hasLength(1));
      expect(teams.single.name, 'Tokyo Bears');
      expect(games, hasLength(1));
      expect(games.single.myTeamId, teams.single.id);
      expect(games.single.awayTeamName, 'Osaka Tigers');
    });

    testWidgets('選択した自チーム ID で試合を作成する', (tester) async {
      final database = LocalDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final team = await LocalMyTeamRepository(
        database,
      ).createMyTeam(name: 'Tokyo Bears');

      await tester.pumpWidget(buildSubject(database));
      await tester.pumpAndSettle();

      expect(
        find.text('Tokyo Bears (${l10n.defaultMyTeamBadge})'),
        findsOneWidget,
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, l10n.awayTeamNameLabel),
        'Osaka Tigers',
      );
      await tester.ensureVisible(
        find.widgetWithText(FilledButton, l10n.createButton),
      );
      await tester.tap(find.widgetWithText(FilledButton, l10n.createButton));
      await tester.pumpAndSettle();

      expect(find.text('created-game'), findsOneWidget);

      final games = await database.select(database.localGames).get();
      expect(games, hasLength(1));
      expect(games.single.myTeamId, team.id);
      expect(games.single.awayTeamName, 'Osaka Tigers');
    });
  });
}
