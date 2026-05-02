import 'package:drift/native.dart';
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

    test('試合・打席・ピッチング記録をDBから再読込できる', () async {
      final uuidPattern = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      );
      final repository = LocalGameRepository(database);
      final store = LocalGameStore(repository);
      final game = await store.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: '自チーム',
        awayTeamName: '相手チーム',
        location: '河川敷',
        innings: 7,
      );

      final plateAppearance = await store.addPlateAppearance(
        gameId: game.id,
        resultType: AppConstants.resultHit,
        resultDetail: AppConstants.detailSingle,
        inning: 1,
        rbi: 2,
      );
      final pitchingAppearance = await store.addPitchingAppearance(
        gameId: game.id,
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
      expect(reloadedStore.state.games.single.homeTeamName, '自チーム');
      expect(reloadedStore.state.games.single.homeScore, 2);
      expect(reloadedStore.state.plateAppearances, hasLength(1));
      expect(reloadedStore.state.pitchingAppearances, hasLength(1));
    });
  });
}
