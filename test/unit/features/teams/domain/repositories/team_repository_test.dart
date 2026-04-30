import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:base_match/core/error/app_exception.dart';
import 'package:base_match/features/teams/data/repositories/team_repository_impl.dart';
import 'package:base_match/features/teams/domain/entities/team.dart';
import 'package:base_match/features/teams/domain/entities/team_member.dart';
import 'package:base_match/features/teams/domain/repositories/team_repository.dart';

// Mock classes
class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockUser extends Mock implements User {}

void main() {
  late TeamRepositoryImpl repository;
  late MockSupabaseClient mockClient;

  setUp(() {
    mockClient = MockSupabaseClient();
    repository = TeamRepositoryImpl(mockClient);
  });

  group('TeamRepositoryImpl', () {
    const testUserId = 'test-user-id';

    setUp(() {
      // Mock auth user
      final mockUser = MockUser();
      when(() => mockUser.id).thenReturn(testUserId);
      when(() => mockClient.auth.currentUser).thenReturn(mockUser);
    });

    group('regenerateInviteCode', () {
      test('should call update on teams table and return invite code', () async {
        const teamId = 'test-team-id';

        // Mock the chain using dynamic mock
        final mockQueryBuilder = MockQueryBuilder();

        when(() => mockClient.from('teams')).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.update(any())).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.eq(any(), any())).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.execute()).thenAnswer((_) async => PostgrestResponse(data: null, count: 0));

        final result = await repository.regenerateInviteCode(teamId);

        expect(result, isA<String>());
        expect(result.length, 8); // invite code length
        verify(() => mockClient.from('teams')).called(1);
        verify(() => mockQueryBuilder.update(any())).called(1);
      });

      test('should throw DatabaseException when update fails', () async {
        const teamId = 'test-team-id';

        final mockQueryBuilder = MockQueryBuilder();

        when(() => mockClient.from('teams')).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.update(any())).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.eq(any(), any())).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.execute()).thenAnswer((_) async => throw PostgrestException(message: 'Update failed'));

        expect(
          () => repository.regenerateInviteCode(teamId),
          throwsA(isA<DatabaseException>()),
        );
      });
    });
  });
}