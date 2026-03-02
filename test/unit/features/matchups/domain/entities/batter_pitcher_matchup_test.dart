import 'package:flutter_test/flutter_test.dart';
import 'package:base_match/features/matchups/domain/entities/batter_pitcher_matchup.dart';

void main() {
  group('BatterPitcherMatchup', () {
    test('fromJson で正しくパースされる', () {
      final json = {
        'batter_player_id': 'player-a',
        'pitcher_player_id': 'player-b',
        'batter_name': '田中太郎',
        'pitcher_name': '鈴木次郎',
        'ab': 10,
        'hits': 3,
        'hr': 1,
        'bb_hbp': 2,
        'so': 4,
      };

      final matchup = BatterPitcherMatchup.fromJson(json);

      expect(matchup.batterPlayerId, 'player-a');
      expect(matchup.pitcherPlayerId, 'player-b');
      expect(matchup.batterName, '田中太郎');
      expect(matchup.pitcherName, '鈴木次郎');
      expect(matchup.ab, 10);
      expect(matchup.hits, 3);
      expect(matchup.hr, 1);
      expect(matchup.bbHbp, 2);
      expect(matchup.so, 4);
    });

    test('avg が ab > 0 のとき正しく計算される', () {
      final json = {
        'batter_player_id': 'player-a',
        'pitcher_player_id': 'player-b',
        'batter_name': '田中',
        'pitcher_name': '鈴木',
        'ab': 10,
        'hits': 3,
        'hr': 0,
        'bb_hbp': 0,
        'so': 0,
      };

      final matchup = BatterPitcherMatchup.fromJson(json);

      expect(matchup.avg, closeTo(0.3, 0.001));
    });

    test('avg が ab == 0 のとき 0.0 になる', () {
      final json = {
        'batter_player_id': 'player-a',
        'pitcher_player_id': 'player-b',
        'batter_name': '田中',
        'pitcher_name': '鈴木',
        'ab': 0,
        'hits': 0,
        'hr': 0,
        'bb_hbp': 0,
        'so': 0,
      };

      final matchup = BatterPitcherMatchup.fromJson(json);

      expect(matchup.avg, 0.0);
    });

    test('null値のフィールドがデフォルト値に変換される', () {
      final json = {
        'batter_player_id': 'player-a',
        'pitcher_player_id': 'player-b',
        'batter_name': null,
        'pitcher_name': null,
        'ab': null,
        'hits': null,
        'hr': null,
        'bb_hbp': null,
        'so': null,
      };

      final matchup = BatterPitcherMatchup.fromJson(json);

      expect(matchup.batterName, '');
      expect(matchup.pitcherName, '');
      expect(matchup.ab, 0);
      expect(matchup.hits, 0);
      expect(matchup.hr, 0);
      expect(matchup.bbHbp, 0);
      expect(matchup.so, 0);
      expect(matchup.avg, 0.0);
    });

    test('num型 (double) の値が int に正しく変換される', () {
      final json = {
        'batter_player_id': 'player-a',
        'pitcher_player_id': 'player-b',
        'batter_name': '田中',
        'pitcher_name': '鈴木',
        'ab': 5.0,
        'hits': 2.0,
        'hr': 1.0,
        'bb_hbp': 0.0,
        'so': 1.0,
      };

      final matchup = BatterPitcherMatchup.fromJson(json);

      expect(matchup.ab, 5);
      expect(matchup.hits, 2);
      expect(matchup.hr, 1);
    });
  });
}
