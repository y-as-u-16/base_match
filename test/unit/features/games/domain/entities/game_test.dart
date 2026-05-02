import 'package:flutter_test/flutter_test.dart';
import 'package:base_match/features/games/domain/entities/game.dart';

void main() {
  group('Game', () {
    final now = DateTime.utc(2025, 5, 10, 9, 0);
    final json = {
      'id': 'game-1',
      'date': now.toIso8601String(),
      'location': '河川敷グラウンド',
      'home_team_name': '自分チーム',
      'away_team_name': '相手チーム',
      'home_score': 5,
      'away_score': 3,
      'status': 'final',
      'created_at': now.toIso8601String(),
    };

    test('fromJson で正しくパースされる', () {
      final game = Game.fromJson(json);

      expect(game.id, 'game-1');
      expect(game.date, now);
      expect(game.location, '河川敷グラウンド');
      expect(game.homeTeamName, '自分チーム');
      expect(game.awayTeamName, '相手チーム');
      expect(game.homeScore, 5);
      expect(game.awayScore, 3);
      expect(game.status, 'final');
      expect(game.createdAt, now);
    });

    test('toJson で正しくシリアライズされる', () {
      final game = Game.fromJson(json);
      final result = game.toJson();

      expect(result['id'], 'game-1');
      expect(result['home_team_name'], '自分チーム');
      expect(result['away_team_name'], '相手チーム');
      expect(result['home_score'], 5);
      expect(result['away_score'], 3);
      expect(result['status'], 'final');
    });

    test('fromJson -> toJson の往復で値が保持される', () {
      final game = Game.fromJson(json);
      final roundTripped = game.toJson();

      // innings, gameNumber は元のJSONに含まれないがtoJsonでは出力される
      expect(roundTripped['id'], json['id']);
      expect(roundTripped['date'], json['date']);
      expect(roundTripped['location'], json['location']);
      expect(roundTripped['home_team_name'], json['home_team_name']);
      expect(roundTripped['away_team_name'], json['away_team_name']);
      expect(roundTripped['home_score'], json['home_score']);
      expect(roundTripped['away_score'], json['away_score']);
      expect(roundTripped['status'], json['status']);
      expect(roundTripped['created_at'], json['created_at']);
    });

    test('null許容フィールド (location, scores) が null の場合', () {
      final jsonDraft = {
        'id': 'game-2',
        'date': now.toIso8601String(),
        'location': null,
        'home_team_name': '自分チーム',
        'away_team_name': '相手チーム',
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

    test('copyWith で特定フィールドのみ更新される', () {
      final game = Game.fromJson(json);
      final updated = game.copyWith(homeScore: 10, awayScore: 2);

      expect(updated.homeScore, 10);
      expect(updated.awayScore, 2);
      expect(updated.id, game.id);
      expect(updated.status, game.status);
    });
  });
}
