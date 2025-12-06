import 'package:flutter/foundation.dart';
import '../models/person.dart';
import '../models/meeting_record.dart';
import '../services/person_storage.dart';
import '../services/meeting_record_storage.dart';

class HomeProvider with ChangeNotifier {
  String _searchQuery = '';
  final List<String> _suggestedTags = ['先週会った', '今日', '今月'];
  List<Person> _allPersons = [];
  List<MeetingRecord> _recentMeetingRecords = [];
  Map<String, Person> _personsMap = {};
  List<MeetingRecord> _searchResults = [];

  String get searchQuery => _searchQuery;
  List<String> get suggestedTags => _suggestedTags;

  List<String> _randomTags = [];

  // 登録されているユニークタグからランダムに3つ選択
  List<String> get randomTags => _randomTags;

  // ランダムタグを再生成
  void _regenerateRandomTags() {
    final Set<String> uniqueTags = {};

    // 全人物のタグを収集
    for (final person in _allPersons) {
      for (final tag in person.tags) {
        uniqueTags.add(tag);
      }
    }

    final tagList = uniqueTags.toList();
    tagList.shuffle(); // ランダムに並び替え

    // 最大3つを保存
    _randomTags = tagList.take(3).toList();
  }

  List<Person> get recentPersons => _allPersons;
  List<MeetingRecord> get recentMeetingRecords => _recentMeetingRecords;
  List<MeetingRecord> get searchResults => _searchResults;
  bool get hasSearchQuery => _searchQuery.isNotEmpty;
  bool get hasSearchResults => _searchResults.isNotEmpty;

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
    _performSearch(query);
    notifyListeners();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      _searchResults.clear();
      return;
    }

    final lowercaseQuery = query.toLowerCase();

    _searchResults = _recentMeetingRecords.where((record) {
      final person = _personsMap[record.personId];
      if (person == null) return false;

      // 名前で検索
      if (person.name?.toLowerCase().contains(lowercaseQuery) == true) {
        return true;
      }

      // 会社名で検索
      if (person.company?.toLowerCase().contains(lowercaseQuery) == true) {
        return true;
      }

      // 役職で検索
      if (person.position?.toLowerCase().contains(lowercaseQuery) == true) {
        return true;
      }

      // タグで検索
      if (person.tags.any(
        (tag) => tag.toLowerCase().contains(lowercaseQuery),
      )) {
        return true;
      }

      // 場所で検索
      if (record.location != null &&
          record.location!.toLowerCase().contains(lowercaseQuery)) {
        return true;
      }

      // メモで検索
      if (record.notes != null &&
          record.notes!.toLowerCase().contains(lowercaseQuery)) {
        return true;
      }

      return false;
    }).toList();

    // 検索結果を日付でソート（新しい順）
    _searchResults.sort((a, b) {
      if (a.meetingDate == null && b.meetingDate == null) return 0;
      if (a.meetingDate == null) return 1;
      if (b.meetingDate == null) return -1;
      return b.meetingDate!.compareTo(a.meetingDate!);
    });
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults.clear();
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

    // ランダムタグを生成
    _regenerateRandomTags();

    // 検索クエリがある場合は検索を再実行
    if (_searchQuery.isNotEmpty) {
      _performSearch(_searchQuery);
    }

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
