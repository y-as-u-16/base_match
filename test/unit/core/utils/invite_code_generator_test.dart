import 'package:flutter_test/flutter_test.dart';
import 'package:base_match/core/utils/invite_code_generator.dart';
import 'package:base_match/core/constants/app_constants.dart';

void main() {
  group('InviteCodeGenerator', () {
    test('生成されるコードの長さが inviteCodeLength と一致する', () {
      final code = InviteCodeGenerator.generate();

      expect(code.length, AppConstants.inviteCodeLength);
    });

    test('生成されるコードが許可された文字のみを含む', () {
      // InviteCodeGenerator._chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'
      // 紛らわしい文字 (I, O, 0, 1) を除外している
      final allowedChars = RegExp(r'^[ABCDEFGHJKLMNPQRSTUVWXYZ23456789]+$');

      for (var i = 0; i < 100; i++) {
        final code = InviteCodeGenerator.generate();
        expect(allowedChars.hasMatch(code), isTrue,
            reason: 'Code "$code" contains invalid characters');
      }
    });

    test('紛らわしい文字 (I, O, 0, 1) を含まない', () {
      final confusingChars = RegExp(r'[IO01]');

      for (var i = 0; i < 100; i++) {
        final code = InviteCodeGenerator.generate();
        expect(confusingChars.hasMatch(code), isFalse,
            reason: 'Code "$code" contains confusing characters');
      }
    });

    test('複数回生成して重複しない (統計的テスト)', () {
      final codes = <String>{};
      const count = 100;

      for (var i = 0; i < count; i++) {
        codes.add(InviteCodeGenerator.generate());
      }

      // 100個生成して全て異なることを確認
      expect(codes.length, count);
    });
  });
}
