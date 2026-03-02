import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:base_match/features/matchups/domain/entities/batter_pitcher_matchup.dart';
import 'package:base_match/features/matchups/domain/entities/team_matchup.dart';
import 'package:base_match/features/matchups/domain/repositories/matchup_repository.dart';
import 'package:base_match/features/matchups/presentation/pages/matchup_list_page.dart';
import 'package:base_match/features/matchups/presentation/view_models/matchup_view_model.dart';

class MockMatchupRepository extends Mock implements MatchupRepository {}

void main() {
  late MockMatchupRepository mockMatchupRepo;

  final mockBatterPitcherList = [
    const BatterPitcherMatchup(
      batterPlayerId: 'batter-1',
      pitcherPlayerId: 'pitcher-1',
      batterName: 'テスト打者',
      pitcherName: 'テスト投手',
      ab: 20,
      hits: 8,
      hr: 2,
      bbHbp: 3,
      so: 5,
      avg: 0.400,
    ),
  ];

  final mockTeamMatchupList = [
    const TeamMatchup(
      teamAId: 'team-a',
      teamBId: 'team-b',
      teamAName: 'テストチームA',
      teamBName: 'テストチームB',
      games: 10,
      winsA: 6,
      winsB: 3,
      draws: 1,
      runsA: 45,
      runsB: 30,
    ),
  ];

  setUp(() {
    mockMatchupRepo = MockMatchupRepository();
  });

  Widget buildSubject() {
    return ProviderScope(
      overrides: [
        matchupRepositoryProvider.overrideWithValue(mockMatchupRepo),
      ],
      child: const MaterialApp(
        home: MatchupListPage(),
      ),
    );
  }

  group('MatchupListPage', () {
    testWidgets('AppBarに「因縁一覧」が表示される', (tester) async {
      when(() => mockMatchupRepo.getBatterPitcherMatchups())
          .thenAnswer((_) async => mockBatterPitcherList);
      when(() => mockMatchupRepo.getTeamMatchups())
          .thenAnswer((_) async => mockTeamMatchupList);

      await tester.pumpWidget(buildSubject());

      expect(find.text('因縁一覧'), findsOneWidget);
    });

    testWidgets('個人因縁とチーム因縁のタブが表示される', (tester) async {
      when(() => mockMatchupRepo.getBatterPitcherMatchups())
          .thenAnswer((_) async => mockBatterPitcherList);
      when(() => mockMatchupRepo.getTeamMatchups())
          .thenAnswer((_) async => mockTeamMatchupList);

      await tester.pumpWidget(buildSubject());

      expect(find.text('個人因縁'), findsOneWidget);
      expect(find.text('チーム因縁'), findsOneWidget);
    });

    testWidgets('個人因縁タブにバッター名とピッチャー名が表示される', (tester) async {
      when(() => mockMatchupRepo.getBatterPitcherMatchups())
          .thenAnswer((_) async => mockBatterPitcherList);
      when(() => mockMatchupRepo.getTeamMatchups())
          .thenAnswer((_) async => mockTeamMatchupList);

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('テスト打者'), findsOneWidget);
      expect(find.text('テスト投手'), findsOneWidget);
    });

    testWidgets('データが空の場合はEmptyStateが表示される', (tester) async {
      when(() => mockMatchupRepo.getBatterPitcherMatchups())
          .thenAnswer((_) async => []);
      when(() => mockMatchupRepo.getTeamMatchups())
          .thenAnswer((_) async => []);

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(
        find.text('まだ宿敵はいない。試合を記録して因縁を刻もう。'),
        findsOneWidget,
      );
    });

    testWidgets('チーム因縁タブに切り替えるとチーム名が表示される', (tester) async {
      when(() => mockMatchupRepo.getBatterPitcherMatchups())
          .thenAnswer((_) async => mockBatterPitcherList);
      when(() => mockMatchupRepo.getTeamMatchups())
          .thenAnswer((_) async => mockTeamMatchupList);

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // チーム因縁タブをタップ
      await tester.tap(find.text('チーム因縁'));
      await tester.pumpAndSettle();

      expect(find.text('テストチームA'), findsOneWidget);
      expect(find.text('テストチームB'), findsOneWidget);
    });
  });
}
