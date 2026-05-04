import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import 'game_record_card_parts.dart';

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
    final l10n = AppLocalizations.of(context);
    final locationLabel = location?.trim();
    final result = GameRecordResult.fromScores(homeScore, awayScore);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.46),
        ),
      ),
      shadowColor: colorScheme.shadow.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surfaceContainerLowest,
                colorScheme.surfaceContainerLow.withValues(alpha: 0.72),
              ],
            ),
          ),
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
                padding: const EdgeInsets.fromLTRB(15, 14, 14, 14),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 380;
                    final scoreBoard = GameRecordScoreBoard(
                      homeScore: homeScore,
                      awayScore: awayScore,
                      result: result,
                      fillWidth: compact,
                    );
                    final details = GameRecordDetails(
                      title: title,
                      date: date,
                      locationLabel: locationLabel,
                    );
                    final action = GameRecordCardAction(
                      label: l10n.gameDetailTitle,
                    );

                    if (compact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          scoreBoard,
                          const SizedBox(height: 12),
                          details,
                          const SizedBox(height: 12),
                          action,
                        ],
                      );
                    }

                    return Row(
                      children: [
                        scoreBoard,
                        const SizedBox(width: 16),
                        Expanded(child: details),
                        const SizedBox(width: 8),
                        action,
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
