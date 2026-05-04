import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/pitching_appearance.dart';
import '../../domain/entities/plate_appearance.dart';

class GameDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GameDetailAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(title),
      centerTitle: false,
      backgroundColor: colorScheme.surfaceContainerLowest,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: theme.textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
    );
  }
}

class GameSummaryPanel extends StatelessWidget {
  const GameSummaryPanel({
    super.key,
    required this.game,
    required this.myTeamName,
    required this.dateLabel,
  });

  final Game game;
  final String myTeamName;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locationLabel = game.location?.trim();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.12),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$myTeamName vs ${game.awayTeamName}',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w900,
                height: 1.04,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SummaryChip(
                  icon: Icons.calendar_today_outlined,
                  label: dateLabel,
                ),
                if (locationLabel != null && locationLabel.isNotEmpty)
                  SummaryChip(
                    icon: Icons.stadium_outlined,
                    label: locationLabel,
                  ),
              ],
            ),
            const SizedBox(height: 18),
            ScoreBoard(
              myTeamName: myTeamName,
              awayTeamName: game.awayTeamName,
              homeScore: game.homeScore ?? 0,
              awayScore: game.awayScore ?? 0,
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryChip extends StatelessWidget {
  const SummaryChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width - 64,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.onPrimary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.onPrimary.withValues(alpha: 0.16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: colorScheme.onPrimary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({
    super.key,
    required this.myTeamName,
    required this.awayTeamName,
    required this.homeScore,
    required this.awayScore,
  });

  final String myTeamName;
  final String awayTeamName;
  final int homeScore;
  final int awayScore;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.onPrimary.withValues(alpha: 0.16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: ScoreBox(
                label: myTeamName,
                score: homeScore,
                alignment: CrossAxisAlignment.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '-',
                style: TextStyle(
                  color: colorScheme.onPrimary.withValues(alpha: 0.72),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: ScoreBox(
                label: awayTeamName,
                score: awayScore,
                alignment: CrossAxisAlignment.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreBox extends StatelessWidget {
  const ScoreBox({
    super.key,
    required this.label,
    required this.score,
    required this.alignment,
  });

  final String label;
  final int score;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textAlign = alignment == CrossAxisAlignment.end
        ? TextAlign.end
        : TextAlign.start;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onPrimary.withValues(alpha: 0.82),
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 3),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignment == CrossAxisAlignment.end
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Text(
            '$score',
            maxLines: 1,
            style: theme.textTheme.displaySmall?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w900,
              height: 1,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }
}

class DetailActions extends StatelessWidget {
  const DetailActions({
    super.key,
    required this.onAddPlateAppearance,
    required this.onAddPitching,
  });

  final VoidCallback onAddPlateAppearance;
  final VoidCallback onAddPitching;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final primaryButton = FilledButton.icon(
      onPressed: onAddPlateAppearance,
      icon: const Icon(Icons.add),
      label: Text(l10n.addPlateAppearanceButton),
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
    final secondaryButton = OutlinedButton.icon(
      onPressed: onAddPitching,
      icon: const Icon(Icons.add_chart),
      label: Text(l10n.addPitchingButton),
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.onSurface,
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 390) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              primaryButton,
              const SizedBox(height: 10),
              secondaryButton,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: primaryButton),
            const SizedBox(width: 12),
            Expanded(child: secondaryButton),
          ],
        );
      },
    );
  }
}

class RecordSection extends StatelessWidget {
  const RecordSection({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.emptyText,
    required this.children,
  });

  final String title;
  final int count;
  final IconData icon;
  final String emptyText;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(icon, size: 18, color: colorScheme.primary),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
            CountBadge(count: count),
          ],
        ),
        const SizedBox(height: 10),
        if (children.isEmpty)
          EmptyText(emptyText)
        else
          ...children.expand((child) => [child, const SizedBox(height: 10)]),
      ],
    );
  }
}

class CountBadge extends StatelessWidget {
  const CountBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.54),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          '$count',
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class PlateAppearanceTile extends StatelessWidget {
  const PlateAppearanceTile({
    super.key,
    required this.appearance,
    required this.resultLabel,
    required this.subtitle,
  });

  final PlateAppearance appearance;
  final String resultLabel;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return RecordTile(
      icon: Icons.sports_baseball_outlined,
      title: appearance.batterName,
      emphasizedValue: resultLabel,
      subtitle: subtitle,
    );
  }
}

class PitchingAppearanceTile extends StatelessWidget {
  const PitchingAppearanceTile({
    super.key,
    required this.appearance,
    required this.inningsLabel,
    required this.subtitle,
  });

  final PitchingAppearance appearance;
  final String inningsLabel;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return RecordTile(
      icon: Icons.analytics_outlined,
      title: appearance.pitcherName,
      emphasizedValue: inningsLabel,
      subtitle: subtitle,
    );
  }
}

class RecordTile extends StatelessWidget {
  const RecordTile({
    super.key,
    required this.icon,
    required this.title,
    required this.emphasizedValue,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String emphasizedValue;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.52),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.72,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: colorScheme.primary, size: 20),
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
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.14),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  child: Text(
                    emphasizedValue,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyText extends StatelessWidget {
  const EmptyText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.52),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
