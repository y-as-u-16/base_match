import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/supabase_client_provider.dart';
import '../../data/repositories/matchup_repository_impl.dart';
import '../../domain/entities/batter_pitcher_matchup.dart';
import '../../domain/entities/team_matchup.dart';
import '../../domain/repositories/matchup_repository.dart';

final matchupRepositoryProvider = Provider<MatchupRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return MatchupRepositoryImpl(client);
});

final batterPitcherMatchupsProvider =
    FutureProvider<List<BatterPitcherMatchup>>((ref) async {
  final repo = ref.watch(matchupRepositoryProvider);
  return repo.getBatterPitcherMatchups();
});

final teamMatchupsProvider = FutureProvider<List<TeamMatchup>>((ref) async {
  final repo = ref.watch(matchupRepositoryProvider);
  return repo.getTeamMatchups();
});

final batterPitcherDetailProvider =
    FutureProvider.family<BatterPitcherMatchup, ({String batterId, String pitcherId})>(
  (ref, params) async {
    final repo = ref.watch(matchupRepositoryProvider);
    return repo.getBatterPitcherDetail(
      batterPlayerId: params.batterId,
      pitcherPlayerId: params.pitcherId,
    );
  },
);

final teamMatchupDetailProvider =
    FutureProvider.family<TeamMatchup, ({String teamAId, String teamBId})>(
  (ref, params) async {
    final repo = ref.watch(matchupRepositoryProvider);
    return repo.getTeamMatchupDetail(
      teamAId: params.teamAId,
      teamBId: params.teamBId,
    );
  },
);
