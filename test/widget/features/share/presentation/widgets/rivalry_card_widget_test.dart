import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/features/share/presentation/widgets/rivalry_card_widget.dart';
import 'package:base_match/features/matchups/domain/entities/batter_pitcher_matchup.dart';
import 'package:base_match/features/matchups/domain/entities/team_matchup.dart';

void main() {
  final mockBatterPitcherMatchup = BatterPitcherMatchup(
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

  final mockTeamMatchup = TeamMatchup(
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

  group('RivalryCardWidget', () {
    group('BatterPitcherMatchup', () {
      testWidgets('正常にレンダリングされる', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: RivalryCardWidget(
                  batterPitcherMatchup: mockBatterPitcherMatchup,
                ),
              ),
            ),
          ),
        );

        expect(find.byType(RivalryCardWidget), findsOneWidget);
        // RivalryCardWidget 内に CustomPaint が存在する
        expect(
          find.descendant(
            of: find.byType(RivalryCardWidget),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );
      });

      testWidgets('サイズが 600x400 である', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: RivalryCardWidget(
                  batterPitcherMatchup: mockBatterPitcherMatchup,
                ),
              ),
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(
          find.descendant(
            of: find.byType(RivalryCardWidget),
            matching: find.byType(SizedBox),
          ),
        );
        expect(sizedBox.width, 600);
        expect(sizedBox.height, 400);
      });
    });

    group('TeamMatchup', () {
      testWidgets('正常にレンダリングされる', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: RivalryCardWidget(
                  teamMatchup: mockTeamMatchup,
                ),
              ),
            ),
          ),
        );

        expect(find.byType(RivalryCardWidget), findsOneWidget);
        // RivalryCardWidget 内に CustomPaint が存在する
        expect(
          find.descendant(
            of: find.byType(RivalryCardWidget),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );
      });

      testWidgets('サイズが 600x400 である', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: RivalryCardWidget(
                  teamMatchup: mockTeamMatchup,
                ),
              ),
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(
          find.descendant(
            of: find.byType(RivalryCardWidget),
            matching: find.byType(SizedBox),
          ),
        );
        expect(sizedBox.width, 600);
        expect(sizedBox.height, 400);
      });
    });
  });
}
