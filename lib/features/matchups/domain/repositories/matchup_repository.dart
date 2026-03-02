import '../entities/batter_pitcher_matchup.dart';
import '../entities/team_matchup.dart';

abstract class MatchupRepository {
  Future<List<BatterPitcherMatchup>> getBatterPitcherMatchups();
  Future<List<TeamMatchup>> getTeamMatchups();
  Future<BatterPitcherMatchup> getBatterPitcherDetail({
    required String batterPlayerId,
    required String pitcherPlayerId,
  });
  Future<TeamMatchup> getTeamMatchupDetail({
    required String teamAId,
    required String teamBId,
  });
}
