import '../entities/my_team.dart';

abstract class MyTeamRepository {
  Future<List<MyTeam>> getMyTeams();

  Future<MyTeam?> getDefaultMyTeam();

  Future<MyTeam> createMyTeam({
    required String name,
    String? colorKey,
    bool isDefault = false,
  });
}
