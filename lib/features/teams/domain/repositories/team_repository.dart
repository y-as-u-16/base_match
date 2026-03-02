import '../entities/team.dart';
import '../entities/team_member.dart';

abstract class TeamRepository {
  Future<List<Team>> getMyTeams();
  Future<Team> getTeam(String teamId);
  Future<Team> createTeam({required String name, String? area});
  Future<Team> joinTeamByInviteCode(String inviteCode);
  Future<List<TeamMember>> getTeamMembers(String teamId);
}
