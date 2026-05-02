import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_match/core/theme/app_theme.dart';
import 'package:base_match/features/games/presentation/pages/pitching_input_page.dart';
import 'package:base_match/features/games/presentation/pages/plate_appearance_input_page.dart';
import 'package:base_match/l10n/generated/app_localizations.dart';
import 'package:base_match/l10n/generated/app_localizations_ja.dart';

void main() {
  final l10n = AppLocalizationsJa();

  group('PlateAppearanceInputPage', () {
    testWidgets('操作すると打席結果、イニング、打点が更新される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const PlateAppearanceInputPage(gameId: 'game-1'),
          ),
        ),
      );

      expect(find.text(l10n.plateAppearanceInputTitle), findsOneWidget);
      expect(
        find.text(l10n.plateAppearanceSummary(1, l10n.notSelectedLabel, 0)),
        findsOneWidget,
      );
      expect(find.text(l10n.detailSingle), findsOneWidget);
      expect(find.text(l10n.detailStrikeout), findsOneWidget);

      await tester.tap(
        find.byTooltip(l10n.increaseLabelTooltip(l10n.inningLabel)),
      );
      await tester.tap(
        find.byTooltip(l10n.increaseLabelTooltip(l10n.rbiLabel)),
      );
      await tester.tap(find.widgetWithText(ChoiceChip, l10n.detailSingle));
      await tester.pumpAndSettle();

      expect(
        find.text(l10n.plateAppearanceSummary(2, l10n.detailSingle, 1)),
        findsOneWidget,
      );
    });
  });

  group('PitchingInputPage', () {
    testWidgets('操作すると投球回と各カウンターが更新される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const PitchingInputPage(gameId: 'game-1'),
          ),
        ),
      );

      expect(find.text(l10n.pitchingInputTitle), findsOneWidget);
      expect(
        find.text(l10n.pitchingInputSummary(l10n.inningsOnlyLabel(1), 0, 0)),
        findsOneWidget,
      );
      expect(find.text(l10n.outsLabel(3)), findsOneWidget);

      await tester.tap(find.byTooltip(l10n.increaseOneOutTooltip));
      await tester.tap(
        find.byTooltip(l10n.increaseLabelTooltip(l10n.runsLabel)),
      );
      await tester.tap(
        find.byTooltip(l10n.increaseLabelTooltip(l10n.earnedRunsLabel)),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          l10n.pitchingInputSummary(l10n.inningsWithRestLabel(1, 1), 1, 1),
        ),
        findsOneWidget,
      );
      expect(find.text(l10n.outsLabel(4)), findsOneWidget);
    });
  });
}
