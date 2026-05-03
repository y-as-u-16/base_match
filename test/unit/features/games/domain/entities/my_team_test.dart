import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/features/games/domain/entities/my_team.dart';

void main() {
  group('MyTeam', () {
    final now = DateTime.utc(2026, 5, 3, 9);
    final archivedAt = DateTime.utc(2026, 5, 4, 9);
    final json = {
      'id': 'team-1',
      'name': 'Home Team',
      'color_key': 'blue',
      'is_default': true,
      'display_order': 0,
      'archived_at': archivedAt.toIso8601String(),
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };

    test('JSON から変換できる', () {
      final team = MyTeam.fromJson(json);

      expect(team.id, 'team-1');
      expect(team.name, 'Home Team');
      expect(team.colorKey, 'blue');
      expect(team.isDefault, isTrue);
      expect(team.displayOrder, 0);
      expect(team.archivedAt, archivedAt);
      expect(team.createdAt, now);
      expect(team.updatedAt, now);
    });

    test('JSON に変換できる', () {
      final team = MyTeam.fromJson(json);
      final result = team.toJson();

      expect(result['id'], 'team-1');
      expect(result['name'], 'Home Team');
      expect(result['color_key'], 'blue');
      expect(result['is_default'], isTrue);
      expect(result['display_order'], 0);
      expect(result['archived_at'], archivedAt.toIso8601String());
    });

    test('任意項目の null を受け入れる', () {
      final team = MyTeam.fromJson({
        ...json,
        'color_key': null,
        'archived_at': null,
      });

      expect(team.colorKey, isNull);
      expect(team.archivedAt, isNull);
    });

    test('copyWith は指定した項目だけを更新する', () {
      final team = MyTeam.fromJson(json);
      final updated = team.copyWith(name: 'New Team', isDefault: false);

      expect(updated.name, 'New Team');
      expect(updated.isDefault, isFalse);
      expect(updated.id, team.id);
      expect(updated.colorKey, team.colorKey);
    });
  });
}
