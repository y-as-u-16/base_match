import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/local_db/local_database.dart';
import '../../../../core/local_db/local_database_provider.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/pitching_appearance.dart';
import '../../domain/entities/plate_appearance.dart';

class LocalGameState {
  const LocalGameState({
    this.games = const [],
    this.plateAppearances = const [],
    this.pitchingAppearances = const [],
  });

  final List<Game> games;
  final List<PlateAppearance> plateAppearances;
  final List<PitchingAppearance> pitchingAppearances;

  LocalGameState copyWith({
    List<Game>? games,
    List<PlateAppearance>? plateAppearances,
    List<PitchingAppearance>? pitchingAppearances,
  }) {
    return LocalGameState(
      games: games ?? this.games,
      plateAppearances: plateAppearances ?? this.plateAppearances,
      pitchingAppearances: pitchingAppearances ?? this.pitchingAppearances,
    );
  }
}

final localGameStoreProvider =
    StateNotifierProvider<LocalGameStore, LocalGameState>((ref) {
      final database = ref.watch(localDatabaseProvider);
      return LocalGameStore(database)..load();
    });

final gamesProvider = Provider<List<Game>>((ref) {
  final games = ref.watch(localGameStoreProvider).games.toList()
    ..sort((a, b) => b.date.compareTo(a.date));
  return games;
});

final gameDetailProvider = Provider.family<Game?, String>((ref, gameId) {
  return ref
      .watch(localGameStoreProvider)
      .games
      .where((game) => game.id == gameId)
      .firstOrNull;
});

final plateAppearancesProvider = Provider.family<List<PlateAppearance>, String>(
  (ref, gameId) {
    return ref
        .watch(localGameStoreProvider)
        .plateAppearances
        .where((appearance) => appearance.gameId == gameId)
        .toList();
  },
);

final pitchingAppearancesProvider =
    Provider.family<List<PitchingAppearance>, String>((ref, gameId) {
      return ref
          .watch(localGameStoreProvider)
          .pitchingAppearances
          .where((appearance) => appearance.gameId == gameId)
          .toList();
    });

class LocalGameStore extends StateNotifier<LocalGameState> {
  LocalGameStore(this._database) : super(const LocalGameState());

  final LocalDatabase _database;

  Future<void> load() async {
    final games = await _database.select(_database.localGames).get();
    final plateAppearances = await _database
        .select(_database.localPlateAppearances)
        .get();
    final pitchingAppearances = await _database
        .select(_database.localPitchingAppearances)
        .get();
    state = LocalGameState(
      games: games.map(_gameFromRow).toList(),
      plateAppearances: plateAppearances.map(_plateAppearanceFromRow).toList(),
      pitchingAppearances: pitchingAppearances
          .map(_pitchingAppearanceFromRow)
          .toList(),
    );
  }

  Future<Game> createGame({
    required DateTime date,
    required String homeTeamName,
    required String awayTeamName,
    String? location,
    int? innings,
    int? gameNumber,
  }) async {
    final now = DateTime.now();
    final game = Game(
      id: _id('game'),
      date: date,
      location: location,
      homeTeamName: homeTeamName,
      awayTeamName: awayTeamName,
      status: AppConstants.statusDraft,
      createdAt: now,
      innings: innings,
      gameNumber: gameNumber,
      homeScore: 0,
      awayScore: 0,
    );
    await _database
        .into(_database.localGames)
        .insert(
          LocalGamesCompanion.insert(
            id: game.id,
            date: game.date,
            location: Value(game.location),
            homeTeamName: game.homeTeamName,
            awayTeamName: game.awayTeamName,
            homeScore: Value(game.homeScore),
            awayScore: Value(game.awayScore),
            status: game.status,
            createdAt: game.createdAt,
            innings: Value(game.innings),
            gameNumber: Value(game.gameNumber),
          ),
        );
    state = state.copyWith(games: [...state.games, game]);
    return game;
  }

