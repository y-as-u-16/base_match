import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/local_db/local_database.dart';
import 'package:base_match/features/games/data/repositories/local_my_team_repository.dart';
import 'package:base_match/features/games/presentation/view_models/my_team_view_model.dart';

void main() {
  group('MyTeamStore', () {
    late LocalDatabase database;

    setUp(() {
      database = LocalDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      await database.close();
    });

    test('自チームを作成して状態に追加する', () async {
      final repository = LocalMyTeamRepository(database);
      final store = MyTeamStore(repository);

      final team = await store.createMyTeam(name: 'Home Team');

      expect(store.state.teams, hasLength(1));
      expect(store.state.teams.single.id, team.id);
      expect(store.state.teams.single.name, 'Home Team');
      expect(store.state.teams.single.isDefault, isTrue);
    });

    test('デフォルト作成時は状態上でも既存 default を解除する', () async {
      final repository = LocalMyTeamRepository(database);
      final store = MyTeamStore(repository);

      final first = await store.createMyTeam(name: 'First');
      final second = await store.createMyTeam(name: 'Second', isDefault: true);

      expect(first.isDefault, isTrue);
      expect(second.isDefault, isTrue);
      expect(
        store.state.teams
            .where((team) => team.isDefault)
            .map((team) => team.id),
        [second.id],
      );
    });

    test('myTeamsProvider は状態の自チーム一覧を返す', () async {
      final repository = LocalMyTeamRepository(database);
      final store = MyTeamStore(repository);
      await store.createMyTeam(name: 'Home Team');

      final container = ProviderContainer(
        overrides: [myTeamStoreProvider.overrideWith((ref) => store)],
      );
      addTearDown(container.dispose);

      final teams = container.read(myTeamsProvider);

      expect(teams, hasLength(1));
      expect(teams.single.name, 'Home Team');
    });

    test('defaultMyTeamProvider は default の自チームを返す', () async {
      final repository = LocalMyTeamRepository(database);
      final store = MyTeamStore(repository);
      await store.createMyTeam(name: 'First');
      final second = await store.createMyTeam(name: 'Second', isDefault: true);

      final container = ProviderContainer(
        overrides: [myTeamStoreProvider.overrideWith((ref) => store)],
      );
      addTearDown(container.dispose);

      final defaultTeam = container.read(defaultMyTeamProvider);

      expect(defaultTeam?.id, second.id);
    });
  });
}
