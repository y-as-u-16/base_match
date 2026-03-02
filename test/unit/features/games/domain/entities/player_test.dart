import 'package:flutter_test/flutter_test.dart';
import 'package:base_match/features/games/domain/entities/player.dart';

void main() {
  group('Player', () {
    final now = DateTime.utc(2025, 4, 1, 8, 0);
    final json = {
      'id': 'player-1',
      'team_id': 'team-1',
      'display_name': '田中一郎',
      'user_id': 'user-1',
      'created_by': 'user-1',
      'created_at': now.toIso8601String(),
    };

    test('fromJson で正しくパースされる', () {
      final player = Player.fromJson(json);

      expect(player.id, 'player-1');
      expect(player.teamId, 'team-1');
      expect(player.displayName, '田中一郎');
      expect(player.userId, 'user-1');
      expect(player.createdBy, 'user-1');
      expect(player.createdAt, now);
    });

    test('toJson で正しくシリアライズされる', () {
      final player = Player.fromJson(json);
      final result = player.toJson();

      expect(result['id'], 'player-1');
      expect(result['team_id'], 'team-1');
      expect(result['display_name'], '田中一郎');
      expect(result['user_id'], 'user-1');
    });

    test('fromJson -> toJson の往復で値が保持される', () {
      final player = Player.fromJson(json);
      final roundTripped = player.toJson();

      expect(roundTripped, json);
    });

    test('userId が null の場合 isTemp が true になる', () {
      final jsonTemp = {
        'id': 'player-2',
        'team_id': 'team-1',
        'display_name': '仮選手A',
        'user_id': null,
        'created_by': 'user-1',
        'created_at': now.toIso8601String(),
      };
      final player = Player.fromJson(jsonTemp);

      expect(player.userId, isNull);
      expect(player.isTemp, isTrue);
    });

    test('userId がある場合 isTemp が false になる', () {
      final player = Player.fromJson(json);

      expect(player.isTemp, isFalse);
    });

    test('copyWith で特定フィールドのみ更新される', () {
      final player = Player.fromJson(json);
      final updated = player.copyWith(displayName: '更新太郎');

      expect(updated.displayName, '更新太郎');
      expect(updated.id, player.id);
      expect(updated.teamId, player.teamId);
    });
  });
}
