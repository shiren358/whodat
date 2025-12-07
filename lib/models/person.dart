class Person {
  final String id;
  final String? name;
  final String? company;
  final String? position;
  final List<String> tags;
  final String avatarColor;
  final int additionalInfoCount;
  final String? photoPath;
  final bool isMemorized;

  Person({
    required this.id,
    this.name,
    this.company,
    this.position,
    this.tags = const [],
    required this.avatarColor,
    this.additionalInfoCount = 0,
    this.photoPath,
    this.isMemorized = false,
  });

  String get initials {
    final n = name;
    if (n == null || n.isEmpty) return '？';
    return n[0];
  }

  String get displayCompanyPosition {
    if (company != null && position != null) {
      return '$company / $position';
    } else if (company != null) {
      return company!;
    } else if (position != null) {
      return position!;
    }
    return '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company': company,
      'position': position,
      'tags': tags,
      'avatarColor': avatarColor,
      'additionalInfoCount': additionalInfoCount,
      'photoPath': photoPath,
      'isMemorized': isMemorized,
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as String,
      name: json['name'] as String?,
      company: json['company'] as String?,
      position: json['position'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      avatarColor: json['avatarColor'] as String,
      additionalInfoCount: json['additionalInfoCount'] as int? ?? 0,
      photoPath: json['photoPath'] as String?,
      isMemorized: json['isMemorized'] as bool? ?? false,
    );
  }

  Person copyWith({
    String? id,
    String? name,
    String? company,
    String? position,
    List<String>? tags,
    String? avatarColor,
    int? additionalInfoCount,
    String? photoPath,
    bool? isMemorized,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      company: company ?? this.company,
      position: position ?? this.position,
      tags: tags ?? this.tags,
      avatarColor: avatarColor ?? this.avatarColor,
      additionalInfoCount: additionalInfoCount ?? this.additionalInfoCount,
      photoPath: photoPath ?? this.photoPath,
      isMemorized: isMemorized ?? this.isMemorized,
    );
  }
}
