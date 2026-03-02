import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/supabase_client_provider.dart';
import '../../data/repositories/game_repository_impl.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/plate_appearance.dart';
import '../../domain/entities/player.dart';
import '../../domain/repositories/game_repository.dart';

/// 試合内の注目の因縁（最も打数が多いバッターxピッチャー）
class GameTopMatchup {
  const GameTopMatchup({
    required this.batterId,
    required this.pitcherId,
    required this.batterName,
    required this.pitcherName,
    required this.ab,
    required this.hits,
    this.avg,
  });

  final String batterId;
  final String pitcherId;
  final String batterName;
  final String pitcherName;
  final int ab;
  final int hits;
  final double? avg;
}

/// 試合の打席データから、最も打数が多いバッターxピッチャーの因縁を取得
final gameTopMatchupProvider =
    FutureProvider.family<GameTopMatchup?, String>((ref, gameId) async {
  final client = ref.watch(supabaseClientProvider);

  // その試合の打席に含まれるバッター/ピッチャーペアを取得
  final pas = await client
      .from('plate_appearances')
      .select('batter_player_id, pitcher_player_id')
      .eq('game_id', gameId);

  if (pas.isEmpty) return null;

  // ユニークなペアを集計
  final pairCounts = <String, Map<String, dynamic>>{};
  for (final pa in pas) {
    final key =
        '${pa['batter_player_id']}|${pa['pitcher_player_id']}';
    pairCounts[key] = pa;
  }

  if (pairCounts.isEmpty) return null;

  // 各ペアについてビューから通算成績を取得し、最もabが多いものを返す
  GameTopMatchup? best;
  for (final entry in pairCounts.entries) {
    final parts = entry.key.split('|');
    final batterId = parts[0];
    final pitcherId = parts[1];

    final rows = await client
        .from('v_matchup_batter_pitcher')
        .select()
        .eq('batter_player_id', batterId)
        .eq('pitcher_player_id', pitcherId)
        .limit(1);

    if (rows.isNotEmpty) {
      final row = rows.first;
      final ab = (row['ab'] as num?)?.toInt() ?? 0;
      if (best == null || ab > best.ab) {
        best = GameTopMatchup(
          batterId: batterId,
          pitcherId: pitcherId,
          batterName: row['batter_name'] as String? ?? '',
          pitcherName: row['pitcher_name'] as String? ?? '',
          ab: ab,
          hits: (row['hits'] as num?)?.toInt() ?? 0,
          avg: (row['avg'] as num?)?.toDouble(),
        );
      }
    }
  }

  return best;
});

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return GameRepositoryImpl(client);
});

final gamesByTeamProvider =
    FutureProvider.family<List<Game>, String>((ref, teamId) async {
  final repo = ref.watch(gameRepositoryProvider);
  return repo.getGamesByTeam(teamId);
});

final gameDetailProvider =
    FutureProvider.family<Game, String>((ref, gameId) async {
  final repo = ref.watch(gameRepositoryProvider);
  return repo.getGameDetail(gameId);
});

final plateAppearancesProvider =
    FutureProvider.family<List<PlateAppearance>, String>((ref, gameId) async {
  final repo = ref.watch(gameRepositoryProvider);
  return repo.getPlateAppearances(gameId);
});

final playersForTeamProvider =
    FutureProvider.family<List<Player>, String>((ref, teamId) async {
  final repo = ref.watch(gameRepositoryProvider);
  return repo.getPlayersForTeam(teamId);
});

class GameViewModel extends StateNotifier<AsyncValue<void>> {
  GameViewModel(this._repository) : super(const AsyncValue.data(null));

  final GameRepository _repository;

  Future<Game?> createGame({
    required DateTime date,
    String? location,
    required String homeTeamId,
    required String awayTeamId,
    int? innings,
    int? gameNumber,
  }) async {
    state = const AsyncValue.loading();
    Game? result;
    state = await AsyncValue.guard(() async {
      result = await _repository.createGame(
        date: date,
        location: location,
        homeTeamId: homeTeamId,
        awayTeamId: awayTeamId,
        innings: innings,
        gameNumber: gameNumber,
      );
    });
    return result;
  }

  Future<PlateAppearance?> addPlateAppearance({
    required String gameId,
    int? inning,
    required String batterPlayerId,
    required String pitcherPlayerId,
    required String resultType,
    required String resultDetail,
    int? rbi,
  }) async {
    state = const AsyncValue.loading();
    PlateAppearance? result;
    state = await AsyncValue.guard(() async {
      result = await _repository.addPlateAppearance(
        gameId: gameId,
        inning: inning,
        batterPlayerId: batterPlayerId,
        pitcherPlayerId: pitcherPlayerId,
        resultType: resultType,
        resultDetail: resultDetail,
        rbi: rbi,
      );
    });
    return result;
  }

  Future<Game?> finalizeGame(String gameId) async {
    state = const AsyncValue.loading();
    Game? result;
    state = await AsyncValue.guard(() async {
      result = await _repository.finalizeGame(gameId);
    });
    return result;
  }

  Future<Player?> createTempPlayer({
    required String teamId,
    required String displayName,
  }) async {
    state = const AsyncValue.loading();
    Player? result;
    state = await AsyncValue.guard(() async {
      result = await _repository.createTempPlayer(
        teamId: teamId,
        displayName: displayName,
      );
    });
    return result;
  }
}

final gameViewModelProvider =
    StateNotifierProvider<GameViewModel, AsyncValue<void>>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return GameViewModel(repository);
});
