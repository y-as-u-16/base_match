import '../entities/game.dart';
import '../entities/plate_appearance.dart';
import '../entities/player.dart';

abstract class GameRepository {
  Future<Game> createGame({
    required DateTime date,
    String? location,
    required String homeTeamId,
    required String awayTeamId,
    int? innings,
    int? gameNumber,
  });

  Future<List<Game>> getGamesByTeam(String teamId);

  Future<Game> getGameDetail(String gameId);

  Future<List<PlateAppearance>> getPlateAppearances(String gameId);

  Future<PlateAppearance> addPlateAppearance({
    required String gameId,
    int? inning,
    required String batterPlayerId,
    required String pitcherPlayerId,
    required String resultType,
    required String resultDetail,
    int? rbi,
  });

  Future<Game> finalizeGame(String gameId);

  Future<List<Player>> getPlayersForTeam(String teamId);

  Future<Player> createTempPlayer({
    required String teamId,
    required String displayName,
  });
}
