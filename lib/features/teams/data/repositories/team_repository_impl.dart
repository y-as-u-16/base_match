import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/utils/invite_code_generator.dart';
import '../../domain/entities/team.dart';
import '../../domain/entities/team_member.dart';
import '../../domain/repositories/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  TeamRepositoryImpl(this._client);

  final SupabaseClient _client;

  String get _userId => _client.auth.currentUser!.id;

  @override
  Future<Team> createTeam({required String name, String? area}) async {
    try {
      final inviteCode = InviteCodeGenerator.generate();

      // Insert team
      final teamData = await _client
          .from('teams')
          .insert({
            'name': name,
            'area': area,
            'invite_code': inviteCode,
            'created_by': _userId,
          })
          .select()
          .single();

      final team = Team.fromJson(teamData);

      // Add creator as owner in team_members
      await _client.from('team_members').insert({
        'team_id': team.id,
        'user_id': _userId,
        'role': AppConstants.roleOwner,
      });

      // Create player entry for the user in this team
      await _client.from('players').insert({
        'team_id': team.id,
        'user_id': _userId,
        'display_name':
            (await _client
                    .from('users')
                    .select('display_name')
                    .eq('id', _userId)
                    .single())['display_name']
                as String,
        'created_by': _userId,
      });

      return team;
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<Team> joinTeamByInviteCode(String inviteCode) async {
    try {
      final teamId = await _client.rpc(
        'join_team_by_invite_code',
        params: {'p_invite_code': inviteCode},
      );
      if (teamId is! String) {
        throw const DatabaseException('チーム参加処理に失敗しました');
      }

      final teamData = await _client
          .from('teams')
          .select()
          .eq('id', teamId)
          .single();
      final team = Team.fromJson(teamData);

      // Create player entry
      await _client.from('players').insert({
        'team_id': team.id,
        'user_id': _userId,
        'display_name':
            (await _client
                    .from('users')
                    .select('display_name')
                    .eq('id', _userId)
                    .single())['display_name']
                as String,
        'created_by': _userId,
      });

      return team;
    } on PostgrestException catch (e) {
      if (e.message.contains('TEAM_NOT_FOUND')) {
        throw const NotFoundException('招待コードに該当するチームが見つかりません');
      }
      if (e.message.contains('ALREADY_MEMBER')) {
        throw const ValidationException('既にこのチームに参加しています');
      }
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<List<Team>> getMyTeams() async {
    try {
      // Get team IDs where user is a member
      final memberRows = await _client
          .from('team_members')
          .select('team_id')
          .eq('user_id', _userId);

      if (memberRows.isEmpty) return [];

      final teamIds = memberRows.map((r) => r['team_id'] as String).toList();

      final teamsData = await _client
          .from('teams')
          .select()
          .inFilter('id', teamIds)
          .order('created_at', ascending: false);

      return teamsData.map(Team.fromJson).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<Team> getTeam(String teamId) async {
    try {
      final data = await _client
          .from('teams')
          .select()
          .eq('id', teamId)
          .single();
      return Team.fromJson(data);
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<List<TeamMember>> getTeamMembers(String teamId) async {
    try {
      final data = await _client
          .from('team_members')
          .select('*, users(display_name)')
          .eq('team_id', teamId)
          .order('created_at');

      return data.map(TeamMember.fromJson).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }
}
