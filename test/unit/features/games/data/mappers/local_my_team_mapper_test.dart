import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/local_db/local_database.dart';
import 'package:base_match/features/games/data/mappers/local_my_team_mapper.dart';
import 'package:base_match/features/games/domain/entities/my_team.dart';

void main() {
  group('LocalMyTeamMapper', () {
    final createdAt = DateTime.utc(2026, 5, 3, 9);
    final updatedAt = DateTime.utc(2026, 5, 3, 10);

    test('LocalMyTeam を MyTeam エンティティに変換する', () {
      final row = LocalMyTeam(
        id: 'team-1',
        name: 'Home Team',
        colorKey: 'blue',
        isDefault: true,
        displayOrder: 0,
        archivedAt: null,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final entity = row.toEntity();

      expect(entity.id, 'team-1');
      expect(entity.name, 'Home Team');
      expect(entity.colorKey, 'blue');
      expect(entity.isDefault, isTrue);
      expect(entity.displayOrder, 0);
      expect(entity.archivedAt, isNull);
      expect(entity.createdAt, createdAt);
      expect(entity.updatedAt, updatedAt);
    });

    test('MyTeam エンティティを LocalMyTeamsCompanion に変換する', () {
      final entity = MyTeam(
        id: 'team-1',
        name: 'Home Team',
        colorKey: null,
        isDefault: false,
        displayOrder: 1,
        archivedAt: null,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final companion = entity.toCompanion();

      expect(companion.id.value, 'team-1');
      expect(companion.name.value, 'Home Team');
      expect(companion.colorKey.value, isNull);
      expect(companion.isDefault.value, isFalse);
      expect(companion.displayOrder.value, 1);
      expect(companion.archivedAt.value, isNull);
      expect(companion.createdAt.value, createdAt);
      expect(companion.updatedAt.value, updatedAt);
    });
  });
}
