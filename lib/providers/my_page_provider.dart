import 'package:flutter/foundation.dart';
import '../services/person_storage.dart';
import '../services/meeting_record_storage.dart';
import '../services/user_profile_storage.dart';
import '../models/person.dart';
import '../models/meeting_record.dart';
import '../models/user_profile.dart';

class MyPageProvider with ChangeNotifier {
  List<Person> _allPersons = [];
  List<MeetingRecord> _allMeetingRecords = [];
  UserProfile? _userProfile;
  bool _isLoading = true;

  // Getters
  List<Person> get allPersons => _allPersons;
  List<MeetingRecord> get allMeetingRecords => _allMeetingRecords;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  // 統計情報
  int get totalPersons => _allPersons.length;
  int get totalMeetings => _allMeetingRecords.length;
  int get thisMonthMeetings => _getThisMonthMeetings();
  String get mostUsedLocation => _getMostUsedLocation();
  String get memoryRank => _getMemoryRank();

  MyPageProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allPersons = await PersonStorage.getAllPersons();
      _allMeetingRecords = await MeetingRecordStorage.getAllMeetingRecords();
      _userProfile = await UserProfileStorage.getUserProfile();
    } catch (e) {
      if (kDebugMode) {
        print('MyPageProvider: データ読み込みエラー: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(String name) async {
    try {
      final profile = UserProfile(
        name: name,
        createdAt: _userProfile?.createdAt ?? DateTime.now(),
      );
      await UserProfileStorage.saveUserProfile(profile);
      _userProfile = profile;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('MyPageProvider: プロフィール更新エラー: $e');
      }
    }
  }

  int _getThisMonthMeetings() {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month, 1);
    final nextMonth = DateTime(now.year, now.month + 1, 1);

    return _allMeetingRecords.where((record) {
      if (record.meetingDate == null) return false;
      final meetingDate = record.meetingDate!;
      final meetingMonth = DateTime(meetingDate.year, meetingDate.month, 1);
      return !meetingMonth.isBefore(thisMonth) && meetingMonth.isBefore(nextMonth);
    }).length;
  }

  String _getMostUsedLocation() {
    final locationCounts = <String, int>{};

    for (final record in _allMeetingRecords) {
      if (record.location != null && record.location!.isNotEmpty) {
        locationCounts[record.location!] = (locationCounts[record.location!] ?? 0) + 1;
      }
    }

    if (locationCounts.isEmpty) return 'データなし';

    // 最も多い場所を見つける
    String mostUsedLocation = '';
    int maxCount = 0;

    locationCounts.forEach((location, count) {
      if (count > maxCount) {
        maxCount = count;
        mostUsedLocation = location;
      }
    });

    return '$mostUsedLocation ($maxCount回)';
  }

  String _getMemoryRank() {
    final count = totalPersons;
    if (count == 0) return '初心者';
    if (count < 10) return 'ブロンズ会員';
    if (count < 30) return 'シルバー会員';
    if (count < 100) return 'ゴールド会員';
    return 'プラチナ会員';
  }

  Future<void> deletePerson(String personId) async {
    try {
      // 関連するMeetingRecordを削除
      final personRecords = _allMeetingRecords
          .where((record) => record.personId == personId)
          .toList();

      for (final record in personRecords) {
        await MeetingRecordStorage.deleteMeetingRecord(record.id);
      }

      // Personを削除
      await PersonStorage.deletePerson(personId);

      // データを再読み込み
      await loadData();
    } catch (e) {
      if (kDebugMode) {
        print('MyPageProvider: 削除エラー: $e');
      }
    }
  }
}