import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:base_match/features/matchups/domain/entities/batter_pitcher_matchup.dart';
import 'package:base_match/features/matchups/domain/entities/team_matchup.dart';
import 'package:base_match/features/matchups/domain/repositories/matchup_repository.dart';
import 'package:base_match/features/matchups/presentation/pages/matchup_detail_page.dart';
import 'package:base_match/features/matchups/presentation/view_models/matchup_view_model.dart';

class MockMatchupRepository extends Mock implements MatchupRepository {}

void main() {
  late MockMatchupRepository mockMatchupRepo;

  const mockBatterPitcherMatchup = BatterPitcherMatchup(
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
  );

  const mockTeamMatchup = TeamMatchup(
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
  );

  setUp(() {
    mockMatchupRepo = MockMatchupRepository();
  });

  group('MatchupDetailPage - 個人因縁', () {
    Widget buildSubject() {
      when(() => mockMatchupRepo.getBatterPitcherDetail(
            batterPlayerId: 'batter-1',
            pitcherPlayerId: 'pitcher-1',
          )).thenAnswer((_) async => mockBatterPitcherMatchup);

      return ProviderScope(
        overrides: [
          matchupRepositoryProvider.overrideWithValue(mockMatchupRepo),
        ],
        child: const MaterialApp(
          home: MatchupDetailPage(
            matchupType: 'batter_pitcher',
            id1: 'batter-1',
            id2: 'pitcher-1',
          ),
        ),
      );
    }

    testWidgets('AppBarに「個人因縁」が表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('個人因縁'), findsOneWidget);
    });

    testWidgets('データ読み込み後にバッター名とピッチャー名が表示される', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('テスト打者'), findsOneWidget);
      expect(find.text('テスト投手'), findsOneWidget);
    });

    testWidgets('打率が表示される', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('0.400'), findsWidgets);
    });

    testWidgets('「因縁カードを生成」ボタンが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('因縁カードを生成'), findsOneWidget);
    });

    testWidgets('通算成績セクションが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('通算成績'), findsOneWidget);
      expect(find.text('打数'), findsOneWidget);
      expect(find.text('安打'), findsOneWidget);
      expect(find.text('本塁打'), findsOneWidget);
      expect(find.text('四死球'), findsOneWidget);
      expect(find.text('三振'), findsOneWidget);
    });
  });

  group('MatchupDetailPage - チーム因縁', () {
    Widget buildSubject() {
      when(() => mockMatchupRepo.getTeamMatchupDetail(
            teamAId: 'team-a',
            teamBId: 'team-b',
          )).thenAnswer((_) async => mockTeamMatchup);

      return ProviderScope(
        overrides: [
          matchupRepositoryProvider.overrideWithValue(mockMatchupRepo),
        ],
        child: const MaterialApp(
          home: MatchupDetailPage(
            matchupType: 'team',
            id1: 'team-a',
            id2: 'team-b',
          ),
        ),
      );
    }

    testWidgets('AppBarに「チーム因縁」が表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('チーム因縁'), findsOneWidget);
    });

    testWidgets('データ読み込み後にチーム名が表示される', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('テストチームA'), findsOneWidget);
      expect(find.text('テストチームB'), findsOneWidget);
    });

    testWidgets('勝率が表示される', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('0.600'), findsWidgets);
    });

    testWidgets('通算成績セクションが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('通算成績'), findsOneWidget);
      expect(find.text('対戦数'), findsOneWidget);
      expect(find.text('戦績'), findsOneWidget);
    });

    testWidgets('「因縁カードを生成」ボタンが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('因縁カードを生成'), findsOneWidget);
    });
  });
}
