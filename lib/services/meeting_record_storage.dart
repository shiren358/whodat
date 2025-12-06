import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meeting_record.dart';

class MeetingRecordStorage {
  static const String _key = 'meeting_records';

  static Future<void> saveMeetingRecord(MeetingRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getAllMeetingRecords();
    records.add(record);

    final jsonList = records.map((r) => r.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  static Future<List<MeetingRecord>> getAllMeetingRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => MeetingRecord.fromJson(json)).toList();
  }

  static Future<List<MeetingRecord>> getMeetingRecordsByPersonId(
      String personId) async {
    final allRecords = await getAllMeetingRecords();
    return allRecords.where((r) => r.personId == personId).toList();
  }

  static Future<MeetingRecord?> getMeetingRecordById(String id) async {
    final allRecords = await getAllMeetingRecords();
    try {
      return allRecords.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<void> updateMeetingRecord(MeetingRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getAllMeetingRecords();

    final index = records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      records[index] = record;
      final jsonList = records.map((r) => r.toJson()).toList();
      await prefs.setString(_key, jsonEncode(jsonList));
    }
  }

  static Future<void> deleteMeetingRecord(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getAllMeetingRecords();

    records.removeWhere((r) => r.id == id);
    final jsonList = records.map((r) => r.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  static Future<void> deleteMeetingRecordsByPersonId(String personId) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getAllMeetingRecords();

    records.removeWhere((r) => r.personId == personId);
    final jsonList = records.map((r) => r.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }
}
