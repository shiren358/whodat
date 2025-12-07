import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import '../utils/app_update_checker.dart';
import '../constants/app_constants.dart';

class AppUpdateService {
  static final AppUpdateService _instance = AppUpdateService._internal();
  factory AppUpdateService() => _instance;
  AppUpdateService._internal();

  final NewVersionPlus _newVersion = NewVersionPlus(
    iOSId: AppConstants.packageName,
    androidId: AppConstants.packageName,
    iOSAppStoreCountry: AppConstants.iosAppStoreCountry,
  );

  Future<void> checkForUpdates(BuildContext context) async {
    try {
      final appVersionStatus = await AppUpdateChecker.getVersionStatus();

      if (appVersionStatus != null &&
          appVersionStatus.canUpdate &&
          context.mounted) {
        _showUpdateDialog(context, appVersionStatus);
      }
    } catch (e) {
      debugPrint('アプデートチェック中にエラーが発生しました: $e');
    }
  }

  void _showUpdateDialog(BuildContext context, VersionStatus appVersionStatus) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('新しいバージョンがあります'),
        content: const Text('アプリを快適にご利用いただくために、最新バージョンへのアップデートをお願いいたします。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('後で'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (appVersionStatus.appStoreLink.isNotEmpty) {
                await _newVersion.launchAppStore(appVersionStatus.appStoreLink);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ストアのリンクを取得できませんでした。')),
                  );
                }
              }
            },
            child: const Text('今すぐアップデート'),
          ),
        ],
      ),
    );
  }
}
