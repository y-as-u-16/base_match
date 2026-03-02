import 'package:flutter_test/flutter_test.dart';
import 'package:base_match/features/teams/domain/entities/team.dart';

void main() {
  group('Team', () {
    final now = DateTime.utc(2025, 3, 1, 12, 0);
    final json = {
      'id': 'team-1',
      'name': 'テストチーム',
      'area': '東京都',
      'photo_url': 'https://example.com/team.png',
      'invite_code': 'ABCD1234',
      'created_by': 'user-1',
      'created_at': now.toIso8601String(),
    };

    test('fromJson で正しくパースされる', () {
      final team = Team.fromJson(json);

      expect(team.id, 'team-1');
      expect(team.name, 'テストチーム');
      expect(team.area, '東京都');
      expect(team.photoUrl, 'https://example.com/team.png');
      expect(team.inviteCode, 'ABCD1234');
      expect(team.createdBy, 'user-1');
      expect(team.createdAt, now);
    });

    test('toJson で正しくシリアライズされる', () {
      final team = Team(
        id: 'team-1',
        name: 'テストチーム',
        area: '東京都',
        photoUrl: 'https://example.com/team.png',
        inviteCode: 'ABCD1234',
        createdBy: 'user-1',
        createdAt: now,
      );

      final result = team.toJson();

      expect(result['id'], 'team-1');
      expect(result['name'], 'テストチーム');
      expect(result['area'], '東京都');
      expect(result['invite_code'], 'ABCD1234');
    });

    test('fromJson -> toJson の往復で値が保持される', () {
      final team = Team.fromJson(json);
      final roundTripped = team.toJson();

      expect(roundTripped, json);
    });

    test('null許容フィールド (area, photoUrl) が null の場合', () {
      final jsonNoOptional = {
        'id': 'team-2',
        'name': 'チーム2',
        'area': null,
        'photo_url': null,
        'invite_code': 'EFGH5678',
        'created_by': 'user-2',
        'created_at': now.toIso8601String(),
      };
      final team = Team.fromJson(jsonNoOptional);

      expect(team.area, isNull);
      expect(team.photoUrl, isNull);
    });

    test('copyWith で特定フィールドのみ更新される', () {
      final team = Team.fromJson(json);
      final updated = team.copyWith(name: '更新チーム');

      expect(updated.name, '更新チーム');
      expect(updated.id, team.id);
      expect(updated.area, team.area);
      expect(updated.inviteCode, team.inviteCode);
    });
  });
}
