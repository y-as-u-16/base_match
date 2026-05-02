import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/features/games/domain/entities/pitching_appearance.dart';

void main() {
  group('PitchingAppearance', () {
    test('コンストラクタに渡した値を保持する', () {
      final createdAt = DateTime.utc(2026, 5, 2, 12);
      final appearance = PitchingAppearance(
        id: '550e8400-e29b-41d4-a716-446655440000',
        gameId: '550e8400-e29b-41d4-a716-446655440001',
        outsPitched: 10,
        runs: 2,
        earnedRuns: 1,
        hitsAllowed: 4,
        walks: 3,
        strikeouts: 5,
        homeRunsAllowed: 1,
        createdAt: createdAt,
      );

      expect(appearance.id, '550e8400-e29b-41d4-a716-446655440000');
      expect(appearance.gameId, '550e8400-e29b-41d4-a716-446655440001');
      expect(appearance.outsPitched, 10);
      expect(appearance.runs, 2);
      expect(appearance.earnedRuns, 1);
      expect(appearance.hitsAllowed, 4);
      expect(appearance.walks, 3);
      expect(appearance.strikeouts, 5);
      expect(appearance.homeRunsAllowed, 1);
      expect(appearance.createdAt, createdAt);
    });
  });
}
