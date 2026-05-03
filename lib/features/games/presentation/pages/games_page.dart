import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/my_team.dart';
import '../view_models/game_view_model.dart';
import '../view_models/my_team_view_model.dart';

enum _GamesViewMode { list, calendar }

class GamesPage extends ConsumerStatefulWidget {
  const GamesPage({super.key});

  @override
  ConsumerState<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends ConsumerState<GamesPage> {
  _GamesViewMode _viewMode = _GamesViewMode.list;

  @override
  Widget build(BuildContext context) {
    final games = ref.watch(gamesProvider);
    final myTeamById = ref.watch(myTeamByIdProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recordTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/games/create'),
        icon: const Icon(Icons.add),
        label: Text(l10n.addGameButton),
      ),
      body: games.isEmpty
          ? _RecordEmptyState(onCreate: () => context.go('/games/create'))
          : Column(
              children: [
                _GamesViewModeSelector(
                  viewMode: _viewMode,
                  onChanged: (viewMode) {
                    setState(() {
                      _viewMode = viewMode;
                    });
                  },
                ),
                Expanded(
                  child: switch (_viewMode) {
                    _GamesViewMode.list => _GameListView(
                      games: games,
                      myTeamById: myTeamById,
                    ),
                    _GamesViewMode.calendar => const _GameCalendarPlaceholder(),
                  },
                ),
              ],
            ),
    );
  }
}

class _GamesViewModeSelector extends StatelessWidget {
  const _GamesViewModeSelector({
    required this.viewMode,
    required this.onChanged,
  });

  final _GamesViewMode viewMode;
  final ValueChanged<_GamesViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<_GamesViewMode>(
          segments: [
            ButtonSegment(
              value: _GamesViewMode.list,
              icon: Icon(Icons.view_list_outlined),
              label: Text(l10n.gamesListViewLabel),
            ),
            ButtonSegment(
              value: _GamesViewMode.calendar,
              icon: Icon(Icons.calendar_month_outlined),
              label: Text(l10n.gamesCalendarViewLabel),
            ),
          ],
          selected: {viewMode},
          onSelectionChanged: (selected) => onChanged(selected.single),
        ),
      ),
    );
  }
}

class _GameListView extends StatelessWidget {
  const _GameListView({required this.games, required this.myTeamById});

  final List<Game> games;
  final Map<String, MyTeam> myTeamById;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd');
    final l10n = AppLocalizations.of(context);

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      itemCount: games.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final game = games[index];
        return _GameRecordCard(
          title:
              '${myTeamById[game.myTeamId]?.name ?? l10n.unknownMyTeamLabel} vs ${game.awayTeamName}',
          date: dateFormat.format(game.date),
          location: game.location,
          homeScore: game.homeScore ?? 0,
          awayScore: game.awayScore ?? 0,
          onTap: () => context.go('/games/${game.id}'),
        );
      },
    );
  }
}

class _GameCalendarPlaceholder extends StatelessWidget {
  const _GameCalendarPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          l10n.gamesCalendarPlaceholder,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _RecordEmptyState extends StatelessWidget {
  const _RecordEmptyState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Icon(
                      Icons.sports_baseball_outlined,
                      color: colorScheme.onPrimaryContainer,
                      size: 34,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.emptyGamesTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.emptyGamesSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onCreate,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.createGameButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GameRecordCard extends StatelessWidget {
  const _GameRecordCard({
    required this.title,
    required this.date,
    required this.homeScore,
    required this.awayScore,
    required this.onTap,
    this.location,
  });

  final String title;
  final String date;
  final String? location;
  final int homeScore;
  final int awayScore;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locationLabel = location?.trim();

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  width: 66,
                  height: 62,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$homeScore-$awayScore',
                        maxLines: 1,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _GameMetaChip(
                          icon: Icons.calendar_today_outlined,
                          label: date,
                        ),
                        if (locationLabel != null && locationLabel.isNotEmpty)
                          _GameMetaChip(
                            icon: Icons.location_on_outlined,
                            label: locationLabel,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameMetaChip extends StatelessWidget {
  const _GameMetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
