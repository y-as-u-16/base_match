import 'package:flutter_test/flutter_test.dart';
import 'package:base_match/features/games/domain/entities/game.dart';

void main() {
  group('Game', () {
    final now = DateTime.utc(2025, 5, 10, 9, 0);
    final json = {
      'id': 'game-1',
      'date': now.toIso8601String(),
      'location': 'Riverside Field',
      'my_team_id': 'team-1',
      'away_team_name': 'Away Team',
      'home_score': 5,
      'away_score': 3,
      'status': 'final',
      'created_at': now.toIso8601String(),
    };

    test('JSON から変換できる', () {
      final game = Game.fromJson(json);

      expect(game.id, 'game-1');
      expect(game.date, now);
      expect(game.location, 'Riverside Field');
      expect(game.myTeamId, 'team-1');
      expect(game.awayTeamName, 'Away Team');
      expect(game.homeScore, 5);
      expect(game.awayScore, 3);
      expect(game.status, 'final');
      expect(game.createdAt, now);
    });

    test('JSON に変換できる', () {
      final game = Game.fromJson(json);
      final result = game.toJson();

      expect(result['id'], 'game-1');
      expect(result['my_team_id'], 'team-1');
      expect(result['away_team_name'], 'Away Team');
      expect(result['home_score'], 5);
      expect(result['away_score'], 3);
      expect(result['status'], 'final');
    });

    test('fromJson から toJson の往復変換後も値を維持する', () {
      final game = Game.fromJson(json);
      final roundTripped = game.toJson();

      // innings is absent in the source JSON but emitted by toJson.
      expect(roundTripped['id'], json['id']);
      expect(roundTripped['date'], json['date']);
      expect(roundTripped['location'], json['location']);
      expect(roundTripped['my_team_id'], json['my_team_id']);
      expect(roundTripped['away_team_name'], json['away_team_name']);
      expect(roundTripped['home_score'], json['home_score']);
      expect(roundTripped['away_score'], json['away_score']);
      expect(roundTripped['status'], json['status']);
      expect(roundTripped['created_at'], json['created_at']);
    });

    test('任意項目の null を受け入れる', () {
      final jsonDraft = {
        'id': 'game-2',
        'date': now.toIso8601String(),
        'location': null,
        'my_team_id': 'team-1',
        'away_team_name': 'Away Team',
        'home_score': null,
        'away_score': null,
        'status': 'draft',
        'created_at': now.toIso8601String(),
      };
      final game = Game.fromJson(jsonDraft);

      expect(game.location, isNull);
      expect(game.homeScore, isNull);
      expect(game.awayScore, isNull);
      expect(game.status, 'draft');
    });

    test('copyWith は指定した項目だけを更新する', () {
      final game = Game.fromJson(json);
      final updated = game.copyWith(homeScore: 10, awayScore: 2);

      expect(updated.homeScore, 10);
      expect(updated.awayScore, 2);
      expect(updated.id, game.id);
      expect(updated.status, game.status);
    });
  });
}
