class PlateAppearance {
  const PlateAppearance({
    required this.id,
    required this.gameId,
    this.inning,
    required this.batterPlayerId,
    required this.pitcherPlayerId,
    required this.resultType,
    required this.resultDetail,
    this.rbi,
    required this.createdBy,
    required this.createdAt,
  });

  final String id;
  final String gameId;
  final int? inning;
  final String batterPlayerId;
  final String pitcherPlayerId;
  final String resultType;
  final String resultDetail;
  final int? rbi;
  final String createdBy;
  final DateTime createdAt;

  factory PlateAppearance.fromJson(Map<String, dynamic> json) {
    return PlateAppearance(
      id: json['id'] as String,
      gameId: json['game_id'] as String,
      inning: json['inning'] as int?,
      batterPlayerId: json['batter_player_id'] as String,
      pitcherPlayerId: json['pitcher_player_id'] as String,
      resultType: json['result_type'] as String,
      resultDetail: json['result_detail'] as String,
      rbi: json['rbi'] as int?,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_id': gameId,
      'inning': inning,
      'batter_player_id': batterPlayerId,
      'pitcher_player_id': pitcherPlayerId,
      'result_type': resultType,
      'result_detail': resultDetail,
      'rbi': rbi,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PlateAppearance copyWith({
    String? id,
    String? gameId,
    int? inning,
    String? batterPlayerId,
    String? pitcherPlayerId,
    String? resultType,
    String? resultDetail,
    int? rbi,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return PlateAppearance(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      inning: inning ?? this.inning,
      batterPlayerId: batterPlayerId ?? this.batterPlayerId,
      pitcherPlayerId: pitcherPlayerId ?? this.pitcherPlayerId,
      resultType: resultType ?? this.resultType,
      resultDetail: resultDetail ?? this.resultDetail,
      rbi: rbi ?? this.rbi,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
