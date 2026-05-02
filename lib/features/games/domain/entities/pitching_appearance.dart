class PitchingAppearance {
  const PitchingAppearance({
    required this.id,
    required this.gameId,
    required this.outsPitched,
    required this.runs,
    required this.earnedRuns,
    required this.hitsAllowed,
    required this.walks,
    required this.strikeouts,
    required this.homeRunsAllowed,
    required this.createdAt,
  });

  final String id;
  final String gameId;
  final int outsPitched;
  final int runs;
  final int earnedRuns;
  final int hitsAllowed;
  final int walks;
  final int strikeouts;
  final int homeRunsAllowed;
  final DateTime createdAt;
}
