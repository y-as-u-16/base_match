import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
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
      return LocalGameStore();
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
  LocalGameStore() : super(const LocalGameState());

  Game createGame({
    required DateTime date,
    required String homeTeamName,
    required String awayTeamName,
    String? location,
    int? innings,
    int? gameNumber,
  }) {
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
    state = state.copyWith(games: [...state.games, game]);
    return game;
  }

  PlateAppearance addPlateAppearance({
    required String gameId,
    required String battingSide,
    required String resultType,
    required String resultDetail,
    int? inning,
    int? rbi,
  }) {
    final appearance = PlateAppearance(
      id: _id('pa'),
      gameId: gameId,
      inning: inning,
      battingSide: battingSide,
      resultType: resultType,
      resultDetail: resultDetail,
      rbi: rbi,
      createdAt: DateTime.now(),
    );

    final games = state.games.map((game) {
      if (game.id != gameId) return game;
      final runs = rbi ?? 0;
      if (battingSide == AppConstants.sideHome) {
        return game.copyWith(homeScore: (game.homeScore ?? 0) + runs);
      }
      return game.copyWith(awayScore: (game.awayScore ?? 0) + runs);
    }).toList();

    state = state.copyWith(
      games: games,
      plateAppearances: [...state.plateAppearances, appearance],
    );
    return appearance;
  }

  PitchingAppearance addPitchingAppearance({
    required String gameId,
    required String pitchingSide,
    required int outsPitched,
    required int runs,
    required int earnedRuns,
    required int hitsAllowed,
    required int walks,
    required int strikeouts,
    required int homeRunsAllowed,
  }) {
    final appearance = PitchingAppearance(
      id: _id('pit'),
      gameId: gameId,
      pitchingSide: pitchingSide,
      outsPitched: outsPitched,
      runs: runs,
      earnedRuns: earnedRuns,
      hitsAllowed: hitsAllowed,
      walks: walks,
      strikeouts: strikeouts,
      homeRunsAllowed: homeRunsAllowed,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(
      pitchingAppearances: [...state.pitchingAppearances, appearance],
    );
    return appearance;
  }

  void finalizeGame(String gameId) {
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
}
