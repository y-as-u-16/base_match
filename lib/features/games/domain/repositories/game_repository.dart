import '../entities/game.dart';
import '../entities/pitching_appearance.dart';
import '../entities/plate_appearance.dart';

abstract class GameRepository {
  Future<List<Game>> getGames();

  Future<List<PlateAppearance>> getPlateAppearances();

  Future<List<PitchingAppearance>> getPitchingAppearances();

  Future<Game> createGame({
    required DateTime date,
    required String homeTeamName,
    required String awayTeamName,
    String? location,
    int? innings,
    int homeScore = 0,
    int awayScore = 0,
  });

  Future<Game?> addPlateAppearance({
    required String gameId,
    required String batterName,
    required String resultType,
    required String resultDetail,
    int? inning,
    int? rbi,
  });

  Future<PitchingAppearance> addPitchingAppearance({
    required String gameId,
    required String pitcherName,
    required int outsPitched,
    required int runs,
    required int earnedRuns,
    required int hitsAllowed,
    required int walks,
    required int strikeouts,
    required int homeRunsAllowed,
  });

  Future<void> finalizeGame(String gameId);
}
