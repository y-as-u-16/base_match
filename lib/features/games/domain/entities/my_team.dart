class MyTeam {
  const MyTeam({
    required this.id,
    required this.name,
    this.colorKey,
    required this.isDefault,
    required this.displayOrder,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String? colorKey;
  final bool isDefault;
  final int displayOrder;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory MyTeam.fromJson(Map<String, dynamic> json) {
    return MyTeam(
      id: json['id'] as String,
      name: json['name'] as String,
      colorKey: json['color_key'] as String?,
      isDefault: json['is_default'] as bool,
      displayOrder: json['display_order'] as int,
      archivedAt: json['archived_at'] == null
          ? null
          : DateTime.parse(json['archived_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color_key': colorKey,
      'is_default': isDefault,
      'display_order': displayOrder,
      'archived_at': archivedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  MyTeam copyWith({
    String? id,
    String? name,
    String? colorKey,
    bool? isDefault,
    int? displayOrder,
    DateTime? archivedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MyTeam(
      id: id ?? this.id,
      name: name ?? this.name,
      colorKey: colorKey ?? this.colorKey,
      isDefault: isDefault ?? this.isDefault,
      displayOrder: displayOrder ?? this.displayOrder,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
