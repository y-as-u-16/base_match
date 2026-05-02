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

    test('空のデータベースでは空リストを返す', () async {
      expect(await repository.getGames(), isEmpty);
      expect(await repository.getPlateAppearances(), isEmpty);
      expect(await repository.getPitchingAppearances(), isEmpty);
    });

    test('createGame は UUID v4 の ID とデフォルト値を保存する', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team',
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

    test('createGame は試合ごとに異なる UUID を保存する', () async {
      final first = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team A',
      );
      final second = await repository.createGame(
        date: DateTime.utc(2026, 5, 3),
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team B',
      );

      expect(first.id, matches(uuidPattern));
      expect(second.id, matches(uuidPattern));
      expect(first.id, isNot(second.id));
      expect(await repository.getGames(), hasLength(2));
    });

    test('createGame は空のチーム名を拒否する', () async {
      expect(
        () => repository.createGame(
          date: DateTime.utc(2026, 5, 2),
          homeTeamName: ' ',
          awayTeamName: 'Away Team',
        ),
        throwsArgumentError,
      );

      expect(await repository.getGames(), isEmpty);
    });

    test('createGame は 0 以下のイニング数を拒否する', () async {
      expect(
        () => repository.createGame(
          date: DateTime.utc(2026, 5, 2),
          homeTeamName: 'Home Team',
          awayTeamName: 'Away Team',
          innings: 0,
        ),
        throwsArgumentError,
      );

      expect(await repository.getGames(), isEmpty);
    });

    test('addPlateAppearance は UUID v4 の ID を保存し打点を得点に加算する', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team',
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

    test('addPlateAppearance は打点が null の場合に得点を変更しない', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team',
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

    test('addPlateAppearance は複数打席の打点を累積する', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team',
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

    test('addPlateAppearance は存在しない試合 ID では保存せず null を返す', () async {
      final updatedGame = await repository.addPlateAppearance(
        gameId: '550e8400-e29b-41d4-a716-446655440099',
        resultType: AppConstants.resultHit,
        resultDetail: AppConstants.detailSingle,
        rbi: 1,
      );

      expect(updatedGame, isNull);
      expect(await repository.getPlateAppearances(), isEmpty);
    });

    test('addPlateAppearance は負の打点を拒否する', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team',
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

    test('addPitchingAppearance は UUID v4 の ID で投球成績を保存する', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team',
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

    test('addPitchingAppearance は 0 の成績値を受け入れる', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team',
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

    test('addPitchingAppearance は存在しない試合 ID を拒否する', () async {
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

    test('addPitchingAppearance は 0 以下の投球アウト数を拒否する', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team',
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

    test('addPitchingAppearance は負の成績値を拒否する', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team',
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

    test('finalizeGame は保存済み試合のステータスを final に更新する', () async {
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 2),
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team',
      );

      await repository.finalizeGame(game.id);

      expect(
        (await repository.getGames()).single.status,
        AppConstants.statusFinal,
      );
    });
  });
}
