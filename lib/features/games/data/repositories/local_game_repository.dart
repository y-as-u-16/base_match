import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/local_db/local_database.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/pitching_appearance.dart';
import '../../domain/entities/plate_appearance.dart';
import '../../domain/repositories/game_repository.dart';
import '../mappers/local_game_mapper.dart';

class LocalGameRepository implements GameRepository {
  LocalGameRepository(this._database, {Uuid? uuid}) : _uuid = uuid ?? Uuid();

  final LocalDatabase _database;
  final Uuid _uuid;

  @override
  Future<List<Game>> getGames() async {
    final rows = await _database.select(_database.localGames).get();
    return rows.map((row) => row.toEntity()).toList();
  }

  @override
  Future<List<PlateAppearance>> getPlateAppearances() async {
    final rows = await _database.select(_database.localPlateAppearances).get();
    return rows.map((row) => row.toEntity()).toList();
  }

  @override
  Future<List<PitchingAppearance>> getPitchingAppearances() async {
    final rows = await _database
        .select(_database.localPitchingAppearances)
        .get();
    return rows.map((row) => row.toEntity()).toList();
  }

  @override
  Future<Game> createGame({
    required DateTime date,
    required String homeTeamName,
    required String awayTeamName,
    String? location,
    int? innings,
  }) async {
    final now = DateTime.now();
    final game = Game(
      id: _id(),
      date: date,
      location: location,
      homeTeamName: homeTeamName,
      awayTeamName: awayTeamName,
      status: AppConstants.statusDraft,
      createdAt: now,
      innings: innings,
      homeScore: 0,
      awayScore: 0,
    );
    await _database.into(_database.localGames).insert(game.toCompanion());
    return game;
  }

  @override
  Future<Game?> addPlateAppearance({
    required String gameId,
    required String resultType,
    required String resultDetail,
    int? inning,
    int? rbi,
  }) async {
    final appearance = PlateAppearance(
      id: _id(),
      gameId: gameId,
      inning: inning,
      resultType: resultType,
      resultDetail: resultDetail,
      rbi: rbi,
      createdAt: DateTime.now(),
    );
    await _database
        .into(_database.localPlateAppearances)
        .insert(appearance.toCompanion());

    final row = await (_database.select(
      _database.localGames,
    )..where((table) => table.id.equals(gameId))).getSingleOrNull();
    if (row == null) return null;

    final updatedScore = (row.homeScore ?? 0) + (rbi ?? 0);
    await (_database.update(_database.localGames)
          ..where((table) => table.id.equals(gameId)))
        .write(LocalGamesCompanion(homeScore: Value(updatedScore)));

    return row.toEntity().copyWith(homeScore: updatedScore);
  }

  @override
  Future<PitchingAppearance> addPitchingAppearance({
    required String gameId,
    required int outsPitched,
    required int runs,
    required int earnedRuns,
    required int hitsAllowed,
    required int walks,
    required int strikeouts,
    required int homeRunsAllowed,
  }) async {
    final appearance = PitchingAppearance(
      id: _id(),
      gameId: gameId,
      outsPitched: outsPitched,
      runs: runs,
      earnedRuns: earnedRuns,
      hitsAllowed: hitsAllowed,
      walks: walks,
      strikeouts: strikeouts,
      homeRunsAllowed: homeRunsAllowed,
      createdAt: DateTime.now(),
    );
    await _database
        .into(_database.localPitchingAppearances)
        .insert(appearance.toCompanion());
    return appearance;
  }

  @override
  Future<void> finalizeGame(String gameId) async {
    await (_database.update(
      _database.localGames,
    )..where((table) => table.id.equals(gameId))).write(
      const LocalGamesCompanion(status: Value(AppConstants.statusFinal)),
    );
  }

  String _id() => _uuid.v4();
}
