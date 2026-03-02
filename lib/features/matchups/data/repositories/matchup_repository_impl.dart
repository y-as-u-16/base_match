import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import '../../../../core/error/app_exception.dart';
import '../../domain/entities/batter_pitcher_matchup.dart';
import '../../domain/entities/team_matchup.dart';
import '../../domain/repositories/matchup_repository.dart';

class MatchupRepositoryImpl implements MatchupRepository {
  MatchupRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<List<BatterPitcherMatchup>> getBatterPitcherMatchups() async {
    try {
      final data = await _client.from('v_matchup_batter_pitcher').select();
      return data.map((e) => BatterPitcherMatchup.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<List<TeamMatchup>> getTeamMatchups() async {
    try {
      final data = await _client.from('v_matchup_team_team').select();
      return data.map((e) => TeamMatchup.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<BatterPitcherMatchup> getBatterPitcherDetail({
    required String batterPlayerId,
    required String pitcherPlayerId,
  }) async {
    try {
      final data = await _client
          .from('v_matchup_batter_pitcher')
          .select()
          .eq('batter_player_id', batterPlayerId)
          .eq('pitcher_player_id', pitcherPlayerId)
          .single();
      return BatterPitcherMatchup.fromJson(data);
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<TeamMatchup> getTeamMatchupDetail({
    required String teamAId,
    required String teamBId,
  }) async {
    try {
      final data = await _client
          .from('v_matchup_team_team')
          .select()
          .eq('team_a_id', teamAId)
          .eq('team_b_id', teamBId)
          .single();
      return TeamMatchup.fromJson(data);
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }
}
