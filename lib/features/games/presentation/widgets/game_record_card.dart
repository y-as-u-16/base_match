import 'package:flutter/material.dart';

class GameRecordCard extends StatelessWidget {
  const GameRecordCard({
    super.key,
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
    final result = _GameResult.fromScores(homeScore, awayScore);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.62),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(color: colorScheme.surfaceContainerLow),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 5,
                child: SizedBox(
                  width: 5,
                  child: ColoredBox(color: result.color(colorScheme)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 12, 14, 12),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 340;
                    final scoreBoard = _ScoreBoard(
                      homeScore: homeScore,
                      awayScore: awayScore,
                      result: result,
                      fillWidth: compact,
                    );
                    final details = _GameRecordDetails(
                      title: title,
                      date: date,
                      locationLabel: locationLabel,
                    );

                    if (compact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          scoreBoard,
                          const SizedBox(height: 12),
                          details,
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.chevron_right,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        scoreBoard,
                        const SizedBox(width: 14),
                        Expanded(child: details),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _GameResult {
  win('W'),
  draw('D'),
  loss('L');

  const _GameResult(this.label);

  final String label;

  static _GameResult fromScores(int homeScore, int awayScore) {
    if (homeScore == awayScore) {
      return _GameResult.draw;
    }
    return homeScore > awayScore ? _GameResult.win : _GameResult.loss;
  }

  Color color(ColorScheme colorScheme) {
    return switch (this) {
      _GameResult.win => colorScheme.primary,
      _GameResult.draw => colorScheme.tertiary,
      _GameResult.loss => colorScheme.outline,
    };
  }

  Color containerColor(ColorScheme colorScheme) {
    return switch (this) {
      _GameResult.win => colorScheme.primaryContainer,
      _GameResult.draw => colorScheme.tertiaryContainer,
      _GameResult.loss => colorScheme.surfaceContainerHighest,
    };
  }

  Color onContainerColor(ColorScheme colorScheme) {
    return switch (this) {
      _GameResult.win => colorScheme.onPrimaryContainer,
      _GameResult.draw => colorScheme.onTertiaryContainer,
      _GameResult.loss => colorScheme.onSurfaceVariant,
    };
  }
}

class _ScoreBoard extends StatelessWidget {
  const _ScoreBoard({
    required this.homeScore,
    required this.awayScore,
    required this.result,
    required this.fillWidth,
  });

  final int homeScore;
  final int awayScore;
  final _GameResult result;
  final bool fillWidth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: fillWidth ? double.infinity : 132,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.76),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.72),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
          child: SizedBox(
            height: 82,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _TeamScore(label: 'HOME', score: homeScore),
                    SizedBox(
                      height: 44,
                      child: VerticalDivider(
                        width: 16,
                        thickness: 1,
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.88,
                        ),
                      ),
                    ),
                    _TeamScore(label: 'AWAY', score: awayScore),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: result
                              .color(colorScheme)
                              .withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const SizedBox(height: 5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ResultBadge(result: result),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.result});

  final _GameResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: result.containerColor(colorScheme),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          result.label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: result.onContainerColor(colorScheme),
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _TeamScore extends StatelessWidget {
  const _TeamScore({required this.label, required this.score});

  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$score',
              maxLines: 1,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameRecordDetails extends StatelessWidget {
  const _GameRecordDetails({
    required this.title,
    required this.date,
    required this.locationLabel,
  });

  final String title;
  final String date;
  final String? locationLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w900,
            height: 1.18,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 7,
          children: [
            _GameMetaChip(icon: Icons.calendar_today_outlined, label: date),
            if (locationLabel != null && locationLabel!.isNotEmpty)
              _GameMetaChip(
                icon: Icons.location_on_outlined,
                label: locationLabel!,
              ),
          ],
        ),
      ],
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
