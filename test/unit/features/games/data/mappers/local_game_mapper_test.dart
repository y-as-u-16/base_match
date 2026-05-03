import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/constants/app_constants.dart';
import 'package:base_match/core/local_db/local_database.dart';
import 'package:base_match/features/games/data/mappers/local_game_mapper.dart';
import 'package:base_match/features/games/domain/entities/game.dart';
import 'package:base_match/features/games/domain/entities/pitching_appearance.dart';
import 'package:base_match/features/games/domain/entities/plate_appearance.dart';

void main() {
  group('LocalGameMapper', () {
    const myTeamId = 'team-1';
    final date = DateTime.utc(2026, 5, 2);
    final createdAt = DateTime.utc(2026, 5, 2, 12);

    test('LocalGame を Game エンティティに変換する', () {
      final row = LocalGame(
        id: '550e8400-e29b-41d4-a716-446655440000',
        date: date,
        location: 'Riverside Field',
        myTeamId: myTeamId,
        awayTeamName: 'Away Team',
        homeScore: 5,
        awayScore: 3,
        status: AppConstants.statusFinal,
        createdAt: createdAt,
        innings: 7,
      );

      final entity = row.toEntity();

      expect(entity.id, row.id);
      expect(entity.date, date);
      expect(entity.location, 'Riverside Field');
      expect(entity.myTeamId, myTeamId);
      expect(entity.awayTeamName, 'Away Team');
      expect(entity.homeScore, 5);
      expect(entity.awayScore, 3);
      expect(entity.status, AppConstants.statusFinal);
      expect(entity.createdAt, createdAt);
      expect(entity.innings, 7);
    });

    test('Game エンティティを LocalGamesCompanion に変換する', () {
      final entity = Game(
        id: '550e8400-e29b-41d4-a716-446655440000',
        date: date,
        location: null,
        myTeamId: myTeamId,
        awayTeamName: 'Away Team',
        homeScore: 0,
        awayScore: 0,
        status: AppConstants.statusDraft,
        createdAt: createdAt,
        innings: null,
      );

      final companion = entity.toCompanion();

      expect(companion.id.value, entity.id);
      expect(companion.date.value, date);
      expect(companion.location.value, isNull);
      expect(companion.myTeamId.value, myTeamId);
      expect(companion.awayTeamName.value, 'Away Team');
      expect(companion.homeScore.value, 0);
      expect(companion.awayScore.value, 0);
      expect(companion.status.value, AppConstants.statusDraft);
      expect(companion.createdAt.value, createdAt);
      expect(companion.innings.value, isNull);
    });
  });

  group('LocalPlateAppearanceMapper', () {
    final createdAt = DateTime.utc(2026, 5, 2, 12);

    test('LocalPlateAppearance を PlateAppearance エンティティに変換する', () {
      final row = LocalPlateAppearance(
        id: '550e8400-e29b-41d4-a716-446655440010',
        gameId: '550e8400-e29b-41d4-a716-446655440000',
        batterName: '佐藤',
        inning: 3,
        resultType: AppConstants.resultHit,
        resultDetail: AppConstants.detailDouble,
        rbi: 2,
        createdAt: createdAt,
      );

      final entity = row.toEntity();

      expect(entity.id, row.id);
      expect(entity.gameId, row.gameId);
      expect(entity.batterName, '佐藤');
      expect(entity.inning, 3);
      expect(entity.resultType, AppConstants.resultHit);
      expect(entity.resultDetail, AppConstants.detailDouble);
      expect(entity.rbi, 2);
      expect(entity.createdAt, createdAt);
    });

    test('PlateAppearance エンティティを LocalPlateAppearancesCompanion に変換する', () {
      final entity = PlateAppearance(
        id: '550e8400-e29b-41d4-a716-446655440010',
        gameId: '550e8400-e29b-41d4-a716-446655440000',
        batterName: '佐藤',
        inning: null,
        resultType: AppConstants.resultWalk,
        resultDetail: AppConstants.detailBb,
        rbi: null,
        createdAt: createdAt,
      );

      final companion = entity.toCompanion();

      expect(companion.id.value, entity.id);
      expect(companion.gameId.value, entity.gameId);
      expect(companion.batterName.value, '佐藤');
      expect(companion.inning.value, isNull);
      expect(companion.resultType.value, AppConstants.resultWalk);
      expect(companion.resultDetail.value, AppConstants.detailBb);
      expect(companion.rbi.value, isNull);
      expect(companion.createdAt.value, createdAt);
    });
  });

  group('LocalPitchingAppearanceMapper', () {
    final createdAt = DateTime.utc(2026, 5, 2, 12);

    test('LocalPitchingAppearance を PitchingAppearance エンティティに変換する', () {
      final row = LocalPitchingAppearance(
        id: '550e8400-e29b-41d4-a716-446655440020',
        gameId: '550e8400-e29b-41d4-a716-446655440000',
        pitcherName: '佐藤',
        outsPitched: 9,
        runs: 2,
        earnedRuns: 1,
        hitsAllowed: 4,
        walks: 3,
        strikeouts: 5,
        homeRunsAllowed: 1,
        createdAt: createdAt,
      );

      final entity = row.toEntity();

      expect(entity.id, row.id);
      expect(entity.gameId, row.gameId);
      expect(entity.pitcherName, '佐藤');
      expect(entity.outsPitched, 9);
      expect(entity.runs, 2);
      expect(entity.earnedRuns, 1);
      expect(entity.hitsAllowed, 4);
      expect(entity.walks, 3);
      expect(entity.strikeouts, 5);
      expect(entity.homeRunsAllowed, 1);
      expect(entity.createdAt, createdAt);
    });

    test(
      'PitchingAppearance エンティティを LocalPitchingAppearancesCompanion に変換する',
      () {
        final entity = PitchingAppearance(
          id: '550e8400-e29b-41d4-a716-446655440020',
          gameId: '550e8400-e29b-41d4-a716-446655440000',
          pitcherName: '佐藤',
          outsPitched: 9,
          runs: 2,
          earnedRuns: 1,
          hitsAllowed: 4,
          walks: 3,
          strikeouts: 5,
          homeRunsAllowed: 1,
          createdAt: createdAt,
        );

        final companion = entity.toCompanion();

        expect(companion.id.value, entity.id);
        expect(companion.gameId.value, entity.gameId);
        expect(companion.pitcherName.value, '佐藤');
        expect(companion.outsPitched.value, 9);
        expect(companion.runs.value, 2);
        expect(companion.earnedRuns.value, 1);
        expect(companion.hitsAllowed.value, 4);
        expect(companion.walks.value, 3);
        expect(companion.strikeouts.value, 5);
        expect(companion.homeRunsAllowed.value, 1);
        expect(companion.createdAt.value, createdAt);
      },
    );
  });
}
