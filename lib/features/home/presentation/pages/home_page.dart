import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../games/presentation/view_models/game_view_model.dart';
import '../models/season_summary.dart';
import '../widgets/season_summary_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesProvider);
    final localGameState = ref.watch(localGameStoreProvider);
    final l10n = AppLocalizations.of(context);
    final summary = SeasonSummary.fromRecords(
      games: games,
      plateAppearances: localGameState.plateAppearances,
      pitchingAppearances: localGameState.pitchingAppearances,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navHome)),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _HomeHero(summary: summary),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PrimaryActions(
                  onRecord: () => context.go('/games/create'),
                  onStats: () => context.go('/stats'),
                ),
                const SizedBox(height: 16),
                SeasonSummaryCard(summary: summary),
                const SizedBox(height: 24),
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
                          child: _RecentGameCard(
                            title:
                                '${game.homeTeamName} vs ${game.awayTeamName}',
                            date: game.date,
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
        ],
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({required this.summary});

  final SeasonSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _BallparkLinePainter(
                lineColor: colorScheme.onPrimary.withValues(alpha: 0.12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.onPrimary.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Text(
                      l10n.seasonSummarySubtitle(summary.year),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.homeHeadline,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Text(
                    l10n.homeDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.82),
                      height: 1.55,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _HeroStatChip(
                      label: l10n.seasonGamesMetricLabel,
                      value: '${summary.games}',
                    ),
                    _HeroStatChip(
                      label: l10n.seasonRecordMetricLabel,
                      value:
                          '${summary.wins}-${summary.losses}-${summary.draws}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStatChip extends StatelessWidget {
  const _HeroStatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryActions extends StatelessWidget {
  const _PrimaryActions({required this.onRecord, required this.onStats});

  final VoidCallback onRecord;
  final VoidCallback onStats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: onRecord,
            icon: const Icon(Icons.add),
            label: Text(l10n.recordGameButton),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onStats,
            icon: const Icon(Icons.bar_chart),
            label: Text(l10n.viewStatsButton),
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

    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
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
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
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
                  Icons.sports_baseball_outlined,
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

class _RecentGameCard extends StatelessWidget {
  const _RecentGameCard({
    required this.title,
    required this.date,
    required this.homeScore,
    required this.awayScore,
    required this.onTap,
    this.location,
  });

  final String title;
  final DateTime date;
  final String? location;
  final int homeScore;
  final int awayScore;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateLabel = DateFormat('yyyy/MM/dd').format(date);
    final metaLabel = [
      dateLabel,
      if (location != null && location!.trim().isNotEmpty) location!.trim(),
    ].join(' / ');

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
                  width: 62,
                  height: 58,
                  child: Center(
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      metaLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _BallparkLinePainter extends CustomPainter {
  const _BallparkLinePainter({required this.lineColor});

  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final basePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final center = Offset(size.width * 0.72, size.height * 0.72);
    final base = size.shortestSide * 0.18;
    final diamond = Path()
      ..moveTo(center.dx, center.dy - base)
      ..lineTo(center.dx + base, center.dy)
      ..lineTo(center.dx, center.dy + base)
      ..lineTo(center.dx - base, center.dy)
      ..close();

    canvas.drawPath(diamond, paint);
    canvas.drawCircle(center, base * 0.1, basePaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: base * 2.4),
      3.45,
      2.25,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BallparkLinePainter oldDelegate) {
    return oldDelegate.lineColor != lineColor;
  }
}
