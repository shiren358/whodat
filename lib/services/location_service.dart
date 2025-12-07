import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // 位置情報パーミッションの確認と要求
  static Future<bool> checkAndRequestLocationPermission() async {
    // 位置情報サービスが有効かチェック
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (kDebugMode) {
        print('位置情報サービスが無効です');
      }
      return false;
    }

    // パーミッションの確認
    LocationPermission permission = await Geolocator.checkPermission();

    // パーミッションが拒否されている場合は要求
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (kDebugMode) {
          print('位置情報パーミッションが拒否されました');
        }
        return false;
      }
    }

    // 永続的に拒否されている場合
    if (permission == LocationPermission.deniedForever) {
      if (kDebugMode) {
        print('位置情報パーミッションが永久に拒否されています');
      }
      return false;
    }

    // パーミッションが許可されている
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  // 現在位置の取得
  static Future<Position?> getCurrentLocation() async {
    try {
      // パーミッションを確認
      bool hasPermission = await checkAndRequestLocationPermission();
      if (!hasPermission) {
        return null;
      }

      // 現在位置を取得
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // デバッグログ
      if (kDebugMode) {
        print('位置情報取得成功: ${position.latitude}, ${position.longitude}');
        print('精度: ${position.accuracy}m');
        print('取得時刻: ${position.timestamp}');
      }

      return position;
    } catch (e) {
      if (kDebugMode) {
        print('位置情報の取得に失敗しました: $e');
      }
      return null;
    }
  }

  // 位置情報が有効かチェック
  Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // アプリ設定を開く（位置情報が無効な場合用）
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  // アプリ設定を開く（パーミッションが永久に拒否されている場合用）
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  // 位置情報の精度レベルを取得
  String getAccuracyLevel(LocationAccuracy accuracy) {
    switch (accuracy) {
      case LocationAccuracy.low:
        return '低精度';
      case LocationAccuracy.medium:
        return '中精度';
      case LocationAccuracy.high:
        return '高精度';
      case LocationAccuracy.best:
        return '最高精度';
      case LocationAccuracy.bestForNavigation:
        return 'ナビゲーション用最高精度';
      default:
        return '不明';
    }
  }

  // 2点間の距離を計算（メートル）
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // 位置情報ソースの説明
  String getLocationSourceDescription(LocationType type) {
    switch (type) {
      case LocationType.gps:
        return 'GPSで取得';
      case LocationType.map:
        return '地図で選択';
      case LocationType.manual:
        return '手動入力';
    }
  }
}

// 位置情報の種別
enum LocationType {
  manual, // 手動入力
  map, // 地図で選択
  gps, // GPSで取得
}
