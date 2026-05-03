import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/my_team_repository_provider.dart';
import '../../domain/entities/my_team.dart';
import '../../domain/repositories/my_team_repository.dart';

class MyTeamState {
  const MyTeamState({this.teams = const []});

  final List<MyTeam> teams;

  MyTeamState copyWith({List<MyTeam>? teams}) {
    return MyTeamState(teams: teams ?? this.teams);
  }
}

final myTeamStoreProvider = StateNotifierProvider<MyTeamStore, MyTeamState>((
  ref,
) {
  final repository = ref.watch(myTeamRepositoryProvider);
  return MyTeamStore(repository)..load();
});

final myTeamsProvider = Provider<List<MyTeam>>((ref) {
  return ref.watch(myTeamStoreProvider).teams;
});

final myTeamByIdProvider = Provider<Map<String, MyTeam>>((ref) {
  final teams = ref.watch(myTeamsProvider);
  return {for (final team in teams) team.id: team};
});

final defaultMyTeamProvider = Provider<MyTeam?>((ref) {
  final teams = ref.watch(myTeamStoreProvider).teams;
  return teams.where((team) => team.isDefault).firstOrNull;
});

class MyTeamStore extends StateNotifier<MyTeamState> {
  MyTeamStore(this._repository) : super(const MyTeamState());

  final MyTeamRepository _repository;

  Future<void> load() async {
    final teams = await _repository.getMyTeams();
    state = MyTeamState(teams: teams);
  }

  Future<MyTeam> createMyTeam({
    required String name,
    String? colorKey,
    bool isDefault = false,
  }) async {
    final team = await _repository.createMyTeam(
      name: name,
      colorKey: colorKey,
      isDefault: isDefault,
    );

    final teams = [
      ...state.teams.map(
        (current) =>
            team.isDefault ? current.copyWith(isDefault: false) : current,
      ),
      team,
    ]..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    state = state.copyWith(teams: teams);
    return team;
  }
}
