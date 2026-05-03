import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/local_db/local_database.dart';
import 'package:base_match/features/games/data/repositories/local_my_team_repository.dart';

void main() {
  group('LocalMyTeamRepository', () {
    final uuidPattern = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    );

    late LocalDatabase database;
    late LocalMyTeamRepository repository;

    setUp(() {
      database = LocalDatabase.forTesting(NativeDatabase.memory());
      repository = LocalMyTeamRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    test('空のデータベースでは空リストと null のデフォルトを返す', () async {
      expect(await repository.getMyTeams(), isEmpty);
      expect(await repository.getDefaultMyTeam(), isNull);
    });

    test('createMyTeam は UUID v4 の ID で自チームを保存する', () async {
      final team = await repository.createMyTeam(
        name: ' Home Team ',
        colorKey: ' blue ',
      );

      final teams = await repository.getMyTeams();

      expect(team.id, matches(uuidPattern));
      expect(team.name, 'Home Team');
      expect(team.colorKey, 'blue');
      expect(team.isDefault, isTrue);
      expect(team.displayOrder, 0);
      expect(teams, hasLength(1));
      expect(teams.single.id, team.id);
      expect(teams.single.createdAt, isA<DateTime>());
      expect(teams.single.updatedAt, isA<DateTime>());
    });

    test('createMyTeam は空のチーム名を拒否する', () async {
      expect(() => repository.createMyTeam(name: ' '), throwsArgumentError);

      expect(await repository.getMyTeams(), isEmpty);
    });

    test('getMyTeams はアーカイブ済みを除外し displayOrder 順で返す', () async {
      final first = await repository.createMyTeam(name: 'First');
      final second = await repository.createMyTeam(name: 'Second');
      final third = await repository.createMyTeam(name: 'Third');
      await _archiveTeam(database, first.id);

      final teams = await repository.getMyTeams();

      expect(teams.map((team) => team.id), [second.id, third.id]);
      expect(teams.map((team) => team.displayOrder), [1, 2]);
    });

    test('createMyTeam で default 指定すると既存の default を解除する', () async {
      final first = await repository.createMyTeam(name: 'First');
      final second = await repository.createMyTeam(
        name: 'Second',
        isDefault: true,
      );

      final teams = await repository.getMyTeams();
      final defaultTeam = await repository.getDefaultMyTeam();

      expect(first.isDefault, isTrue);
      expect(second.isDefault, isTrue);
      expect(defaultTeam?.id, second.id);
      expect(teams.where((team) => team.isDefault).map((team) => team.id), [
        second.id,
      ]);
    });
  });
}

Future<void> _archiveTeam(LocalDatabase database, String teamId) async {
  await (database.update(
    database.localMyTeams,
  )..where((table) => table.id.equals(teamId))).write(
    LocalMyTeamsCompanion(archivedAt: Value(DateTime.utc(2026, 5, 4))),
  );
}
