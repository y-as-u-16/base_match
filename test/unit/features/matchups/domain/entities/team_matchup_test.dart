import 'package:flutter_test/flutter_test.dart';
import 'package:base_match/features/matchups/domain/entities/team_matchup.dart';

void main() {
  group('TeamMatchup', () {
    test('fromJson で正しくパースされる', () {
      final json = {
        'team_a_id': 'team-a',
        'team_b_id': 'team-b',
        'team_a_name': 'チームA',
        'team_b_name': 'チームB',
        'games': 10,
        'wins_a': 6,
        'wins_b': 3,
        'draws': 1,
        'runs_a': 45,
        'runs_b': 30,
      };

      final matchup = TeamMatchup.fromJson(json);

      expect(matchup.teamAId, 'team-a');
      expect(matchup.teamBId, 'team-b');
      expect(matchup.teamAName, 'チームA');
      expect(matchup.teamBName, 'チームB');
      expect(matchup.games, 10);
      expect(matchup.winsA, 6);
      expect(matchup.winsB, 3);
      expect(matchup.draws, 1);
      expect(matchup.runsA, 45);
      expect(matchup.runsB, 30);
    });

    test('winRateA が games > 0 のとき正しく計算される', () {
      final json = {
        'team_a_id': 'team-a',
        'team_b_id': 'team-b',
        'team_a_name': 'A',
        'team_b_name': 'B',
        'games': 10,
        'wins_a': 6,
        'wins_b': 3,
        'draws': 1,
        'runs_a': 0,
        'runs_b': 0,
      };

      final matchup = TeamMatchup.fromJson(json);

      expect(matchup.winRateA, closeTo(0.6, 0.001));
    });

    test('winRateA が games == 0 のとき 0.0 になる', () {
      final json = {
        'team_a_id': 'team-a',
        'team_b_id': 'team-b',
        'team_a_name': 'A',
        'team_b_name': 'B',
        'games': 0,
        'wins_a': 0,
        'wins_b': 0,
        'draws': 0,
        'runs_a': 0,
        'runs_b': 0,
      };

      final matchup = TeamMatchup.fromJson(json);

      expect(matchup.winRateA, 0.0);
    });

    test('null値のフィールドがデフォルト値に変換される', () {
      final json = {
        'team_a_id': 'team-a',
        'team_b_id': 'team-b',
        'team_a_name': null,
        'team_b_name': null,
        'games': null,
        'wins_a': null,
        'wins_b': null,
        'draws': null,
        'runs_a': null,
        'runs_b': null,
      };

      final matchup = TeamMatchup.fromJson(json);

      expect(matchup.teamAName, '');
      expect(matchup.teamBName, '');
      expect(matchup.games, 0);
      expect(matchup.winsA, 0);
      expect(matchup.winsB, 0);
      expect(matchup.draws, 0);
      expect(matchup.runsA, 0);
      expect(matchup.runsB, 0);
    });

    test('num型 (double) の値が int に正しく変換される', () {
      final json = {
        'team_a_id': 'team-a',
        'team_b_id': 'team-b',
        'team_a_name': 'A',
        'team_b_name': 'B',
        'games': 5.0,
        'wins_a': 3.0,
        'wins_b': 1.0,
        'draws': 1.0,
        'runs_a': 20.0,
        'runs_b': 15.0,
      };

      final matchup = TeamMatchup.fromJson(json);

      expect(matchup.games, 5);
      expect(matchup.winsA, 3);
      expect(matchup.runsA, 20);
    });
  });
}
