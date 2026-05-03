import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/local_db/local_database.dart';
import 'package:base_match/core/local_db/local_database_provider.dart';
import 'package:base_match/core/theme/app_theme.dart';
import 'package:base_match/features/games/data/repositories/local_game_repository.dart';
import 'package:base_match/features/games/data/repositories/local_my_team_repository.dart';
import 'package:base_match/features/games/presentation/pages/game_detail_page.dart';
import 'package:base_match/features/games/presentation/pages/games_page.dart';
import 'package:base_match/features/home/presentation/pages/home_page.dart';
import 'package:base_match/l10n/generated/app_localizations.dart';

void main() {
  Future<({LocalDatabase database, String gameId})>
  createDatabaseWithGame() async {
    final database = LocalDatabase.forTesting(NativeDatabase.memory());
    final team = await LocalMyTeamRepository(
      database,
    ).createMyTeam(name: 'Tokyo Bears');
    final game = await LocalGameRepository(database).createGame(
      date: DateTime.utc(2026, 5, 3),
      myTeamId: team.id,
      awayTeamName: 'Osaka Tigers',
      homeScore: 4,
      awayScore: 2,
    );
    return (database: database, gameId: game.id);
  }

  Widget buildSubject(LocalDatabase database, Widget child) {
    return ProviderScope(
      overrides: [localDatabaseProvider.overrideWithValue(database)],
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('ja'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }

  testWidgets('ホームの直近試合は自チーム名を表示する', (tester) async {
    final seed = await createDatabaseWithGame();
    addTearDown(seed.database.close);

    await tester.pumpWidget(buildSubject(seed.database, const HomePage()));
    await tester.pumpAndSettle();

    expect(find.text('Tokyo Bears vs Osaka Tigers'), findsOneWidget);
    expect(find.textContaining(seed.gameId), findsNothing);
  });

  testWidgets('記録一覧は自チーム名を表示する', (tester) async {
    final seed = await createDatabaseWithGame();
    addTearDown(seed.database.close);

    await tester.pumpWidget(buildSubject(seed.database, const GamesPage()));
    await tester.pumpAndSettle();

    expect(find.text('Tokyo Bears vs Osaka Tigers'), findsOneWidget);
  });

  testWidgets('記録一覧はリストとカレンダーを切り替えられる', (tester) async {
    final seed = await createDatabaseWithGame();
    addTearDown(seed.database.close);

    await tester.pumpWidget(buildSubject(seed.database, const GamesPage()));
    await tester.pumpAndSettle();

    expect(find.text('リスト'), findsOneWidget);
    expect(find.text('カレンダー'), findsOneWidget);
    expect(find.text('Tokyo Bears vs Osaka Tigers'), findsOneWidget);

    await tester.tap(find.text('カレンダー'));
    await tester.pumpAndSettle();

    final now = DateTime.now();
    expect(find.text('${now.year}年${now.month}月'), findsOneWidget);
    expect(find.text('日'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
    expect(find.text('1試合'), findsOneWidget);
  });

  testWidgets('試合詳細は自チーム名を表示する', (tester) async {
    final seed = await createDatabaseWithGame();
    addTearDown(seed.database.close);

    await tester.pumpWidget(
      buildSubject(seed.database, GameDetailPage(gameId: seed.gameId)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tokyo Bears vs Osaka Tigers'), findsOneWidget);
    expect(find.text('Tokyo Bears'), findsOneWidget);
  });
}
