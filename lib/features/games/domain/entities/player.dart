class Player {
  const Player({
    required this.id,
    required this.teamId,
    required this.displayName,
    this.userId,
    required this.createdBy,
    required this.createdAt,
  });

  final String id;
  final String teamId;
  final String displayName;
  final String? userId;
  final String createdBy;
  final DateTime createdAt;

  bool get isTemp => userId == null;

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      teamId: json['team_id'] as String,
      displayName: json['display_name'] as String,
      userId: json['user_id'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team_id': teamId,
      'display_name': displayName,
      'user_id': userId,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Player copyWith({
    String? id,
    String? teamId,
    String? displayName,
    String? userId,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return Player(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      displayName: displayName ?? this.displayName,
      userId: userId ?? this.userId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
