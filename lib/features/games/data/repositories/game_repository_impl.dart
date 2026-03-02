import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/app_exception.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/plate_appearance.dart';
import '../../domain/entities/player.dart';
import '../../domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  GameRepositoryImpl(this._client);

  final SupabaseClient _client;

  String get _userId => _client.auth.currentUser!.id;

  @override
  Future<Game> createGame({
    required DateTime date,
    String? location,
    required String homeTeamId,
    required String awayTeamId,
    int? innings,
    int? gameNumber,
  }) async {
    try {
      final insertData = <String, dynamic>{
        'date': date.toIso8601String(),
        'location': location,
        'home_team_id': homeTeamId,
        'away_team_id': awayTeamId,
        'status': AppConstants.statusDraft,
        'created_by': _userId,
      };
      if (innings != null) insertData['innings'] = innings;
      if (gameNumber != null) insertData['game_number'] = gameNumber;

      final data = await _client
          .from('games')
          .insert(insertData)
          .select()
          .single();

      return Game.fromJson(data);
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<List<Game>> getGamesByTeam(String teamId) async {
    try {
      final data = await _client
          .from('games')
          .select()
          .or('home_team_id.eq.$teamId,away_team_id.eq.$teamId')
          .order('date', ascending: false);

      return data.map(Game.fromJson).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<Game> getGameDetail(String gameId) async {
    try {
      final data =
          await _client.from('games').select().eq('id', gameId).single();
      return Game.fromJson(data);
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<List<PlateAppearance>> getPlateAppearances(String gameId) async {
    try {
      final data = await _client
          .from('plate_appearances')
          .select()
          .eq('game_id', gameId)
          .order('created_at');

      return data.map(PlateAppearance.fromJson).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<PlateAppearance> addPlateAppearance({
    required String gameId,
    int? inning,
    required String batterPlayerId,
    required String pitcherPlayerId,
    required String resultType,
    required String resultDetail,
    int? rbi,
  }) async {
    try {
      final data = await _client
          .from('plate_appearances')
          .insert({
            'game_id': gameId,
            'inning': inning,
            'batter_player_id': batterPlayerId,
            'pitcher_player_id': pitcherPlayerId,
            'result_type': resultType,
            'result_detail': resultDetail,
            'rbi': rbi,
            'created_by': _userId,
          })
          .select()
          .single();

      return PlateAppearance.fromJson(data);
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<Game> finalizeGame(String gameId) async {
    try {
      // Calculate scores from plate appearances
      final pas = await _client
          .from('plate_appearances')
          .select()
          .eq('game_id', gameId);

      final game = await getGameDetail(gameId);

      // Get players for home and away teams
      final homePlayers = await getPlayersForTeam(game.homeTeamId);
      final homePlayerIds = homePlayers.map((p) => p.id).toSet();

      int homeScore = 0;
      int awayScore = 0;

      for (final pa in pas) {
        final rbi = pa['rbi'] as int? ?? 0;
        final batterId = pa['batter_player_id'] as String;
        if (homePlayerIds.contains(batterId)) {
          homeScore += rbi;
        } else {
          awayScore += rbi;
        }
      }

      final data = await _client
          .from('games')
          .update({
            'status': AppConstants.statusFinal,
            'home_score': homeScore,
            'away_score': awayScore,
          })
          .eq('id', gameId)
          .select()
          .single();

      return Game.fromJson(data);
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<List<Player>> getPlayersForTeam(String teamId) async {
    try {
      final data = await _client
          .from('players')
          .select()
          .eq('team_id', teamId)
          .order('display_name');

      return data.map(Player.fromJson).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<Player> createTempPlayer({
    required String teamId,
    required String displayName,
  }) async {
    try {
      final data = await _client
          .from('players')
          .insert({
            'team_id': teamId,
            'display_name': displayName,
            'user_id': null,
            'created_by': _userId,
          })
          .select()
          .single();

      return Player.fromJson(data);
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }
}
