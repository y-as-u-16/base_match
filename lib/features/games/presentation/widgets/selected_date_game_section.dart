import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/my_team.dart';
import 'game_record_card.dart';

class SelectedDateGameSection extends StatelessWidget {
  const SelectedDateGameSection({
    super.key,
    required this.selectedDate,
    required this.games,
    required this.myTeamById,
  });

  final DateTime selectedDate;
  final List<Game> games;
  final Map<String, MyTeam> myTeamById;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat('yyyy/MM/dd');

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.46),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.tertiary.withValues(alpha: 0.16),
                    ),
                  ),
                  child: Icon(
                    Icons.sports_baseball_outlined,
                    size: 19,
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.selectedDateGamesTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat.yMMMd(localeName).format(selectedDate),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                _GameCountBadge(count: games.length),
              ],
            ),
            const SizedBox(height: 12),
            if (games.isEmpty)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.48,
                  ),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.50),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  child: Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLowest.withValues(
                            alpha: 0.82,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.event_busy_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.noGamesOnSelectedDate,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...games.map(
                (game) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GameRecordCard(
                    title:
                        '${myTeamById[game.myTeamId]?.name ?? l10n.unknownMyTeamLabel} vs ${game.awayTeamName}',
                    date: dateFormat.format(game.date),
                    location: game.location,
                    homeScore: game.homeScore ?? 0,
                    awayScore: game.awayScore ?? 0,
                    onTap: () => context.go('/games/${game.id}'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GameCountBadge extends StatelessWidget {
  const _GameCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          '$count',
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
