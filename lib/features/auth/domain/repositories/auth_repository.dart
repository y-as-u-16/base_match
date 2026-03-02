import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<AppUser> signIn({required String email, required String password});
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String displayName,
  });
  Future<void> signOut();
  Stream<AppUser?> authStateChanges();
  AppUser? get currentUser;
}
