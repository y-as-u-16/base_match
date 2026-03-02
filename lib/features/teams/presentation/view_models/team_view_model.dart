import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/supabase_client_provider.dart';
import '../../data/repositories/team_repository_impl.dart';
import '../../domain/entities/team.dart';
import '../../domain/entities/team_member.dart';
import '../../domain/repositories/team_repository.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TeamRepositoryImpl(client);
});

final myTeamsProvider = FutureProvider<List<Team>>((ref) async {
  final repo = ref.watch(teamRepositoryProvider);
  return repo.getMyTeams();
});

final teamDetailProvider =
    FutureProvider.family<Team, String>((ref, teamId) async {
  final repo = ref.watch(teamRepositoryProvider);
  return repo.getTeam(teamId);
});

final teamMembersProvider =
    FutureProvider.family<List<TeamMember>, String>((ref, teamId) async {
  final repo = ref.watch(teamRepositoryProvider);
  return repo.getTeamMembers(teamId);
});

class TeamViewModel extends StateNotifier<AsyncValue<void>> {
  TeamViewModel(this._repository) : super(const AsyncValue.data(null));

  final TeamRepository _repository;

  Future<Team?> createTeam({required String name, String? area}) async {
    state = const AsyncValue.loading();
    Team? result;
    state = await AsyncValue.guard(() async {
      result = await _repository.createTeam(name: name, area: area);
    });
    return result;
  }

  Future<Team?> joinTeamByInviteCode(String inviteCode) async {
    state = const AsyncValue.loading();
    Team? result;
    state = await AsyncValue.guard(() async {
      result = await _repository.joinTeamByInviteCode(inviteCode);
    });
    return result;
  }
}

final teamViewModelProvider =
    StateNotifierProvider<TeamViewModel, AsyncValue<void>>((ref) {
  final repository = ref.watch(teamRepositoryProvider);
  return TeamViewModel(repository);
});
