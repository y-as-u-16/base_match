class TeamMember {
  const TeamMember({
    required this.id,
    required this.teamId,
    required this.userId,
    required this.role,
    required this.displayName,
    required this.createdAt,
  });

  final String id;
  final String teamId;
  final String userId;
  final String role;
  final String displayName;
  final DateTime createdAt;

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'] as String,
      teamId: json['team_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String,
      displayName: json['display_name'] as String? ??
          (json['users'] != null
              ? json['users']['display_name'] as String
              : ''),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team_id': teamId,
      'user_id': userId,
      'role': role,
      'display_name': displayName,
      'created_at': createdAt.toIso8601String(),
    };
  }

  TeamMember copyWith({
    String? id,
    String? teamId,
    String? userId,
    String? role,
    String? displayName,
    DateTime? createdAt,
  }) {
    return TeamMember(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
