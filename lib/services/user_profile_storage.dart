import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_profile.dart';

class UserProfileStorage {
  static const String _key = 'user_profile';
  static const _storage = FlutterSecureStorage();

  static Future<UserProfile?> getUserProfile() async {
    final jsonString = await _storage.read(key: _key);
    if (jsonString == null) return null;

    final json = jsonDecode(jsonString);
    return UserProfile.fromJson(json);
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    await _storage.write(key: _key, value: jsonEncode(profile.toJson()));
  }

  static Future<void> deleteUserProfile() async {
    await _storage.delete(key: _key);
  }
}

