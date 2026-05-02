import 'package:flutter_test/flutter_test.dart';
import 'package:base_match/features/games/domain/entities/plate_appearance.dart';

void main() {
  group('PlateAppearance', () {
    final now = DateTime.utc(2025, 5, 10, 10, 30);
    final json = {
      'id': 'pa-1',
      'game_id': 'game-1',
      'inning': 3,
      'result_type': 'hit',
      'result_detail': 'single',
      'rbi': 1,
      'created_at': now.toIso8601String(),
    };

    test('fromJson で正しくパースされる', () {
      final pa = PlateAppearance.fromJson(json);

      expect(pa.id, 'pa-1');
      expect(pa.gameId, 'game-1');
      expect(pa.inning, 3);
      expect(pa.resultType, 'hit');
      expect(pa.resultDetail, 'single');
      expect(pa.rbi, 1);
      expect(pa.createdAt, now);
    });

    test('toJson で正しくシリアライズされる', () {
      final pa = PlateAppearance.fromJson(json);
      final result = pa.toJson();

      expect(result['id'], 'pa-1');
      expect(result['game_id'], 'game-1');
      expect(result['inning'], 3);
      expect(result['result_type'], 'hit');
      expect(result['result_detail'], 'single');
      expect(result['rbi'], 1);
    });

    test('fromJson -> toJson の往復で値が保持される', () {
      final pa = PlateAppearance.fromJson(json);
      final roundTripped = pa.toJson();

      expect(roundTripped, json);
    });

    test('null許容フィールド (inning, rbi) が null の場合', () {
      final jsonNoOptional = {
        'id': 'pa-2',
        'game_id': 'game-1',
        'inning': null,
        'result_type': 'out',
        'result_detail': 'ground',
        'rbi': null,
        'created_at': now.toIso8601String(),
      };
      final pa = PlateAppearance.fromJson(jsonNoOptional);

      expect(pa.inning, isNull);
      expect(pa.rbi, isNull);
    });

    test('copyWith で特定フィールドのみ更新される', () {
      final pa = PlateAppearance.fromJson(json);
      final updated = pa.copyWith(resultType: 'out', resultDetail: 'fly');

      expect(updated.resultType, 'out');
      expect(updated.resultDetail, 'fly');
      expect(updated.id, pa.id);
      expect(updated.gameId, pa.gameId);
    });
  });
}
