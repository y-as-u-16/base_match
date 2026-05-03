import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/constants/app_constants.dart';
import 'package:base_match/core/local_db/local_database.dart';
import 'package:base_match/features/games/data/repositories/local_game_repository.dart';
import 'package:base_match/features/games/presentation/view_models/game_view_model.dart';

void main() {
  group('LocalGameStore', () {
    late LocalDatabase database;

    setUp(() {
      database = LocalDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      await database.close();
    });

    test('試合、打席、投球記録を再読み込みする', () async {
      final uuidPattern = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      );
      final repository = LocalGameRepository(database);
      final store = LocalGameStore(repository);
      final game = await store.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team',
        location: 'Riverside Field',
        innings: 7,
        homeScore: 4,
        awayScore: 2,
      );

      final plateAppearance = await store.addPlateAppearance(
        gameId: game.id,
        batterName: '自分',
        resultType: AppConstants.resultHit,
        resultDetail: AppConstants.detailSingle,
        inning: 1,
        rbi: 2,
      );
      final pitchingAppearance = await store.addPitchingAppearance(
        gameId: game.id,
        pitcherName: '自分',
        outsPitched: 9,
        runs: 1,
        earnedRuns: 1,
        hitsAllowed: 3,
        walks: 1,
        strikeouts: 4,
        homeRunsAllowed: 0,
      );

      expect(game.id, matches(uuidPattern));
      expect(plateAppearance.id, matches(uuidPattern));
      expect(pitchingAppearance.id, matches(uuidPattern));

      final reloadedStore = LocalGameStore(repository);
      await reloadedStore.load();

      expect(reloadedStore.state.games, hasLength(1));
      expect(reloadedStore.state.games.single.homeTeamName, 'Home Team');
      expect(reloadedStore.state.games.single.homeScore, 4);
      expect(reloadedStore.state.games.single.awayScore, 2);
      expect(reloadedStore.state.plateAppearances, hasLength(1));
      expect(reloadedStore.state.plateAppearances.single.batterName, '自分');
      expect(reloadedStore.state.pitchingAppearances, hasLength(1));
      expect(reloadedStore.state.pitchingAppearances.single.pitcherName, '自分');
    });

    test('存在しない試合 ID では例外を投げて状態を変更しない', () async {
      final repository = LocalGameRepository(database);
      final store = LocalGameStore(repository);

      expect(
        () => store.addPlateAppearance(
          gameId: '550e8400-e29b-41d4-a716-446655440099',
          batterName: '自分',
          resultType: AppConstants.resultHit,
          resultDetail: AppConstants.detailSingle,
          rbi: 1,
        ),
        throwsArgumentError,
      );

      expect(store.state.plateAppearances, isEmpty);
      expect(store.state.games, isEmpty);
    });

    test('gamesProvider は試合を日付の降順で返す', () async {
      final repository = LocalGameRepository(database);
      final store = LocalGameStore(repository);
      await store.createGame(
        date: DateTime.utc(2026, 5, 1),
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team A',
      );
      await store.createGame(
        date: DateTime.utc(2026, 5, 3),
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team B',
      );

      final container = ProviderContainer(
        overrides: [localGameStoreProvider.overrideWith((ref) => store)],
      );
      addTearDown(container.dispose);

      final games = container.read(gamesProvider);

      expect(games.map((game) => game.awayTeamName), [
        'Away Team B',
        'Away Team A',
      ]);
    });
  });
}
