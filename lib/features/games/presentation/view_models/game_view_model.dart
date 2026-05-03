import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/local_db/local_database_provider.dart';
import '../../data/repositories/local_game_repository.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/pitching_appearance.dart';
import '../../domain/entities/plate_appearance.dart';
import '../../domain/repositories/game_repository.dart';

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
      final repository = LocalGameRepository(database);
      return LocalGameStore(repository)..load();
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
  LocalGameStore(this._repository) : super(const LocalGameState());

  final GameRepository _repository;

  Future<void> load() async {
    final games = await _repository.getGames();
    final plateAppearances = await _repository.getPlateAppearances();
    final pitchingAppearances = await _repository.getPitchingAppearances();
    state = LocalGameState(
      games: games,
      plateAppearances: plateAppearances,
      pitchingAppearances: pitchingAppearances,
    );
  }

  Future<Game> createGame({
    required DateTime date,
    required String myTeamId,
    required String awayTeamName,
    String? location,
    int? innings,
    int homeScore = 0,
    int awayScore = 0,
  }) async {
    final game = await _repository.createGame(
      date: date,
      location: location,
      myTeamId: myTeamId,
      awayTeamName: awayTeamName,
      innings: innings,
      homeScore: homeScore,
      awayScore: awayScore,
    );
    state = state.copyWith(games: [...state.games, game]);
    return game;
  }

  Future<PlateAppearance> addPlateAppearance({
    required String gameId,
    required String batterName,
    required String resultType,
    required String resultDetail,
    int? inning,
    int? rbi,
  }) async {
    final updatedGame = await _repository.addPlateAppearance(
      gameId: gameId,
      batterName: batterName,
      inning: inning,
      resultType: resultType,
      resultDetail: resultDetail,
      rbi: rbi,
    );
    if (updatedGame == null) {
      throw ArgumentError.value(gameId, 'gameId', 'Game does not exist.');
    }
    final plateAppearances = await _repository.getPlateAppearances();
    final games = state.games
        .map((game) => game.id == gameId ? updatedGame : game)
        .toList();
    final appearance = plateAppearances.last;

    state = state.copyWith(games: games, plateAppearances: plateAppearances);
    return appearance;
  }

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
    final appearance = await _repository.addPitchingAppearance(
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
    state = state.copyWith(
      pitchingAppearances: [...state.pitchingAppearances, appearance],
    );
    return appearance;
  }

  Future<void> finalizeGame(String gameId) async {
    await _repository.finalizeGame(gameId);
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
}
