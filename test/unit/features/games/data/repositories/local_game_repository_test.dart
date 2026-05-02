import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/constants/app_constants.dart';
import 'package:base_match/core/local_db/local_database.dart';
import 'package:base_match/features/games/data/repositories/local_game_repository.dart';

void main() {
  group('LocalGameRepository', () {
    final uuidPattern = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    );

    late LocalDatabase database;
    late LocalGameRepository repository;

    setUp(() {
      database = LocalDatabase.forTesting(NativeDatabase.memory());
      repository = LocalGameRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    test('空のDBでは試合・打席・ピッチング成績が空で返る', () async {
      expect(await repository.getGames(), isEmpty);
      expect(await repository.getPlateAppearances(), isEmpty);
      expect(await repository.getPitchingAppearances(), isEmpty);
    });

    test('createGame はUUID v4のIDと初期値を保存する', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: '自チーム',
        awayTeamName: '相手チーム',
        innings: 7,
      );

      final games = await repository.getGames();

      expect(game.id, matches(uuidPattern));
      expect(game.id, isNot(startsWith('game-')));
      expect(games, hasLength(1));
      expect(games.single.id, game.id);
      expect(games.single.location, isNull);
      expect(games.single.homeScore, 0);
      expect(games.single.awayScore, 0);
      expect(games.single.status, AppConstants.statusDraft);
      expect(games.single.innings, 7);
    });

    test('createGame は試合ごとに異なるUUIDを保存する', () async {
      final first = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: '自チーム',
        awayTeamName: '相手チームA',
      );
      final second = await repository.createGame(
        date: DateTime.utc(2026, 5, 3),
        homeTeamName: '自チーム',
        awayTeamName: '相手チームB',
      );

      expect(first.id, matches(uuidPattern));
      expect(second.id, matches(uuidPattern));
      expect(first.id, isNot(second.id));
      expect(await repository.getGames(), hasLength(2));
    });

    test('createGame はチーム名が空なら保存しない', () async {
      expect(
        () => repository.createGame(
          date: DateTime.utc(2026, 5, 2),
          homeTeamName: ' ',
          awayTeamName: '相手チーム',
        ),
        throwsArgumentError,
      );

      expect(await repository.getGames(), isEmpty);
    });

    test('createGame はイニング数が0以下なら保存しない', () async {
      expect(
        () => repository.createGame(
          date: DateTime.utc(2026, 5, 2),
          homeTeamName: '自チーム',
          awayTeamName: '相手チーム',
          innings: 0,
        ),
        throwsArgumentError,
      );

      expect(await repository.getGames(), isEmpty);
    });

    test('addPlateAppearance はUUID v4のIDで保存し、打点分だけ自チーム得点を加算する', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: '自チーム',
        awayTeamName: '相手チーム',
      );

      final updatedGame = await repository.addPlateAppearance(
        gameId: game.id,
        resultType: AppConstants.resultHit,
        resultDetail: AppConstants.detailHr,
        inning: 3,
        rbi: 4,
      );

      final appearances = await repository.getPlateAppearances();
      final games = await repository.getGames();

      expect(updatedGame?.homeScore, 4);
      expect(games.single.homeScore, 4);
      expect(appearances, hasLength(1));
      expect(appearances.single.id, matches(uuidPattern));
      expect(appearances.single.id, isNot(startsWith('pa-')));
      expect(appearances.single.gameId, game.id);
      expect(appearances.single.inning, 3);
      expect(appearances.single.rbi, 4);
    });

    test('addPlateAppearance は打点がnullなら得点を増やさない', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: '自チーム',
        awayTeamName: '相手チーム',
      );

      final updatedGame = await repository.addPlateAppearance(
        gameId: game.id,
        resultType: AppConstants.resultOut,
        resultDetail: AppConstants.detailK,
      );

      expect(updatedGame?.homeScore, 0);
      expect((await repository.getGames()).single.homeScore, 0);
      expect((await repository.getPlateAppearances()).single.rbi, isNull);
    });

    test('addPlateAppearance は複数打席の打点を累積して自チーム得点に反映する', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: '自チーム',
        awayTeamName: '相手チーム',
      );

      await repository.addPlateAppearance(
        gameId: game.id,
        resultType: AppConstants.resultHit,
        resultDetail: AppConstants.detailSingle,
        rbi: 1,
      );
      final updatedGame = await repository.addPlateAppearance(
        gameId: game.id,
        resultType: AppConstants.resultHit,
        resultDetail: AppConstants.detailDouble,
        rbi: 2,
      );

      expect(updatedGame?.homeScore, 3);
      expect((await repository.getGames()).single.homeScore, 3);
      expect(await repository.getPlateAppearances(), hasLength(2));
    });

    test('addPlateAppearance は存在しない試合IDなら保存せずnullを返す', () async {
      final updatedGame = await repository.addPlateAppearance(
        gameId: '550e8400-e29b-41d4-a716-446655440099',
        resultType: AppConstants.resultHit,
        resultDetail: AppConstants.detailSingle,
        rbi: 1,
      );

      expect(updatedGame, isNull);
      expect(await repository.getPlateAppearances(), isEmpty);
    });

    test('addPlateAppearance は負の打点なら保存しない', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: '自チーム',
        awayTeamName: '相手チーム',
      );

      expect(
        () => repository.addPlateAppearance(
          gameId: game.id,
          resultType: AppConstants.resultHit,
          resultDetail: AppConstants.detailSingle,
          rbi: -1,
        ),
        throwsArgumentError,
      );

      expect(await repository.getPlateAppearances(), isEmpty);
      expect((await repository.getGames()).single.homeScore, 0);
    });

    test('addPitchingAppearance はUUID v4のIDでピッチング成績を保存する', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: '自チーム',
        awayTeamName: '相手チーム',
      );

      final appearance = await repository.addPitchingAppearance(
        gameId: game.id,
        outsPitched: 10,
        runs: 2,
        earnedRuns: 1,
        hitsAllowed: 4,
        walks: 3,
        strikeouts: 5,
        homeRunsAllowed: 1,
      );

      final appearances = await repository.getPitchingAppearances();

      expect(appearance.id, matches(uuidPattern));
      expect(appearance.id, isNot(startsWith('pit-')));
      expect(appearances, hasLength(1));
      expect(appearances.single.id, appearance.id);
      expect(appearances.single.gameId, game.id);
      expect(appearances.single.outsPitched, 10);
      expect(appearances.single.earnedRuns, 1);
      expect(appearances.single.homeRunsAllowed, 1);
    });

    test('addPitchingAppearance は0の集計値を保存できる', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: '自チーム',
        awayTeamName: '相手チーム',
      );

      final appearance = await repository.addPitchingAppearance(
        gameId: game.id,
        outsPitched: 3,
        runs: 0,
        earnedRuns: 0,
        hitsAllowed: 0,
        walks: 0,
        strikeouts: 0,
        homeRunsAllowed: 0,
      );

      expect(appearance.outsPitched, 3);
      expect(appearance.runs, 0);
      expect(appearance.earnedRuns, 0);
      expect(appearance.hitsAllowed, 0);
      expect(appearance.walks, 0);
      expect(appearance.strikeouts, 0);
      expect(appearance.homeRunsAllowed, 0);
    });

    test('addPitchingAppearance は存在しない試合IDなら保存しない', () async {
      expect(
        () => repository.addPitchingAppearance(
          gameId: '550e8400-e29b-41d4-a716-446655440099',
          outsPitched: 3,
          runs: 0,
          earnedRuns: 0,
          hitsAllowed: 0,
          walks: 0,
          strikeouts: 0,
          homeRunsAllowed: 0,
        ),
        throwsArgumentError,
      );

      expect(await repository.getPitchingAppearances(), isEmpty);
    });

    test('addPitchingAppearance は投球アウト数が0以下なら保存しない', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: '自チーム',
        awayTeamName: '相手チーム',
      );

      expect(
        () => repository.addPitchingAppearance(
          gameId: game.id,
          outsPitched: 0,
          runs: 0,
          earnedRuns: 0,
          hitsAllowed: 0,
          walks: 0,
          strikeouts: 0,
          homeRunsAllowed: 0,
        ),
        throwsArgumentError,
      );

      expect(await repository.getPitchingAppearances(), isEmpty);
    });

    test('addPitchingAppearance は負の集計値なら保存しない', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: '自チーム',
        awayTeamName: '相手チーム',
      );

      expect(
        () => repository.addPitchingAppearance(
          gameId: game.id,
          outsPitched: 3,
          runs: -1,
          earnedRuns: 0,
          hitsAllowed: 0,
          walks: 0,
          strikeouts: 0,
          homeRunsAllowed: 0,
        ),
        throwsArgumentError,
      );

      expect(await repository.getPitchingAppearances(), isEmpty);
    });

    test('finalizeGame は保存済み試合の状態をfinalに更新する', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: '自チーム',
        awayTeamName: '相手チーム',
      );

      await repository.finalizeGame(game.id);

      expect(
        (await repository.getGames()).single.status,
        AppConstants.statusFinal,
      );
    });
  });
}
