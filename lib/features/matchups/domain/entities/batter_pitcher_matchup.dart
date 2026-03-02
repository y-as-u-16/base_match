class BatterPitcherMatchup {
  const BatterPitcherMatchup({
    required this.batterPlayerId,
    required this.pitcherPlayerId,
    required this.batterName,
    required this.pitcherName,
    required this.ab,
    required this.hits,
    required this.hr,
    required this.bbHbp,
    required this.so,
    required this.avg,
  });

  final String batterPlayerId;
  final String pitcherPlayerId;
  final String batterName;
  final String pitcherName;
  final int ab;
  final int hits;
  final int hr;
  final int bbHbp;
  final int so;
  final double avg;

  factory BatterPitcherMatchup.fromJson(Map<String, dynamic> json) {
    final ab = (json['ab'] as num?)?.toInt() ?? 0;
    final hits = (json['hits'] as num?)?.toInt() ?? 0;
    return BatterPitcherMatchup(
      batterPlayerId: json['batter_player_id'] as String,
      pitcherPlayerId: json['pitcher_player_id'] as String,
      batterName: json['batter_name'] as String? ?? '',
      pitcherName: json['pitcher_name'] as String? ?? '',
      ab: ab,
      hits: hits,
      hr: (json['hr'] as num?)?.toInt() ?? 0,
      bbHbp: (json['bb_hbp'] as num?)?.toInt() ?? 0,
      so: (json['so'] as num?)?.toInt() ?? 0,
      avg: ab > 0 ? hits / ab : 0.0,
    );
  }
}
