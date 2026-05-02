import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/localization_helpers.dart';
import '../view_models/game_view_model.dart';

class GameDetailPage extends ConsumerWidget {
  const GameDetailPage({super.key, required this.gameId});

  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameDetailProvider(gameId));
    final plateAppearances = ref.watch(plateAppearancesProvider(gameId));
    final pitchingAppearances = ref.watch(pitchingAppearancesProvider(gameId));
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');
    final l10n = AppLocalizations.of(context);

    if (game == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.gameDetailTitle)),
        body: Center(child: Text(l10n.gameNotFound)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.gameDetailTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${game.homeTeamName} vs ${game.awayTeamName}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(dateFormat.format(game.date)),
                  if (game.location != null) Text(game.location!),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _ScoreBox(
                        label: game.homeTeamName,
                        score: game.homeScore ?? 0,
                      ),
                      const SizedBox(width: 12),
                      _ScoreBox(
                        label: game.awayTeamName,
                        score: game.awayScore ?? 0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () =>
                      context.go('/games/$gameId/plate-appearances/new'),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addPlateAppearanceButton),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/games/$gameId/pitching/new'),
                  icon: const Icon(Icons.add_chart),
                  label: Text(l10n.addPitchingButton),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            l10n.plateAppearanceRecordsTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          if (plateAppearances.isEmpty)
            _EmptyText(l10n.emptyPlateAppearances)
          else
            ...plateAppearances.map(
              (appearance) => Card(
                child: ListTile(
                  title: Text(
                    _resultLabel(
                      l10n,
                      appearance.resultType,
                      appearance.resultDetail,
                    ),
                  ),
                  subtitle: Text(
                    l10n.plateAppearanceListSubtitle(
                      appearance.inning?.toString() ?? '-',
                      appearance.rbi ?? 0,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 28),
          Text(
            l10n.pitchingRecordsTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          if (pitchingAppearances.isEmpty)
            _EmptyText(l10n.emptyPitchingAppearances)
          else
            ...pitchingAppearances.map(
              (appearance) => Card(
                child: ListTile(
                  title: Text(
                    l10n.pitchingOutsTitle(
                      l10n.inningsFromOuts(appearance.outsPitched),
                    ),
                  ),
                  subtitle: Text(
                    l10n.pitchingListSubtitle(
                      appearance.runs,
                      appearance.earnedRuns,
                      appearance.strikeouts,
                    ),
                  ),
                ),
              ),
            ),
        ],
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

class _ScoreBox extends StatelessWidget {
  const _ScoreBox({required this.label, required this.score});

  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(label, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(
              '$score',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  const _EmptyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16), child: Text(text)),
    );
  }
}
