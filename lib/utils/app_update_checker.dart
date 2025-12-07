import 'package:flutter/foundation.dart';
import 'package:new_version_plus/new_version_plus.dart';
import '../constants/app_constants.dart';

class AppUpdateChecker {
  static Future<VersionStatus?> getVersionStatus() async {
    try {
      if (kDebugMode) {
        return null;
      }

      final newVersion = NewVersionPlus(
        iOSId: AppConstants.packageName,
        androidId: AppConstants.packageName,
        iOSAppStoreCountry: AppConstants.iosAppStoreCountry,
      );

      final currentVersionStatus = await newVersion.getVersionStatus();

      if (currentVersionStatus == null) {
        if (kDebugMode) print('バージョン情報を取得できませんでした。');
        return null;
      }

      // Androidの場合、またはiOSで_getiOSVersionが失敗した場合はNewVersionPlusの結果をそのまま返す
      return currentVersionStatus;
    } catch (e) {
      if (kDebugMode) {
        print('getVersionStatusチェック中にエラーが発生しました: $e');
      }
      return null;
    }
  }
}
