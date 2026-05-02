import '../../../games/domain/entities/game.dart';
import '../../../games/domain/entities/pitching_appearance.dart';
import '../../../games/domain/entities/plate_appearance.dart';
import '../../../stats/domain/services/stats_calculator.dart';

class SeasonSummary {
  const SeasonSummary({
    required this.year,
    required this.games,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.totalRuns,
    required this.battingAverage,
    required this.era,
  });

  factory SeasonSummary.fromRecords({
    required List<Game> games,
    required List<PlateAppearance> plateAppearances,
    required List<PitchingAppearance> pitchingAppearances,
    DateTime? now,
  }) {
    final year = (now ?? DateTime.now()).year;
    final seasonGames = games.where((game) => game.date.year == year).toList();
    final seasonGameIds = seasonGames.map((game) => game.id).toSet();
    final battingStats = BattingStats.fromAppearances(
      plateAppearances.where(
        (appearance) => seasonGameIds.contains(appearance.gameId),
      ),
    );
    final pitchingStats = PitchingStats.fromAppearances(
      pitchingAppearances.where(
        (appearance) => seasonGameIds.contains(appearance.gameId),
      ),
    );

    var wins = 0;
    var losses = 0;
    var draws = 0;
    var totalRuns = 0;
    for (final game in seasonGames) {
      final homeScore = game.homeScore ?? 0;
      final awayScore = game.awayScore ?? 0;
      totalRuns += homeScore;
      if (homeScore > awayScore) {
        wins += 1;
      } else if (homeScore < awayScore) {
        losses += 1;
      } else {
        draws += 1;
      }
    }

    return SeasonSummary(
      year: year,
      games: seasonGames.length,
      wins: wins,
      losses: losses,
      draws: draws,
      totalRuns: totalRuns,
      battingAverage: battingStats.averageLabel,
      era: pitchingStats.eraLabel,
    );
  }

  final int year;
  final int games;
  final int wins;
  final int losses;
  final int draws;
  final int totalRuns;
  final String battingAverage;
  final String era;
}
