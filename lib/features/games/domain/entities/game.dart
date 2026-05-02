class Game {
  const Game({
    required this.id,
    required this.date,
    this.location,
    required this.homeTeamName,
    required this.awayTeamName,
    this.homeScore,
    this.awayScore,
    required this.status,
    required this.createdAt,
    this.innings,
  });

  final String id;
  final DateTime date;
  final String? location;
  final String homeTeamName;
  final String awayTeamName;
  final int? homeScore;
  final int? awayScore;
  final String status;
  final DateTime createdAt;
  final int? innings;

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String?,
      homeTeamName: json['home_team_name'] as String,
      awayTeamName: json['away_team_name'] as String,
      homeScore: json['home_score'] as int?,
      awayScore: json['away_score'] as int?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      innings: json['innings'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'location': location,
      'home_team_name': homeTeamName,
      'away_team_name': awayTeamName,
      'home_score': homeScore,
      'away_score': awayScore,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'innings': innings,
    };
  }

  Game copyWith({
    String? id,
    DateTime? date,
    String? location,
    String? homeTeamName,
    String? awayTeamName,
    int? homeScore,
    int? awayScore,
    String? status,
    DateTime? createdAt,
    int? innings,
  }) {
    return Game(
      id: id ?? this.id,
      date: date ?? this.date,
      location: location ?? this.location,
      homeTeamName: homeTeamName ?? this.homeTeamName,
      awayTeamName: awayTeamName ?? this.awayTeamName,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      innings: innings ?? this.innings,
    );
  }
}
