import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../lib/features/teams/domain/entities/team.dart';
import '../../../../../lib/features/teams/domain/repositories/team_repository.dart';
import '../../../../../lib/features/teams/presentation/view_models/team_view_model.dart';

// Mock classes
class MockTeamRepository extends Mock implements TeamRepository {}

void main() {
  late TeamViewModel viewModel;
  late MockTeamRepository mockRepository;

  setUp(() {
    mockRepository = MockTeamRepository();
    viewModel = TeamViewModel(mockRepository);
  });

  group('TeamViewModel', () {
    group('regenerateInviteCode', () {
      test('should return invite code when successful', () async {
        const teamId = 'test-team-id';
        const expectedCode = 'ABCDEFGH';

        when(() => mockRepository.regenerateInviteCode(teamId))
            .thenAnswer((_) async => expectedCode);

        final result = await viewModel.regenerateInviteCode(teamId);

        expect(result, equals(expectedCode));
        verify(() => mockRepository.regenerateInviteCode(teamId)).called(1);
      });

      test('should return null when repository throws exception', () async {
        const teamId = 'test-team-id';

        when(() => mockRepository.regenerateInviteCode(teamId))
            .thenThrow(Exception('Test error'));

        final result = await viewModel.regenerateInviteCode(teamId);

        expect(result, isNull);
      });
    });
  });
}