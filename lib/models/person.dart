class Person {
  final String id;
  final String name;
  final String? company;
  final String? position;
  final List<String> tags;
  final DateTime registeredDate;
  final String avatarColor;
  final int additionalInfoCount;

  Person({
    required this.id,
    required this.name,
    this.company,
    this.position,
    this.tags = const [],
    required this.registeredDate,
    required this.avatarColor,
    this.additionalInfoCount = 0,
  });

  String get initials {
    if (name.isEmpty) return '';
    return name[0];
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

  String get formattedDate {
    return '${registeredDate.year}.${registeredDate.month.toString().padLeft(2, '0')}.${registeredDate.day.toString().padLeft(2, '0')}';
  }
}
