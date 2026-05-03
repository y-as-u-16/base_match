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
    int homeScore = 0,
    int awayScore = 0,
  }) async {
    _validateGameInput(
      homeTeamName: homeTeamName,
      awayTeamName: awayTeamName,
      innings: innings,
      homeScore: homeScore,
      awayScore: awayScore,
    );

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
      homeScore: homeScore,
      awayScore: awayScore,
    );
    await _database.into(_database.localGames).insert(game.toCompanion());
    return game;
  }

  @override
  Future<Game?> addPlateAppearance({
    required String gameId,
    required String batterName,
    required String resultType,
    required String resultDetail,
    int? inning,
    int? rbi,
  }) async {
    _validatePlateAppearanceInput(
      gameId: gameId,
      batterName: batterName,
      resultType: resultType,
      resultDetail: resultDetail,
      inning: inning,
      rbi: rbi,
    );

    final row = await _findGameRow(gameId);
    if (row == null) return null;

    final appearance = PlateAppearance(
      id: _id(),
      gameId: gameId,
      batterName: batterName.trim(),
      inning: inning,
      resultType: resultType,
      resultDetail: resultDetail,
      rbi: rbi,
      createdAt: DateTime.now(),
    );
    await _database
        .into(_database.localPlateAppearances)
        .insert(appearance.toCompanion());

    return row.toEntity();
  }

  @override
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
  }) async {
    _validatePitchingAppearanceInput(
      gameId: gameId,
      pitcherName: pitcherName,
      outsPitched: outsPitched,
      runs: runs,
      earnedRuns: earnedRuns,
      hitsAllowed: hitsAllowed,
      walks: walks,
      strikeouts: strikeouts,
      homeRunsAllowed: homeRunsAllowed,
    );

    if (await _findGameRow(gameId) == null) {
      throw ArgumentError.value(gameId, 'gameId', 'Game does not exist.');
    }

    final appearance = PitchingAppearance(
      id: _id(),
      gameId: gameId,
      pitcherName: pitcherName.trim(),
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

  Future<LocalGame?> _findGameRow(String gameId) {
    return (_database.select(
      _database.localGames,
    )..where((table) => table.id.equals(gameId))).getSingleOrNull();
  }

  String _id() => _uuid.v4();

  void _validateGameInput({
    required String homeTeamName,
    required String awayTeamName,
    required int? innings,
    required int homeScore,
    required int awayScore,
  }) {
    if (homeTeamName.trim().isEmpty) {
      throw ArgumentError.value(homeTeamName, 'homeTeamName', 'Required.');
    }
    if (awayTeamName.trim().isEmpty) {
      throw ArgumentError.value(awayTeamName, 'awayTeamName', 'Required.');
    }
    if (innings != null && innings <= 0) {
      throw ArgumentError.value(innings, 'innings', 'Must be positive.');
    }
    if (homeScore < 0) {
      throw ArgumentError.value(
        homeScore,
        'homeScore',
        'Must not be negative.',
      );
    }
    if (awayScore < 0) {
      throw ArgumentError.value(
        awayScore,
        'awayScore',
        'Must not be negative.',
      );
    }
  }

  void _validatePlateAppearanceInput({
    required String gameId,
    required String batterName,
    required String resultType,
    required String resultDetail,
    required int? inning,
    required int? rbi,
  }) {
    if (gameId.trim().isEmpty) {
      throw ArgumentError.value(gameId, 'gameId', 'Required.');
    }
    if (batterName.trim().isEmpty) {
      throw ArgumentError.value(batterName, 'batterName', 'Required.');
    }
    if (resultType.trim().isEmpty) {
      throw ArgumentError.value(resultType, 'resultType', 'Required.');
    }
    if (resultDetail.trim().isEmpty) {
      throw ArgumentError.value(resultDetail, 'resultDetail', 'Required.');
    }
    if (inning != null && inning <= 0) {
      throw ArgumentError.value(inning, 'inning', 'Must be positive.');
    }
    if (rbi != null && rbi < 0) {
      throw ArgumentError.value(rbi, 'rbi', 'Must not be negative.');
    }
  }

  void _validatePitchingAppearanceInput({
    required String gameId,
    required String pitcherName,
    required int outsPitched,
    required int runs,
    required int earnedRuns,
    required int hitsAllowed,
    required int walks,
    required int strikeouts,
    required int homeRunsAllowed,
  }) {
    if (gameId.trim().isEmpty) {
      throw ArgumentError.value(gameId, 'gameId', 'Required.');
    }
    if (pitcherName.trim().isEmpty) {
      throw ArgumentError.value(pitcherName, 'pitcherName', 'Required.');
    }
    if (outsPitched <= 0) {
      throw ArgumentError.value(
        outsPitched,
        'outsPitched',
        'Must be positive.',
      );
    }
    final values = {
      'runs': runs,
      'earnedRuns': earnedRuns,
      'hitsAllowed': hitsAllowed,
      'walks': walks,
      'strikeouts': strikeouts,
      'homeRunsAllowed': homeRunsAllowed,
    };
    for (final entry in values.entries) {
      if (entry.value < 0) {
        throw ArgumentError.value(
          entry.value,
          entry.key,
          'Must not be negative.',
        );
      }
    }
  }
}
