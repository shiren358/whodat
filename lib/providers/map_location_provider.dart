import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../services/location_service.dart';

/// MapLocationSelectionView のビジネスロジックを管理するProvider
class MapLocationProvider with ChangeNotifier {
  // ===== プライベート状態フィールド =====

  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  final Set<Marker> _markers = {};
  String _locationName = '';
  bool _isLoading = false;

  // ===== パブリックゲッター =====

  GoogleMapController? get mapController => _mapController;
  LatLng? get selectedLocation => _selectedLocation;
  Set<Marker> get markers => Set.unmodifiable(_markers);
  String get locationName => _locationName;
  bool get isLoading => _isLoading;

  // ===== ロケーション関連メソッド =====

  /// 言語に応じた場所名を取得（デフォルト値）
  String _getDefaultLocationName(LatLng location) {
    // 現在地の場合は言語に応じた場所名を返す
    final languageCode = Platform.localeName.split('_')[0];

    if (languageCode == 'ja') return '東京'; // 日本語
    if (languageCode == 'en') return 'New York'; // 英語
    if (languageCode == 'zh') return '北京'; // 中国語
    if (languageCode == 'ko') return 'ソウル'; // 韓国語

    return 'Paris'; // その他
  }

  /// 逆ジオコーディングで住所を取得
  Future<String> _getAddressFromCoordinates(LatLng location) async {
    try {
      final locations = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (locations.isNotEmpty) {
        final place = locations.first;
        List<String> addressParts = [];

        // 国名
        if (place.country?.isNotEmpty == true) {
          addressParts.add(place.country!);
        }

        // 都道府県
        if (place.administrativeArea?.isNotEmpty == true) {
          addressParts.add(place.administrativeArea!);
        }

        // 市区市町村
        if (place.subAdministrativeArea?.isNotEmpty == true) {
          addressParts.add(place.subAdministrativeArea!);
        }

        // 地域名
        if (place.locality?.isNotEmpty == true) {
          addressParts.add(place.locality!);
        }

        // 通り名
        if (place.thoroughfare?.isNotEmpty == true) {
          addressParts.add(place.thoroughfare!);
        }

        return addressParts.join(' ') +
            (place.subThoroughfare?.isNotEmpty == true
                ? ' ${place.subThoroughfare}'
                : '');
      }
    } catch (e) {
      if (kDebugMode) {
        print('住所取得エラー: $e');
      }
    }

    return _getDefaultLocationName(location);
  }

  /// マップの初期化
  Future<void> initializeMap({
    double? initialLatitude,
    double? initialLongitude,
  }) async {
    _setLoading(true);

    try {
      // 初期位置を設定
      if (initialLatitude != null && initialLongitude != null) {
        if (kDebugMode) {
          print('初期位置を使用: $initialLatitude, $initialLongitude');
        }
        _selectedLocation = LatLng(initialLatitude, initialLongitude);
      } else {
        // 現在位置を取得
        final currentPosition = await LocationService.getCurrentPosition();
        _selectedLocation = LatLng(
          currentPosition.latitude,
          currentPosition.longitude,
        );
      }

      if (_selectedLocation != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('selected_location'),
            position: _selectedLocation!,
            infoWindow: InfoWindow(
              title: _locationName.isEmpty ? '選択された場所' : _locationName,
            ),
          ),
        );

        // 初期位置の住所を取得
        if (_locationName.isEmpty) {
          _locationName = await _getAddressFromCoordinates(_selectedLocation!);
          _updateMarkerInfoWindow();
        }
      }
    } finally {
      _setLoading(false);
    }

    notifyListeners();

    // 初期化完了後に地図があれば移動
    if (_mapController != null && _selectedLocation != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_selectedLocation!, 15),
        );
      });
    }
  }

  /// 地図コントローラーを設定
  void setMapController(GoogleMapController controller) {
    _mapController = controller;

    if (kDebugMode) {
      print('setMapController called - _selectedLocation: $_selectedLocation');
    }

    // 地図コントローラー設定後に初期位置に移動
    if (_selectedLocation != null) {
      if (kDebugMode) {
        print(
          '地図を移動: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
        );
      }
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_selectedLocation!, 15),
      );
    } else {
      if (kDebugMode) {
        print('_selectedLocationがnullのため移動しない');
      }
    }
  }

  /// 地図がタップされたとき
  Future<void> onMapTapped(LatLng location) async {
    _selectedLocation = location;
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('selected_location'),
        position: location,
        infoWindow: const InfoWindow(title: '住所取得中...'),
      ),
    );
    notifyListeners();

    // 地図をタップした位置に移動
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(location));
    }

    // 逆ジオコーディングで住所を取得
    await _getAddressForLocation(location);
  }

  /// 住所を取得してlocationNameを更新
  Future<void> _getAddressForLocation(LatLng location) async {
    final address = await _getAddressFromCoordinates(location);

    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('selected_location'),
        position: location,
        infoWindow: InfoWindow(title: address),
      ),
    );
    _locationName = address;

    notifyListeners();
  }

  /// 現在地に移動
  Future<void> moveToCurrentLocation() async {
    final currentPosition = await LocationService.getCurrentPosition();
    final location = LatLng(
      currentPosition.latitude,
      currentPosition.longitude,
    );

    // マーカーと住所を更新
    _selectedLocation = location;
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('selected_location'),
        position: location,
        infoWindow: const InfoWindow(title: '住所取得中...'),
      ),
    );
    notifyListeners();

    // カメラを移動
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(location, 15));
    }

    // 住所を取得して更新
    await _getAddressForLocation(location);
  }

  /// 場所名を手動で更新
  void updateLocationName(String name) {
    _locationName = name;
    _updateMarkerInfoWindow();
    notifyListeners();
  }

  /// マーカーの情報ウィンドウを更新
  void _updateMarkerInfoWindow() {
    if (_selectedLocation != null && _markers.isNotEmpty) {
      final marker = _markers.first;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: marker.markerId,
          position: marker.position,
          infoWindow: InfoWindow(title: _locationName),
        ),
      );
    }
  }

  /// 選択を確定
  Map<String, dynamic>? confirmSelection() {
    if (_selectedLocation != null && _locationName.trim().isNotEmpty) {
      return {
        'location': _locationName.trim(),
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
      };
    }
    return null;
  }

  /// ローディング状態を設定
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// クリーンアップ
  @override
  void dispose() {
    _mapController = null;
    super.dispose();
  }
}
