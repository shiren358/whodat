import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../models/meeting_record.dart';
import '../models/person.dart';
import 'add_person_view.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  // 日本の中心（東京付近）
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(35.6812, 139.7671), // 東京駅
    zoom: 10.0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMarkers();
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _loadMarkers() {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    final records = provider.recentMeetingRecords;

    final markers = <Marker>{};

    for (final record in records) {
      // 緯度経度が設定されている記録のみマーカーを作成
      if (record.latitude != null && record.longitude != null) {
        final person = provider.getPersonForRecord(record);
        if (person != null) {
          markers.add(_createMarker(record, person));
        }
      }
    }

    setState(() {
      _markers.clear();
      _markers.addAll(markers);
    });
  }

  Marker _createMarker(MeetingRecord record, Person person) {
    return Marker(
      markerId: MarkerId(record.id),
      position: LatLng(record.latitude!, record.longitude!),
      infoWindow: InfoWindow(
        title: person.name ?? '名前未登録',
        snippet: record.location ?? '',
      ),
      onTap: () => _onMarkerTapped(person),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        _getMarkerHue(person),
      ),
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

  void _onMarkerTapped(Person person) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPersonView(
          person: person,
          onSave: () {
            Navigator.pop(context);
            // データを再読み込み
            final provider = Provider.of<HomeProvider>(context, listen: false);
            provider.loadData().then((_) {
              _loadMarkers();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F7),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: _buildMap(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'マップ',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'どこで会ったかを確認する',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
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
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
              _loadMarkers();
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
