import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/supabase_client_provider.dart';
import '../../../auth/presentation/view_models/auth_view_model.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ProfileRepositoryImpl(client);
});

final profileProvider = FutureProvider<UserProfile?>((ref) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) return null;

  final repo = ref.watch(profileRepositoryProvider);
  return repo.getProfile(currentUser.id);
});

class ProfileUpdateState {
  const ProfileUpdateState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  final bool isLoading;
  final String? error;
  final bool isSuccess;

  ProfileUpdateState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
    bool clearError = false,
  }) {
    return ProfileUpdateState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class ProfileUpdateNotifier extends StateNotifier<ProfileUpdateState> {
  ProfileUpdateNotifier(this._repository) : super(const ProfileUpdateState());

  final ProfileRepository _repository;

  Future<void> updateProfile({
    required String userId,
    required String displayName,
    String? photoUrl,
  }) async {
    state = const ProfileUpdateState(isLoading: true);
    try {
      await _repository.updateProfile(
        userId: userId,
        displayName: displayName,
        photoUrl: photoUrl,
      );
      state = const ProfileUpdateState(isSuccess: true);
    } catch (e) {
      state = ProfileUpdateState(error: e.toString());
    }
  }
}

final profileUpdateProvider =
    StateNotifierProvider<ProfileUpdateNotifier, ProfileUpdateState>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return ProfileUpdateNotifier(repo);
});
