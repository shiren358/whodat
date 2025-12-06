import 'package:flutter/foundation.dart';
import '../models/person.dart';
import '../models/meeting_record.dart';
import '../services/person_storage.dart';
import '../services/meeting_record_storage.dart';

class HomeProvider with ChangeNotifier {
  String _searchQuery = '';
  final List<String> _suggestedTags = ['先週会った', '渋谷', 'メガネ', '営業'];
  List<Person> _allPersons = [];
  List<MeetingRecord> _recentMeetingRecords = [];
  Map<String, Person> _personsMap = {};

  String get searchQuery => _searchQuery;
  List<String> get suggestedTags => _suggestedTags;
  List<Person> get recentPersons => _allPersons;
  List<MeetingRecord> get recentMeetingRecords => _recentMeetingRecords;

  // 人物ごとの最新のMeetingRecordを取得（Home画面用）
  List<MeetingRecord> get latestMeetingRecordsByPerson {
    final personIdToRecord = <String, MeetingRecord>{};

    for (final record in _recentMeetingRecords) {
      final existingRecord = personIdToRecord[record.personId];
      if (existingRecord == null) {
        personIdToRecord[record.personId] = record;
      } else {
        // より新しい日付の記録を保持
        if (record.meetingDate != null) {
          if (existingRecord.meetingDate == null ||
              record.meetingDate!.isAfter(existingRecord.meetingDate!)) {
            personIdToRecord[record.personId] = record;
          }
        }
      }
    }

    final records = personIdToRecord.values.toList();
    records.sort((a, b) {
      if (a.meetingDate == null && b.meetingDate == null) return 0;
      if (a.meetingDate == null) return 1;
      if (b.meetingDate == null) return -1;
      return b.meetingDate!.compareTo(a.meetingDate!);
    });

    return records;
  }

  HomeProvider() {
    loadData();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadData() async {
    _allPersons = await PersonStorage.getAllPersons();
    _recentMeetingRecords = await MeetingRecordStorage.getAllMeetingRecords();

    // PersonsをMapに変換（高速な検索用）
    _personsMap = {};
    for (final person in _allPersons) {
      _personsMap[person.id] = person;
    }

    // MeetingRecordsを日付でソート（新しい順、nullは最後）
    _recentMeetingRecords.sort((a, b) {
      if (a.meetingDate == null && b.meetingDate == null) return 0;
      if (a.meetingDate == null) return 1;
      if (b.meetingDate == null) return -1;
      return b.meetingDate!.compareTo(a.meetingDate!);
    });

    notifyListeners();
  }

  // MeetingRecordに対応するPersonを取得
  Person? getPersonForRecord(MeetingRecord record) {
    return _personsMap[record.personId];
  }

  // Personの全MeetingRecordを取得
  List<MeetingRecord> getMeetingRecordsForPerson(String personId) {
    return _recentMeetingRecords
        .where((record) => record.personId == personId)
        .toList()
      ..sort((a, b) {
        if (a.meetingDate == null && b.meetingDate == null) return 0;
        if (a.meetingDate == null) return 1;
        if (b.meetingDate == null) return -1;
        return b.meetingDate!.compareTo(a.meetingDate!);
      });
  }
}
