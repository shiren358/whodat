import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static bool _isFirstLaunch = true;

  // デフォルトの位置（東京）
  static Position get _defaultLocation => Position(
    longitude: 139.6503,
    latitude: 35.6762,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );

  // 現在位置を取得（初回はパーミッション要求、2回目以降は状態チェックのみ）
  static Future<Position> _getCurrentPositionInternal() async {
    try {
      // 位置情報サービスが有効かチェック
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (kDebugMode) {
          print('位置情報サービスが無効です');
        }
        return _defaultLocation;
      }

      LocationPermission permission;

      if (_isFirstLaunch) {
        // 初回：パーミッションを要求
        permission = await Geolocator.requestPermission();
        _isFirstLaunch = false;

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          if (kDebugMode) {
            print('位置情報パーミッションが拒否されました');
          }
          return _defaultLocation;
        }
      } else {
        // 2回目以降：パーミッション状態のみチェック
        permission = await Geolocator.checkPermission();

        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          if (kDebugMode) {
            print('位置情報パーミッションがありません');
          }
          return _defaultLocation;
        }
      }

      // 現在位置を取得
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      if (kDebugMode) {
        print('現在地を取得: ${position.latitude}, ${position.longitude}');
      }

      return position;
    } catch (e) {
      if (kDebugMode) {
        print('位置情報取得エラー: $e');
      }
      return _defaultLocation;
    }
  }

  // 初回起動フラグをリセット（テスト用）
  static void resetFirstLaunchFlag() {
    _isFirstLaunch = true;
  }

  // メインの位置取得メソッド
  static Future<Position> getCurrentPosition() => _getCurrentPositionInternal();

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
