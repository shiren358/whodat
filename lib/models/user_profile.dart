class UserProfile {
  final String name;
  final DateTime createdAt;

  UserProfile({
    required this.name,
    required this.createdAt,
  });

  String get initials {
    if (name.isEmpty) return '?';
    return name[0];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  UserProfile copyWith({
    String? name,
    DateTime? createdAt,
  }) {
    return UserProfile(
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
