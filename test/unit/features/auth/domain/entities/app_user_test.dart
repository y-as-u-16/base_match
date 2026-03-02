import 'package:flutter_test/flutter_test.dart';
import 'package:base_match/features/auth/domain/entities/app_user.dart';

void main() {
  group('AppUser', () {
    final now = DateTime.utc(2025, 1, 15, 10, 30);
    final json = {
      'id': 'user-1',
      'display_name': 'テスト太郎',
      'photo_url': 'https://example.com/photo.png',
      'created_at': now.toIso8601String(),
    };

    test('fromJson で正しくパースされる', () {
      final user = AppUser.fromJson(json);

      expect(user.id, 'user-1');
      expect(user.displayName, 'テスト太郎');
      expect(user.photoUrl, 'https://example.com/photo.png');
      expect(user.createdAt, now);
    });

    test('toJson で正しくシリアライズされる', () {
      final user = AppUser(
        id: 'user-1',
        displayName: 'テスト太郎',
        photoUrl: 'https://example.com/photo.png',
        createdAt: now,
      );

      final result = user.toJson();

      expect(result['id'], 'user-1');
      expect(result['display_name'], 'テスト太郎');
      expect(result['photo_url'], 'https://example.com/photo.png');
      expect(result['created_at'], now.toIso8601String());
    });

    test('fromJson -> toJson の往復で値が保持される', () {
      final user = AppUser.fromJson(json);
      final roundTripped = user.toJson();

      expect(roundTripped, json);
    });

    test('photoUrl が null の場合に正しく処理される', () {
      final jsonWithoutPhoto = Map<String, dynamic>.from(json)
        ..['photo_url'] = null;
      final user = AppUser.fromJson(jsonWithoutPhoto);

      expect(user.photoUrl, isNull);
      expect(user.toJson()['photo_url'], isNull);
    });

    test('copyWith で特定フィールドのみ更新される', () {
      final user = AppUser.fromJson(json);
      final updated = user.copyWith(displayName: '更新太郎');

      expect(updated.displayName, '更新太郎');
      expect(updated.id, user.id);
      expect(updated.photoUrl, user.photoUrl);
      expect(updated.createdAt, user.createdAt);
    });
  });
}
