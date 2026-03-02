import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import '../../../../core/error/app_exception.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const AuthException('ログインに失敗しました');
      }
      return _fetchUserProfile(response.user!.id);
    } on AuthApiException catch (e) {
      throw AuthException(e.message);
    }
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const AuthException('アカウント作成に失敗しました');
      }

      // Create user profile in users table
      await _client.from('users').insert({
        'id': response.user!.id,
        'display_name': displayName,
      });

      return AppUser(
        id: response.user!.id,
        displayName: displayName,
        createdAt: DateTime.now(),
      );
    } on AuthApiException catch (e) {
      throw AuthException(e.message);
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message);
    }
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Stream<AppUser?> authStateChanges() {
    return _client.auth.onAuthStateChange.asyncMap((event) async {
      if (event.session?.user == null) return null;
      try {
        return await _fetchUserProfile(event.session!.user.id);
      } catch (_) {
        return null;
      }
    });
  }

  @override
  AppUser? get currentUser {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    // This is a sync getter, so we return minimal info.
    // Full profile should be fetched via authStateChanges or explicitly.
    return AppUser(
      id: user.id,
      displayName: user.userMetadata?['display_name'] as String? ?? '',
      createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
    );
  }

  Future<AppUser> _fetchUserProfile(String userId) async {
    final data =
        await _client.from('users').select().eq('id', userId).single();
    return AppUser.fromJson(data);
  }
}
