import '../../../../core/constants/app_constants.dart';
import '../../../games/domain/entities/pitching_appearance.dart';
import '../../../games/domain/entities/plate_appearance.dart';

class BattingStats {
  const BattingStats({
    required this.pa,
    required this.ab,
    required this.hits,
    required this.hr,
    required this.walks,
    required this.so,
  });

  factory BattingStats.empty() {
    return const BattingStats(pa: 0, ab: 0, hits: 0, hr: 0, walks: 0, so: 0);
  }

  factory BattingStats.fromAppearances(Iterable<PlateAppearance> appearances) {
    var stats = BattingStats.empty();
    for (final appearance in appearances) {
      stats = stats.add(appearance);
    }
    return stats;
  }

  final int pa;
  final int ab;
  final int hits;
  final int hr;
  final int walks;
  final int so;

  String get averageLabel {
    if (ab == 0) return '.000';
    final fixed = (hits / ab).toStringAsFixed(3);
    return fixed.startsWith('0') ? fixed.substring(1) : fixed;
  }

  BattingStats add(PlateAppearance appearance) {
    final isAtBat = {
      AppConstants.resultHit,
      AppConstants.resultOut,
      AppConstants.resultError,
    }.contains(appearance.resultType);
    return BattingStats(
      pa: pa + 1,
      ab: ab + (isAtBat ? 1 : 0),
      hits: hits + (appearance.resultType == AppConstants.resultHit ? 1 : 0),
      hr: hr + (appearance.resultDetail == AppConstants.detailHr ? 1 : 0),
      walks: walks + (appearance.resultType == AppConstants.resultWalk ? 1 : 0),
      so: so + (appearance.resultDetail == AppConstants.detailK ? 1 : 0),
    );
  }
}

class NamedBattingStats {
  const NamedBattingStats({required this.playerName, required this.stats});

  final String playerName;
  final BattingStats stats;

  static List<NamedBattingStats> fromAppearances(
    Iterable<PlateAppearance> appearances,
  ) {
    final grouped = <String, List<PlateAppearance>>{};
    for (final appearance in appearances) {
      grouped.putIfAbsent(appearance.batterName, () => []).add(appearance);
    }

    final rows = grouped.entries
        .map(
          (entry) => NamedBattingStats(
            playerName: entry.key,
            stats: BattingStats.fromAppearances(entry.value),
          ),
        )
        .toList();
    rows.sort((a, b) {
      final paCompare = b.stats.pa.compareTo(a.stats.pa);
      if (paCompare != 0) return paCompare;
      return a.playerName.compareTo(b.playerName);
    });
    return rows;
  }
}

class PitchingStats {
  const PitchingStats({
    required this.games,
    required this.outsPitched,
    required this.earnedRuns,
    required this.strikeouts,
  });

  factory PitchingStats.empty() {
    return const PitchingStats(
      games: 0,
      outsPitched: 0,
      earnedRuns: 0,
      strikeouts: 0,
    );
  }

  factory PitchingStats.fromAppearances(
    Iterable<PitchingAppearance> appearances,
  ) {
    var stats = PitchingStats.empty();
    for (final appearance in appearances) {
      stats = stats.add(appearance);
    }
    return stats;
  }

  final int games;
  final int outsPitched;
  final int earnedRuns;
  final int strikeouts;

  String get inningsLabel {
    final innings = outsPitched ~/ 3;
    final rest = outsPitched % 3;
    return rest == 0 ? '$innings' : '$innings.$rest';
  }

  String get eraLabel {
    if (outsPitched == 0) return '-.--';
    return (earnedRuns * 27 / outsPitched).toStringAsFixed(2);
  }

  PitchingStats add(PitchingAppearance appearance) {
    return PitchingStats(
      games: games + 1,
      outsPitched: outsPitched + appearance.outsPitched,
      earnedRuns: earnedRuns + appearance.earnedRuns,
      strikeouts: strikeouts + appearance.strikeouts,
    );
  }
}

class NamedPitchingStats {
  const NamedPitchingStats({required this.playerName, required this.stats});

  final String playerName;
  final PitchingStats stats;

  static List<NamedPitchingStats> fromAppearances(
    Iterable<PitchingAppearance> appearances,
  ) {
    final grouped = <String, List<PitchingAppearance>>{};
    for (final appearance in appearances) {
      grouped.putIfAbsent(appearance.pitcherName, () => []).add(appearance);
    }

    final rows = grouped.entries
        .map(
          (entry) => NamedPitchingStats(
            playerName: entry.key,
            stats: PitchingStats.fromAppearances(entry.value),
          ),
        )
        .toList();
    rows.sort((a, b) {
      final gamesCompare = b.stats.games.compareTo(a.stats.games);
      if (gamesCompare != 0) return gamesCompare;
      return a.playerName.compareTo(b.playerName);
    });
    return rows;
  }
}