  Future<PlateAppearance> addPlateAppearance({
    required String gameId,
    required String resultType,
    required String resultDetail,
    int? inning,
    int? rbi,
  }) async {
    final appearance = PlateAppearance(
      id: _id('pa'),
      gameId: gameId,
      inning: inning,
      resultType: resultType,
      resultDetail: resultDetail,
      rbi: rbi,
      createdAt: DateTime.now(),
    );
    await _database
        .into(_database.localPlateAppearances)
        .insert(
          LocalPlateAppearancesCompanion.insert(
            id: appearance.id,
            gameId: appearance.gameId,
            inning: Value(appearance.inning),
            resultType: appearance.resultType,
            resultDetail: appearance.resultDetail,
            rbi: Value(appearance.rbi),
            createdAt: appearance.createdAt,
          ),
        );

    final games = state.games.map((game) {
      if (game.id != gameId) return game;
      final runs = rbi ?? 0;
      return game.copyWith(homeScore: (game.homeScore ?? 0) + runs);
    }).toList();
    final updatedGame = games.where((game) => game.id == gameId).firstOrNull;
    if (updatedGame != null) {
      await (_database.update(_database.localGames)
            ..where((table) => table.id.equals(gameId)))
          .write(LocalGamesCompanion(homeScore: Value(updatedGame.homeScore)));
    }

    state = state.copyWith(
      games: games,
      plateAppearances: [...state.plateAppearances, appearance],
    );
    return appearance;
  }

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
      id: _id('pit'),
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
        .insert(
          LocalPitchingAppearancesCompanion.insert(
            id: appearance.id,
            gameId: appearance.gameId,
            outsPitched: appearance.outsPitched,
            runs: appearance.runs,
            earnedRuns: appearance.earnedRuns,
            hitsAllowed: appearance.hitsAllowed,
            walks: appearance.walks,
            strikeouts: appearance.strikeouts,
            homeRunsAllowed: appearance.homeRunsAllowed,
            createdAt: appearance.createdAt,
          ),
        );
    state = state.copyWith(
      pitchingAppearances: [...state.pitchingAppearances, appearance],
    );
    return appearance;
  }

  Future<void> finalizeGame(String gameId) async {
    await (_database.update(
      _database.localGames,
    )..where((table) => table.id.equals(gameId))).write(
      const LocalGamesCompanion(status: Value(AppConstants.statusFinal)),
    );
    state = state.copyWith(
      games: state.games
          .map(
            (game) => game.id == gameId
                ? game.copyWith(status: AppConstants.statusFinal)
                : game,
          )
          .toList(),
    );
  }

  String _id(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';

  Game _gameFromRow(LocalGame row) {
    return Game(
      id: row.id,
      date: row.date,
      location: row.location,
      homeTeamName: row.homeTeamName,
      awayTeamName: row.awayTeamName,
      homeScore: row.homeScore,
      awayScore: row.awayScore,
      status: row.status,
      createdAt: row.createdAt,
      innings: row.innings,
      gameNumber: row.gameNumber,
    );
  }

  PlateAppearance _plateAppearanceFromRow(LocalPlateAppearance row) {
    return PlateAppearance(
      id: row.id,
      gameId: row.gameId,
      inning: row.inning,
      resultType: row.resultType,
      resultDetail: row.resultDetail,
      rbi: row.rbi,
      createdAt: row.createdAt,
    );
  }

  PitchingAppearance _pitchingAppearanceFromRow(LocalPitchingAppearance row) {
    return PitchingAppearance(
      id: row.id,
      gameId: row.gameId,
      outsPitched: row.outsPitched,
      runs: row.runs,
      earnedRuns: row.earnedRuns,
      hitsAllowed: row.hitsAllowed,
      walks: row.walks,
      strikeouts: row.strikeouts,
      homeRunsAllowed: row.homeRunsAllowed,
      createdAt: row.createdAt,
    );
  }
}
