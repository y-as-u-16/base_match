class Team {
  const Team({
    required this.id,
    required this.name,
    this.area,
    this.photoUrl,
    required this.inviteCode,
    required this.createdBy,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String? area;
  final String? photoUrl;
  final String inviteCode;
  final String createdBy;
  final DateTime createdAt;

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as String,
      name: json['name'] as String,
      area: json['area'] as String?,
      photoUrl: json['photo_url'] as String?,
      inviteCode: json['invite_code'] as String,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'photo_url': photoUrl,
      'invite_code': inviteCode,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Team copyWith({
    String? id,
    String? name,
    String? area,
    String? photoUrl,
    String? inviteCode,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      area: area ?? this.area,
      photoUrl: photoUrl ?? this.photoUrl,
      inviteCode: inviteCode ?? this.inviteCode,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
