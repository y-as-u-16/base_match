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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF1D1D1F),
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ),
        Icon(
          Icons.sports_baseball_outlined,
          size: 20,
          color: colorScheme.onSurfaceVariant,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.add_chart_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.homeEmptyGames,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6E6E73),
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
