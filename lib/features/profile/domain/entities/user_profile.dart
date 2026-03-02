import '../../../auth/domain/entities/app_user.dart';

/// AppUserを拡張した詳細プロフィール。
/// 現在はusersテーブルのカラム（display_name, photo_url）に準拠。
class UserProfile {
  const UserProfile({
    required this.id,
    required this.displayName,
    this.photoUrl,
    required this.createdAt,
  });

  final String id;
  final String displayName;
  final String? photoUrl;
  final DateTime createdAt;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      photoUrl: json['photo_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  factory UserProfile.fromAppUser(AppUser user) {
    return UserProfile(
      id: user.id,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
      createdAt: user.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? displayName,
    String? photoUrl,
    bool clearPhotoUrl = false,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      photoUrl: clearPhotoUrl ? null : (photoUrl ?? this.photoUrl),
      createdAt: createdAt,
    );
  }
}
