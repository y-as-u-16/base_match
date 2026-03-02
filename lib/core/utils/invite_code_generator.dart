import 'dart:math';

import '../constants/app_constants.dart';

class InviteCodeGenerator {
  InviteCodeGenerator._();

  static const _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  static String generate() {
    final random = Random.secure();
    return List.generate(
      AppConstants.inviteCodeLength,
      (_) => _chars[random.nextInt(_chars.length)],
    ).join();
  }
}
