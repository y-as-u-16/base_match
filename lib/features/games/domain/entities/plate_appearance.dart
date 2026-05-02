class PlateAppearance {
  const PlateAppearance({
    required this.id,
    required this.gameId,
    this.inning,
    required this.battingSide,
    required this.resultType,
    required this.resultDetail,
    this.rbi,
    required this.createdAt,
  });

  final String id;
  final String gameId;
  final int? inning;
  final String battingSide;
  final String resultType;
  final String resultDetail;
  final int? rbi;
  final DateTime createdAt;

  factory PlateAppearance.fromJson(Map<String, dynamic> json) {
    return PlateAppearance(
      id: json['id'] as String,
      gameId: json['game_id'] as String,
      inning: json['inning'] as int?,
      battingSide: json['batting_side'] as String,
      resultType: json['result_type'] as String,
      resultDetail: json['result_detail'] as String,
      rbi: json['rbi'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_id': gameId,
      'inning': inning,
      'batting_side': battingSide,
      'result_type': resultType,
      'result_detail': resultDetail,
      'rbi': rbi,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PlateAppearance copyWith({
    String? id,
    String? gameId,
    int? inning,
    String? battingSide,
    String? resultType,
    String? resultDetail,
    int? rbi,
    DateTime? createdAt,
  }) {
    return PlateAppearance(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      inning: inning ?? this.inning,
      battingSide: battingSide ?? this.battingSide,
      resultType: resultType ?? this.resultType,
      resultDetail: resultDetail ?? this.resultDetail,
      rbi: rbi ?? this.rbi,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
