import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
  String _appVersion = ''; // Add this

  // Getters
  List<Person> get allPersons => _allPersons;
  List<MeetingRecord> get allMeetingRecords => _allMeetingRecords;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String get appVersion => _appVersion; // Add this

  // 統計情報
  int get totalPersons => _allPersons.where((p) => p.isMemorized).length;
  int get thisMonthMeetings => _getThisMonthMeetings();
  int get memoryRankLevel => _getMemoryRankLevel();

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

      // Get app version
      final packageInfo = await PackageInfo.fromPlatform();
      _appVersion = 'v${packageInfo.version}';
    } catch (e) {
      if (kDebugMode) {
        print('MyPageProvider: データ読み込みエラー: $e');
      }
      _appVersion = 'N/A'; // Fallback in case of error
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
      return !meetingMonth.isBefore(thisMonth) &&
          meetingMonth.isBefore(nextMonth);
    }).length;
  }

  int _getMemoryRankLevel() {
    final count = totalPersons;
    if (count == 0) return 0;
    if (count < 10) return 1;
    if (count < 30) return 2;
    if (count < 100) return 3;
    return 4;
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
