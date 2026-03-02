import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/supabase_client_provider.dart';
import '../../../auth/presentation/view_models/auth_view_model.dart';
import '../../../games/domain/entities/game.dart';
import '../../../teams/domain/entities/team.dart';

/// ホーム画面の因縁ハイライト用データクラス
class MatchupHighlight {
  const MatchupHighlight({
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

/// 自分が関わる因縁のうち、打数が多いTop3を取得
final matchupHighlightsProvider =
    FutureProvider<List<MatchupHighlight>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  // 自分のplayerIdを取得（playersテーブルからuser_id=自分のID）
  final playerRows = await client
      .from('players')
      .select('id')
      .eq('user_id', user.id);

  if (playerRows.isEmpty) return [];

  final playerIds =
      playerRows.map((r) => r['id'] as String).toList();

  // v_matchup_batter_pitcherから自分が関わる因縁を取得
  // バッターまたはピッチャーとして含まれるもの、打数降順でTop3
  final rows = await client
      .from('v_matchup_batter_pitcher')
      .select()
      .or(playerIds
          .map((id) =>
              'batter_player_id.eq.$id,pitcher_player_id.eq.$id')
          .join(','))
      .order('ab', ascending: false)
      .limit(3);

  return rows
      .map((r) => MatchupHighlight(
            batterId: r['batter_player_id'] as String,
            pitcherId: r['pitcher_player_id'] as String,
            batterName: r['batter_name'] as String? ?? '',
            pitcherName: r['pitcher_name'] as String? ?? '',
            ab: (r['ab'] as num?)?.toInt() ?? 0,
            hits: (r['hits'] as num?)?.toInt() ?? 0,
            avg: (r['avg'] as num?)?.toDouble(),
          ))
      .toList();
});

final myTeamsForHomeProvider = FutureProvider<List<Team>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final memberRows = await client
      .from('team_members')
      .select('team_id')
      .eq('user_id', user.id);

  final teamIds =
      memberRows.map((r) => r['team_id'] as String).toList();
  if (teamIds.isEmpty) return [];

  final teamRows =
      await client.from('teams').select().inFilter('id', teamIds);
  return teamRows.map((r) => Team.fromJson(r)).toList();
});

final recentGamesProvider = FutureProvider<List<Game>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final memberRows = await client
      .from('team_members')
      .select('team_id')
      .eq('user_id', user.id);

  final teamIds =
      memberRows.map((r) => r['team_id'] as String).toList();
  if (teamIds.isEmpty) return [];

  final gameRows = await client
      .from('games')
      .select()
      .or('home_team_id.in.(${teamIds.join(",")}),away_team_id.in.(${teamIds.join(",")})')
      .order('date', ascending: false)
      .limit(3);

  return gameRows.map((r) => Game.fromJson(r)).toList();
});
