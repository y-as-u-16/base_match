class PlateAppearance {
  const PlateAppearance({
    required this.id,
    required this.gameId,
    required this.batterName,
    this.inning,
    required this.resultType,
    required this.resultDetail,
    this.rbi,
    required this.createdAt,
  });

  final String id;
  final String gameId;
  final String batterName;
  final int? inning;
  final String resultType;
  final String resultDetail;
  final int? rbi;
  final DateTime createdAt;

  factory PlateAppearance.fromJson(Map<String, dynamic> json) {
    return PlateAppearance(
      id: json['id'] as String,
      gameId: json['game_id'] as String,
      batterName: json['batter_name'] as String,
      inning: json['inning'] as int?,
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
      'batter_name': batterName,
      'inning': inning,
      'result_type': resultType,
      'result_detail': resultDetail,
      'rbi': rbi,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PlateAppearance copyWith({
    String? id,
    String? gameId,
    String? batterName,
    int? inning,
    String? resultType,
    String? resultDetail,
    int? rbi,
    DateTime? createdAt,
  }) {
    return PlateAppearance(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      batterName: batterName ?? this.batterName,
      inning: inning ?? this.inning,
      resultType: resultType ?? this.resultType,
      resultDetail: resultDetail ?? this.resultDetail,
      rbi: rbi ?? this.rbi,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
