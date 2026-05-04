import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/localization_helpers.dart';
import '../view_models/game_view_model.dart';
import '../view_models/my_team_view_model.dart';
import '../widgets/game_detail_page_widgets.dart';

class GameDetailPage extends ConsumerWidget {
  const GameDetailPage({super.key, required this.gameId});

  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameDetailProvider(gameId));
    final plateAppearances = ref.watch(plateAppearancesProvider(gameId));
    final pitchingAppearances = ref.watch(pitchingAppearancesProvider(gameId));
    final myTeamById = ref.watch(myTeamByIdProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('yyyy/MM/dd');
    final l10n = AppLocalizations.of(context);

    if (game == null) {
      return Scaffold(
        backgroundColor: colorScheme.surfaceContainerLowest,
        appBar: GameDetailAppBar(title: l10n.gameDetailTitle),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: EmptyText(l10n.gameNotFound),
          ),
        ),
      );
    }

    final myTeamName =
        myTeamById[game.myTeamId]?.name ?? l10n.unknownMyTeamLabel;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: GameDetailAppBar(title: l10n.gameDetailTitle),
      body: ColoredBox(
        color: colorScheme.surfaceContainerLowest,
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              GameSummaryPanel(
                game: game,
                myTeamName: myTeamName,
                dateLabel: dateFormat.format(game.date),
              ),
              const SizedBox(height: 14),
              DetailActions(
                onAddPlateAppearance: () =>
                    context.go('/games/$gameId/plate-appearances/new'),
                onAddPitching: () => context.go('/games/$gameId/pitching/new'),
              ),
              const SizedBox(height: 26),
              RecordSection(
                title: l10n.plateAppearanceRecordsTitle,
                count: plateAppearances.length,
                icon: Icons.sports_baseball_outlined,
                emptyText: l10n.emptyPlateAppearances,
                children: plateAppearances
                    .map(
                      (appearance) => PlateAppearanceTile(
                        appearance: appearance,
                        resultLabel: _resultLabel(
                          l10n,
                          appearance.resultType,
                          appearance.resultDetail,
                        ),
                        subtitle: l10n.plateAppearanceListSubtitle(
                          appearance.inning?.toString() ?? '-',
                          appearance.rbi ?? 0,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              RecordSection(
                title: l10n.pitchingRecordsTitle,
                count: pitchingAppearances.length,
                icon: Icons.analytics_outlined,
                emptyText: l10n.emptyPitchingAppearances,
                children: pitchingAppearances
                    .map(
                      (appearance) => PitchingAppearanceTile(
                        appearance: appearance,
                        inningsLabel: l10n.pitchingOutsTitle(
                          l10n.inningsFromOuts(appearance.outsPitched),
                        ),
                        subtitle: l10n.pitchingListSubtitle(
                          appearance.runs,
                          appearance.earnedRuns,
                          appearance.strikeouts,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _resultLabel(
    AppLocalizations l10n,
    String type,
    String detail,
  ) {
    return '${l10n.resultTypeLabel(type)} - ${l10n.resultDetailLabel(detail)}';
  }
}
