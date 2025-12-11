/// AdMob Configuration
class AdMobConfig {
  // アプリID
  static const String appId = 'ca-app-pub-6883936360376801~8018494696';

  // 広告ユニットID
  static const String homeBannerAdUnitId = 'ca-app-pub-6883936360376801/9147743538';
  static const String addPersonBannerAdUnitId = 'ca-app-pub-6883936360376801/9147743538'; // 同じIDを使用

  // テスト用広告ユニットID
  static const String testBannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716';

  // 本番モードかどうか
  static bool get isProductionMode => !bool.fromEnvironment('DEBUG');

  // 広告ユニットIDを取得（本番/テストで切り替え）
  static String getBannerAdUnitId() {
    return isProductionMode ? homeBannerAdUnitId : testBannerAdUnitId;
  }
}