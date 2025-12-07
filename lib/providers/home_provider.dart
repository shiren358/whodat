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
  List<MeetingRecord> _allMeetingRecords = []; // 全記録を保持
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
  List<MeetingRecord> get allMeetingRecords => _allMeetingRecords;
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

  // 人物ごとの最新のMeetingRecordを取得（すべての記録用）
  List<MeetingRecord> get allLatestMeetingRecordsByPerson {
    final personIdToRecord = <String, MeetingRecord>{};

    for (final record in _allMeetingRecords) {
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

      // 日付関連の検索（タグ検索の前に行う）
      if (_isDateSearch(query)) {
        return _matchesDateSearch(record, query);
      }

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

      // タグで検索（日付関連は除外）
      if (person.tags.any(
        (tag) => tag.toLowerCase().contains(lowercaseQuery) &&
                 !_isDateSearch(tag),
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
    _allMeetingRecords = await MeetingRecordStorage.getAllMeetingRecords();

    // PersonsをMapに変換（高速な検索用）
    _personsMap = {};
    for (final person in _allPersons) {
      _personsMap[person.id] = person;
    }

    // 最近の記録（直近90日）でフィルタリング
    final now = DateTime.now();
    final cutoffDate = now.subtract(const Duration(days: 90));

    _recentMeetingRecords = _allMeetingRecords
        .where((record) =>
            record.meetingDate != null &&
            record.meetingDate!.isAfter(cutoffDate.subtract(const Duration(days: 1)))) // 境界日を含める
        .toList();

    // MeetingRecordsを日付でソート（新しい順、nullは最後）
    _allMeetingRecords.sort((a, b) {
      if (a.meetingDate == null && b.meetingDate == null) return 0;
      if (a.meetingDate == null) return 1;
      if (b.meetingDate == null) return -1;
      return b.meetingDate!.compareTo(a.meetingDate!);
    });

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

  bool _isDateSearch(String query) {
    final dateKeywords = ['先週会った', '今日', '今月'];
    return dateKeywords.contains(query);
  }

  bool _matchesDateSearch(MeetingRecord record, String query) {
    if (record.meetingDate == null) return false;

    final now = DateTime.now();
    final meetingDate = record.meetingDate!;
    final today = DateTime(now.year, now.month, now.day);
    final meetingDateOnly = DateTime(meetingDate.year, meetingDate.month, meetingDate.day);

    switch (query) {
      case '先週会った':
        // 先週（月曜日から日曜日まで）
        final startOfLastWeek = today.subtract(Duration(days: today.weekday + 6));
        final endOfLastWeek = startOfLastWeek.add(const Duration(days: 6));
        return !meetingDateOnly.isBefore(startOfLastWeek) &&
               !meetingDateOnly.isAfter(endOfLastWeek);

      case '今日':
        // 今日
        return meetingDateOnly.year == today.year &&
               meetingDateOnly.month == today.month &&
               meetingDateOnly.day == today.day;

      case '今月':
        // 今月
        return meetingDateOnly.year == today.year &&
               meetingDateOnly.month == today.month;

      default:
        return false;
    }
  }
}
