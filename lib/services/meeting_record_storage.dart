import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/meeting_record.dart';

class MeetingRecordStorage {
  static const String _key = 'meeting_records';
  static const _storage = FlutterSecureStorage();

  static Future<void> _saveRecords(List<MeetingRecord> records) async {
    final jsonList = records.map((r) => r.toJson()).toList();
    await _storage.write(key: _key, value: jsonEncode(jsonList));
  }

  static Future<void> saveMeetingRecord(MeetingRecord record) async {
    final records = await getAllMeetingRecords();
    records.add(record);
    await _saveRecords(records);
  }

  static Future<List<MeetingRecord>> getAllMeetingRecords() async {
    final jsonString = await _storage.read(key: _key);
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
    final records = await getAllMeetingRecords();
    final index = records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      records[index] = record;
      await _saveRecords(records);
    }
  }

  static Future<void> deleteMeetingRecord(String id) async {
    final records = await getAllMeetingRecords();
    records.removeWhere((r) => r.id == id);
    await _saveRecords(records);
  }

  static Future<void> deleteMeetingRecordsByPersonId(String personId) async {
    final records = await getAllMeetingRecords();
    records.removeWhere((r) => r.personId == personId);
    await _saveRecords(records);
  }
}

