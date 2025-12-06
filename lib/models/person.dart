class Person {
  final String id;
  final String? name;
  final String? company;
  final String? position;
  final List<String> tags;
  final String avatarColor;
  final int additionalInfoCount;
  final String? photoPath;

  Person({
    required this.id,
    this.name,
    this.company,
    this.position,
    this.tags = const [],
    required this.avatarColor,
    this.additionalInfoCount = 0,
    this.photoPath,
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
    );
  }
}
