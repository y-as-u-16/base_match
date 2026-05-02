import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/constants/app_constants.dart';
import 'package:base_match/core/local_db/local_database.dart';
import 'package:base_match/core/local_db/local_database_provider.dart';
import 'package:base_match/core/theme/app_theme.dart';
import 'package:base_match/features/games/data/repositories/local_game_repository.dart';
import 'package:base_match/features/stats/presentation/pages/stats_page.dart';
import 'package:base_match/l10n/generated/app_localizations.dart';
import 'package:base_match/l10n/generated/app_localizations_ja.dart';

void main() {
  final l10n = AppLocalizationsJa();

  Widget buildSubjectWithDatabase(LocalDatabase database) {
    return ProviderScope(
      overrides: [localDatabaseProvider.overrideWithValue(database)],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const StatsPage(),
      ),
    );
  }

  Widget buildSubject() {
    final database = LocalDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    return buildSubjectWithDatabase(database);
  }

  group('StatsPage', () {
    testWidgets('打撃と投球の主要成績を表示する', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text(l10n.statsTitle), findsOneWidget);
      expect(find.text(l10n.battingStatsTitle), findsOneWidget);
      expect(find.text(l10n.teamBattingTitle), findsOneWidget);
      expect(find.text(l10n.pitchingStatsTitle), findsOneWidget);
      expect(find.text(l10n.teamPitchingTitle), findsOneWidget);
      expect(find.text('.000'), findsOneWidget);
      expect(find.text('-.--'), findsOneWidget);
    });

    testWidgets('打撃グラフの棒が伸びても overflow しない', (tester) async {
      final database = LocalDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = LocalGameRepository(database);
      final game = await repository.createGame(
        date: DateTime.utc(2026, 5, 3),
        homeTeamName: 'Home',
        awayTeamName: 'Away',
      );
      await repository.addPlateAppearance(
        gameId: game.id,
        resultType: AppConstants.resultHit,
        resultDetail: AppConstants.detailSingle,
      );
      await repository.addPlateAppearance(
        gameId: game.id,
        resultType: AppConstants.resultHit,
        resultDetail: AppConstants.detailDouble,
      );
      await repository.addPlateAppearance(
        gameId: game.id,
        resultType: AppConstants.resultOut,
        resultDetail: AppConstants.detailK,
      );

      await tester.pumpWidget(buildSubjectWithDatabase(database));
      await tester.pumpAndSettle();

      expect(find.text('.667'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
