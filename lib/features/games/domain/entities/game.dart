class Game {
  const Game({
    required this.id,
    required this.date,
    this.location,
    required this.homeTeamId,
    required this.awayTeamId,
    this.homeScore,
    this.awayScore,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    this.innings,
    this.gameNumber,
  });

  final String id;
  final DateTime date;
  final String? location;
  final String homeTeamId;
  final String awayTeamId;
  final int? homeScore;
  final int? awayScore;
  final String status;
  final String createdBy;
  final DateTime createdAt;
  final int? innings;
  final int? gameNumber;

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String?,
      homeTeamId: json['home_team_id'] as String,
      awayTeamId: json['away_team_id'] as String,
      homeScore: json['home_score'] as int?,
      awayScore: json['away_score'] as int?,
      status: json['status'] as String,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      innings: json['innings'] as int?,
      gameNumber: json['game_number'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'location': location,
      'home_team_id': homeTeamId,
      'away_team_id': awayTeamId,
      'home_score': homeScore,
      'away_score': awayScore,
      'status': status,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'innings': innings,
      'game_number': gameNumber,
    };
  }

  Game copyWith({
    String? id,
    DateTime? date,
    String? location,
    String? homeTeamId,
    String? awayTeamId,
    int? homeScore,
    int? awayScore,
    String? status,
    String? createdBy,
    DateTime? createdAt,
    int? innings,
    int? gameNumber,
  }) {
    return Game(
      id: id ?? this.id,
      date: date ?? this.date,
      location: location ?? this.location,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      awayTeamId: awayTeamId ?? this.awayTeamId,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      innings: innings ?? this.innings,
      gameNumber: gameNumber ?? this.gameNumber,
    );
  }
}
