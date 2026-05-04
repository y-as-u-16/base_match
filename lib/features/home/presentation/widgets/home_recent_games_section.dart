import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../games/domain/entities/game.dart';
import '../../../games/domain/entities/my_team.dart';
import '../../../games/presentation/widgets/game_record_card.dart';

class HomeRecentGamesSection extends StatelessWidget {
  const HomeRecentGamesSection({
    super.key,
    required this.games,
    required this.myTeamById,
    required this.onGameTap,
  });

  final List<Game> games;
  final Map<String, MyTeam> myTeamById;
  final ValueChanged<String> onGameTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(title: l10n.recentGamesTitle),
        const SizedBox(height: 10),
        if (games.isEmpty)
          const _EmptyRecentGames()
        else
          ...games
              .take(3)
              .map(
                (game) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GameRecordCard(
                    title:
                        '${myTeamById[game.myTeamId]?.name ?? l10n.unknownMyTeamLabel} vs ${game.awayTeamName}',
                    date: DateFormat('yyyy/MM/dd').format(game.date),
                    location: game.location,
                    homeScore: game.homeScore ?? 0,
                    awayScore: game.awayScore ?? 0,
                    onTap: () => onGameTap(game.id),
                  ),
                ),
              ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.tertiary.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Icon(
              Icons.sports_baseball_outlined,
              size: 17,
              color: colorScheme.tertiary,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyRecentGames extends StatelessWidget {
  const _EmptyRecentGames();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.72),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.add_chart_outlined,
                  color: colorScheme.onTertiaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.homeEmptyGames,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
