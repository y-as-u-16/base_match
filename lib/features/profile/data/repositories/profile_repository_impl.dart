import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import '../../../../core/error/app_exception.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<UserProfile> getProfile(String userId) async {
    try {
      final data =
          await _client.from('users').select().eq('id', userId).single();
      return UserProfile.fromJson(data);
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<UserProfile> updateProfile({
    required String userId,
    required String displayName,
    String? photoUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'display_name': displayName,
        'photo_url': photoUrl,
      };

      final data = await _client
          .from('users')
          .update(updateData)
          .eq('id', userId)
          .select()
          .single();
      return UserProfile.fromJson(data);
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }
}
