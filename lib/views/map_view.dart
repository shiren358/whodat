import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../providers/add_person_provider.dart';
import '../models/meeting_record.dart';
import '../models/person.dart';
import '../services/location_service.dart';
import 'add_person_view.dart';
import '../l10n/l10n.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;

  // 日本の中心（東京付近）
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(35.6812, 139.7671), // 東京駅
    zoom: 10.0,
  );

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  // 現在地にカメラを移動する
  Future<void> _moveToCurrentUserLocation() async {
    final position = await LocationService.getCurrentPosition();
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15.0, // 少しズームインする
          ),
        ),
      );
    }
  }

  // Providerのデータからマーカーのセットを生成する
  Set<Marker> _prepareMarkers(HomeProvider provider, BuildContext context) {
    final records = provider.allLatestMeetingRecordsByPerson;
    final markers = <Marker>{};

    if (kDebugMode) {
      print('表示する総記録数: ${records.length}');
    }

    for (final record in records) {
      if (record.latitude != null && record.longitude != null) {
        final person = provider.getPersonForRecord(record);
        if (person != null) {
          final marker = _createMarker(record, person, context);
          markers.add(marker);
        }
      }
    }

    if (kDebugMode) {
      print('作成したマーカー数: ${markers.length}');
    }
    return markers;
  }

  Marker _createMarker(
    MeetingRecord record,
    Person person,
    BuildContext context,
  ) {
    return Marker(
      markerId: MarkerId(record.id),
      position: LatLng(record.latitude!, record.longitude!),
      infoWindow: InfoWindow(
        title: person.name ?? S.of(context)!.nameNotRegistered,
        snippet: record.location ?? '',
        onTap: () => _navigateToEditScreen(person),
      ),
      // ピン自体のタップでは何もしない
      onTap: null,
      icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerHue(person)),
    );
  }

  double _getMarkerHue(Person person) {
    // アバターカラーに基づいてマーカーの色を決定
    final colorMap = {
      '#4D6FFF': BitmapDescriptor.hueBlue,
      '#9B72FF': BitmapDescriptor.hueViolet,
      '#FF6B9D': BitmapDescriptor.hueRose,
      '#FF6F00': BitmapDescriptor.hueOrange,
      '#00D4AA': BitmapDescriptor.hueCyan,
      '#607D8B': BitmapDescriptor.hueAzure,
    };

    return colorMap[person.avatarColor] ?? BitmapDescriptor.hueRed;
  }

  void _navigateToEditScreen(Person person) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => AddPersonProvider(person: person),
          child: AddPersonView(
            person: person,
            onSave: () {
              Navigator.pop(context);
              // データを再読み込み
              final provider = Provider.of<HomeProvider>(
                context,
                listen: false,
              );
              provider.loadData().then((_) {
                // _loadMarkers(); // Removed call
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F7),
      child: Builder(
        builder: (context) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                Expanded(child: _buildMap()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context)!.mapTitle,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            S.of(context)!.confirmLocation,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _prepareMarkers(provider, context), // ここでマーカーを生成
            onMapCreated: (controller) {
              _mapController = controller;
              _moveToCurrentUserLocation(); // マップ作成後に現在地へ移動
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: true,
          );
        },
      ),
    );
  }
}
