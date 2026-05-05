import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:base_match/core/local_db/local_database.dart';
import 'package:base_match/core/local_db/local_database_provider.dart';
import 'package:base_match/core/theme/app_theme.dart';
import 'package:base_match/features/games/data/repositories/local_game_repository.dart';
import 'package:base_match/features/games/data/repositories/local_my_team_repository.dart';
import 'package:base_match/features/games/presentation/pages/create_game_page.dart';
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

  Widget buildRoutedSubject(LocalDatabase database) {
    final router = GoRouter(
      initialLocation: '/games',
      routes: [
        GoRoute(
          path: '/games',
          builder: (context, state) => const GamesPage(),
          routes: [
            GoRoute(
              path: 'create',
              builder: (context, state) {
                final date = state.uri.queryParameters['date'];
                final parsedDate = date == null
                    ? null
                    : DateTime.tryParse(date);
                return CreateGamePage(initialDate: parsedDate);
              },
            ),
            GoRoute(
              path: ':gameId',
              builder: (context, state) => const Text('game-detail'),
            ),
          ],
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
    await tester.tap(find.byKey(const ValueKey('calendar-day-2026-5-3')));
    await tester.pumpAndSettle();

    expect(find.text('Tokyo Bears vs Osaka Tigers'), findsOneWidget);
  });

  testWidgets('記録一覧はカレンダーのみを表示する', (tester) async {
    final seed = await createDatabaseWithGame();
    addTearDown(seed.database.close);

    await tester.pumpWidget(buildSubject(seed.database, const GamesPage()));
    await tester.pumpAndSettle();

    expect(find.text('リスト'), findsNothing);
    expect(find.text('カレンダー'), findsNothing);

    final now = DateTime.now();
    expect(find.text('${now.year}年${now.month}月'), findsOneWidget);
    expect(find.text('日'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
    expect(find.text('1試合'), findsOneWidget);

    final targetDay = now.day == 1 ? 2 : 1;
    final targetDayKey = ValueKey(
      'calendar-day-${now.year}-${now.month}-$targetDay',
    );

    BoxDecoration dayDecoration() {
      return tester.widget<DecoratedBox>(find.byKey(targetDayKey)).decoration
          as BoxDecoration;
    }

    expect(
      dayDecoration().color,
      AppTheme.light.colorScheme.surfaceContainerLowest,
    );

    await tester.tap(find.byKey(targetDayKey));
    await tester.pumpAndSettle();

    expect(dayDecoration().color, AppTheme.light.colorScheme.primaryContainer);
    expect(find.text('この日の試合はありません'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('calendar-day-2026-5-3')));
    await tester.pumpAndSettle();

    expect(find.text('Tokyo Bears vs Osaka Tigers'), findsOneWidget);

    await tester.tap(find.byTooltip('次の月'));
    await tester.pumpAndSettle();

    final nextMonth = DateTime(now.year, now.month + 1);
    expect(find.text('${nextMonth.year}年${nextMonth.month}月'), findsOneWidget);
    expect(find.text('この日の試合はありません'), findsOneWidget);

    await tester.tap(find.byTooltip('前の月'));
    await tester.pumpAndSettle();

    expect(find.text('${now.year}年${now.month}月'), findsOneWidget);
  });

  testWidgets('カレンダーで選択した日付を試合作成画面に引き継ぐ', (tester) async {
    final seed = await createDatabaseWithGame();
    addTearDown(seed.database.close);

    await tester.pumpWidget(buildRoutedSubject(seed.database));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('calendar-day-2026-5-3')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FloatingActionButton, '試合を追加'));
    await tester.pumpAndSettle();

    expect(find.text('2026/05/03'), findsWidgets);
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
