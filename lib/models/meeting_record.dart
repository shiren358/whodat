class MeetingRecord {
  final String id;
  final String personId;
  final DateTime? meetingDate;
  final String? location;
  final String? notes;
  final double? latitude;
  final double? longitude;

  MeetingRecord({
    required this.id,
    required this.personId,
    this.meetingDate,
    this.location,
    this.notes,
    this.latitude,
    this.longitude,
  });

  String get formattedDate {
    if (meetingDate == null) return '日付未設定';
    return '${meetingDate!.year}.${meetingDate!.month.toString().padLeft(2, '0')}.${meetingDate!.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personId': personId,
      'meetingDate': meetingDate?.toIso8601String(),
      'location': location,
      'notes': notes,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory MeetingRecord.fromJson(Map<String, dynamic> json) {
    return MeetingRecord(
      id: json['id'] as String,
      personId: json['personId'] as String,
      meetingDate: json['meetingDate'] != null
          ? DateTime.parse(json['meetingDate'] as String)
          : null,
      location: json['location'] as String?,
      notes: json['notes'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }
}
