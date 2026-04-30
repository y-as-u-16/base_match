import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../lib/core/routing/app_router.dart';
import '../../../lib/features/auth/presentation/view_models/auth_view_model.dart';
import '../../../lib/features/teams/domain/entities/team.dart';
import '../../../lib/features/teams/presentation/pages/invite_code_page.dart';
import '../../../lib/features/teams/presentation/view_models/team_view_model.dart';

// Mock classes
class MockTeamRepository extends Mock implements TeamRepository {}

void main() {
  late MockTeamRepository mockRepository;

  setUp(() {
    mockRepository = MockTeamRepository();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        teamRepositoryProvider.overrideWithValue(mockRepository),
        // Mock auth state
        authStateProvider.overrideWith((ref) => Stream.value(null)),
      ],
      child: MaterialApp.router(
        routerConfig: routerProvider,
        // Override the router to show InviteCodePage directly
        builder: (context, child) => InviteCodePage(),
      ),
    );
  }

  group('InviteCodePage', () {
    testWidgets('should display page title', (tester) async {
      // Mock myTeamsProvider to return empty list
      when(() => mockRepository.getMyTeams()).thenAnswer((_) async => []);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('招待コード発行'), findsOneWidget);
    });

    testWidgets('should show team selection dropdown when teams exist', (tester) async {
      final teams = [
        Team(id: '1', name: 'Team A', area: null, inviteCode: 'ABC123', createdBy: 'user1', createdAt: DateTime.now()),
      ];

      when(() => mockRepository.getMyTeams()).thenAnswer((_) async => teams);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('チームを選択'), findsOneWidget);
      expect(find.text('Team A'), findsOneWidget);
    });

    testWidgets('should show validation error when no team selected', (tester) async {
      final teams = [
        Team(id: '1', name: 'Team A', area: null, inviteCode: 'ABC123', createdBy: 'user1', createdAt: DateTime.now()),
      ];

      when(() => mockRepository.getMyTeams()).thenAnswer((_) async => teams);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap generate button without selecting team
      await tester.tap(find.text('発行する'));
      await tester.pumpAndSettle();

      expect(find.text('チームを選択してください'), findsOneWidget);
    });

    testWidgets('should display generated code after successful generation', (tester) async {
      final teams = [
        Team(id: '1', name: 'Team A', area: null, inviteCode: 'ABC123', createdBy: 'user1', createdAt: DateTime.now()),
      ];
      const generatedCode = 'XYZ789';

      when(() => mockRepository.getMyTeams()).thenAnswer((_) async => teams);
      when(() => mockRepository.regenerateInviteCode('1')).thenAnswer((_) async => generatedCode);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Select team
      await tester.tap(find.text('チームを選択'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Team A').last);
      await tester.pumpAndSettle();

      // Tap generate button
      await tester.tap(find.text('発行する'));
      await tester.pumpAndSettle();

      // Should display the generated code
      expect(find.text(generatedCode), findsOneWidget);
      expect(find.text('招待コード'), findsOneWidget);
    });
  });
}