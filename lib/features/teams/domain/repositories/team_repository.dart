import '../entities/team.dart';
import '../entities/team_member.dart';

abstract class TeamRepository {
  Future<List<Team>> getMyTeams();
  Future<Team> getTeam(String teamId);
  Future<Team> createTeam({required String name, String? area});
  Future<Team> joinTeamByInviteCode(String inviteCode);
  Future<List<TeamMember>> getTeamMembers(String teamId);
  Future<String> regenerateInviteCode(String teamId); // 既存の招待コードを新しいコードに更新して返す：招待コード発行画面用
}
