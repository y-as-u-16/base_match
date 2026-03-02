class TeamMatchup {
  const TeamMatchup({
    required this.teamAId,
    required this.teamBId,
    required this.teamAName,
    required this.teamBName,
    required this.games,
    required this.winsA,
    required this.winsB,
    required this.draws,
    required this.runsA,
    required this.runsB,
  });

  final String teamAId;
  final String teamBId;
  final String teamAName;
  final String teamBName;
  final int games;
  final int winsA;
  final int winsB;
  final int draws;
  final int runsA;
  final int runsB;

  double get winRateA => games > 0 ? winsA / games : 0.0;

  factory TeamMatchup.fromJson(Map<String, dynamic> json) {
    return TeamMatchup(
      teamAId: json['team_a_id'] as String,
      teamBId: json['team_b_id'] as String,
      teamAName: json['team_a_name'] as String? ?? '',
      teamBName: json['team_b_name'] as String? ?? '',
      games: (json['games'] as num?)?.toInt() ?? 0,
      winsA: (json['wins_a'] as num?)?.toInt() ?? 0,
      winsB: (json['wins_b'] as num?)?.toInt() ?? 0,
      draws: (json['draws'] as num?)?.toInt() ?? 0,
      runsA: (json['runs_a'] as num?)?.toInt() ?? 0,
      runsB: (json['runs_b'] as num?)?.toInt() ?? 0,
    );
  }
}
