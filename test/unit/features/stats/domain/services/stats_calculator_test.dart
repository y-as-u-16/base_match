import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/constants/app_constants.dart';
import 'package:base_match/features/games/domain/entities/pitching_appearance.dart';
import 'package:base_match/features/games/domain/entities/plate_appearance.dart';
import 'package:base_match/features/stats/domain/services/stats_calculator.dart';

void main() {
  group('BattingStats', () {
    test('打席リストが空の場合は打撃成績をゼロで返す', () {
      final stats = BattingStats.fromAppearances([]);

      expect(stats.pa, 0);
      expect(stats.ab, 0);
      expect(stats.hits, 0);
      expect(stats.hr, 0);
      expect(stats.walks, 0);
      expect(stats.so, 0);
      expect(stats.averageLabel, '.000');
    });

    test('安打、凡打、失策は打数に含め、四球は除外する', () {
      final stats = BattingStats.fromAppearances([
        _plate(
          id: 'pa-1',
          resultType: AppConstants.resultHit,
          resultDetail: AppConstants.detailSingle,
        ),
        _plate(
          id: 'pa-2',
          resultType: AppConstants.resultOut,
          resultDetail: AppConstants.detailK,
        ),
        _plate(
          id: 'pa-3',
          resultType: AppConstants.resultWalk,
          resultDetail: AppConstants.detailBb,
        ),
        _plate(
          id: 'pa-4',
          resultType: AppConstants.resultError,
          resultDetail: AppConstants.detailE,
        ),
      ]);

      expect(stats.pa, 4);
      expect(stats.ab, 3);
      expect(stats.hits, 1);
      expect(stats.walks, 1);
      expect(stats.so, 1);
      expect(stats.averageLabel, '.333');
    });

    test('本塁打を集計し、打率 1.000 を表示する', () {
      final stats = BattingStats.fromAppearances([
        _plate(
          id: 'pa-1',
          resultType: AppConstants.resultHit,
          resultDetail: AppConstants.detailHr,
        ),
        _plate(
          id: 'pa-2',
          resultType: AppConstants.resultHit,
          resultDetail: AppConstants.detailDouble,
        ),
      ]);

      expect(stats.pa, 2);
      expect(stats.ab, 2);
      expect(stats.hits, 2);
      expect(stats.hr, 1);
      expect(stats.averageLabel, '1.000');
    });
  });

  group('PitchingStats', () {
    test('登板リストが空の場合は投球成績をゼロで返す', () {
      final stats = PitchingStats.fromAppearances([]);

      expect(stats.games, 0);
      expect(stats.outsPitched, 0);
      expect(stats.earnedRuns, 0);
      expect(stats.strikeouts, 0);
      expect(stats.inningsLabel, '0');
      expect(stats.eraLabel, '-.--');
    });

    test('投球回、自責点、奪三振、防御率を集計する', () {
      final stats = PitchingStats.fromAppearances([
        _pitching(id: 'pit-1', outsPitched: 4, earnedRuns: 1, strikeouts: 2),
        _pitching(id: 'pit-2', outsPitched: 5, earnedRuns: 2, strikeouts: 4),
      ]);

      expect(stats.games, 2);
      expect(stats.outsPitched, 9);
      expect(stats.earnedRuns, 3);
      expect(stats.strikeouts, 6);
      expect(stats.inningsLabel, '3');
      expect(stats.eraLabel, '9.00');
    });

    test('端数の投球回を野球表記で表示する', () {
      final stats = PitchingStats.fromAppearances([
        _pitching(id: 'pit-1', outsPitched: 4),
      ]);

      expect(stats.inningsLabel, '1.1');
    });
  });
}

PlateAppearance _plate({
  required String id,
  required String resultType,
  required String resultDetail,
}) {
  return PlateAppearance(
    id: id,
    gameId: 'game-1',
    resultType: resultType,
    resultDetail: resultDetail,
    createdAt: DateTime.utc(2026, 5, 2),
  );
}

PitchingAppearance _pitching({
  required String id,
  required int outsPitched,
  int earnedRuns = 0,
  int strikeouts = 0,
}) {
  return PitchingAppearance(
    id: id,
    gameId: 'game-1',
    outsPitched: outsPitched,
    runs: earnedRuns,
    earnedRuns: earnedRuns,
    hitsAllowed: 0,
    walks: 0,
    strikeouts: strikeouts,
    homeRunsAllowed: 0,
    createdAt: DateTime.utc(2026, 5, 2),
  );
}
