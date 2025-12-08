import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/map_location_provider.dart';
import '../l10n/l10n.dart';

class MapLocationSelectionView extends StatefulWidget {
  final String initialLocation;
  final double? initialLatitude;
  final double? initialLongitude;

  const MapLocationSelectionView({
    super.key,
    required this.initialLocation,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<MapLocationSelectionView> createState() =>
      _MapLocationSelectionViewState();
}

class _MapLocationSelectionViewState extends State<MapLocationSelectionView> {
  bool _isInitialized = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _provider?.removeListener(_onProviderChanged);
    super.dispose();
  }

  MapLocationProvider? _provider;

  void _onProviderChanged() {
    if (_provider != null &&
        _textEditingController.text != _provider!.locationName) {
      _textEditingController.text = _provider!.locationName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MapLocationProvider(),
      child: Builder(
        builder: (context) {
          // 初期化は一度だけ実行
          if (!_isInitialized) {
            _isInitialized = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final provider = Provider.of<MapLocationProvider>(
                context,
                listen: false,
              );
              provider.initializeMap(
                initialLatitude: widget.initialLatitude,
                initialLongitude: widget.initialLongitude,
              );

              // ControllerとProviderの状態を同期
              _textEditingController.text = provider.locationName;
            });

            // ProviderのlocationName変更を監視してControllerを更新
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final provider = Provider.of<MapLocationProvider>(
                context,
                listen: false,
              );
              _provider = provider;
              provider.addListener(_onProviderChanged);
            });
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F7),
            appBar: AppBar(
              title: Text(
                S.of(context)!.selectLocationOnMap,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                // 現在地ボタン
                Consumer<MapLocationProvider>(
                  builder: (context, provider, child) {
                    return IconButton(
                      icon: const Icon(
                        Icons.my_location,
                        color: Color(0xFF4CAF50),
                      ),
                      onPressed: () async {
                      final location = await provider.getCurrentLocation();
                      if (location != null) {
                        provider.moveToLocation(location);
                      }
                    },
                    );
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // 場所名表示
                  Consumer<MapLocationProvider>(
                    builder: (context, provider, child) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context)!.selectedLocation,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              provider.locationName.isEmpty
                                  ? S.of(context)!.tapToSelectLocation
                                  : provider.locationName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // 地図
                  Expanded(
                    child: Consumer<MapLocationProvider>(
                      builder: (context, provider, child) {
                        return provider.isLoading ||
                                provider.selectedLocation == null
                            ? const Center(child: CircularProgressIndicator())
                            : Stack(
                                children: [
                                  GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: provider.selectedLocation!,
                                      zoom: 15,
                                    ),
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                          provider.setMapController(controller);
                                        },
                                    onTap: provider.onMapTapped,
                                    markers: provider.markers,
                                    myLocationEnabled: true,
                                    myLocationButtonEnabled: false, // 独自ボタンを使用
                                    zoomControlsEnabled:
                                        false, // 独自ズームコントロールを使用
                                    mapType: MapType.normal,
                                  ),
                                  // ズームコントロールボタン
                                  Positioned(
                                    right: 16,
                                    bottom: 100,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.add,
                                                  color: Color(0xFF333333),
                                                ),
                                                onPressed: () {
                                                  provider.mapController
                                                      ?.animateCamera(
                                                        CameraUpdate.zoomIn(),
                                                      );
                                                },
                                              ),
                                              Container(
                                                height: 1,
                                                width: 40,
                                                color: const Color(0xFFE0E0E0),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.remove,
                                                  color: Color(0xFF333333),
                                                ),
                                                onPressed: () {
                                                  provider.mapController
                                                      ?.animateCamera(
                                                        CameraUpdate.zoomOut(),
                                                      );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
                  ),

                  // 操作パネル
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      children: [
                        // 場所名入力
                        Selector<MapLocationProvider, String>(
                          selector: (context, provider) =>
                              provider.locationName,
                          builder: (context, locationName, child) {
                            return TextField(
                              onChanged: (value) {
                                Provider.of<MapLocationProvider>(
                                  context,
                                  listen: false,
                                ).updateLocationName(value);
                              },
                              decoration: InputDecoration(
                                hintText: S.of(context)!.locationNamePlaceholder,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF4CAF50),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              style: const TextStyle(fontSize: 16),
                              controller: _textEditingController,
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        // ボタン
                        Selector<MapLocationProvider, bool>(
                          selector: (context, provider) =>
                              provider.selectedLocation != null &&
                              provider.locationName.trim().isNotEmpty,
                          builder: (context, canSave, child) {
                            return Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      side: const BorderSide(
                                        color: Color(0xFFE0E0E0),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      S.of(context)!.cancel,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF666666),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: canSave
                                        ? () {
                                            final provider =
                                                Provider.of<
                                                  MapLocationProvider
                                                >(context, listen: false);
                                            final result = provider
                                                .confirmSelection();
                                            if (result != null) {
                                              Navigator.of(context).pop(result);
                                            }
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4CAF50),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      S.of(context)!.confirm,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
