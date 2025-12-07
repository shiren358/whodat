import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../views/location_selection_view.dart';

class LocationInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final double? latitude;
  final double? longitude;
  final LocationType? locationType;
  final Function(String location, double? latitude, double? longitude, LocationType type)?
      onLocationChanged;

  const LocationInputWidget({
    super.key,
    required this.controller,
    this.hintText = '場所',
    this.onChanged,
    this.latitude,
    this.longitude,
    this.locationType,
    this.onLocationChanged,
  });

  @override
  State<LocationInputWidget> createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 場所アイコン
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Color(0xFFFFF9E6),
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              const Center(
                child: Icon(
                  Icons.location_on,
                  color: Color(0xFFFFC107),
                  size: 24,
                ),
              ),
              // 位置情報種別インジケーター
              if (widget.locationType != null)
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getLocationTypeColor(widget.locationType!),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // 入力フィールド
        Expanded(
          child: GestureDetector(
            onTap: _showLocationSelection,
            child: AbsorbPointer(
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  // 右端に選択インジケーターを表示
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ),
                style: const TextStyle(fontSize: 16),
                textAlignVertical: TextAlignVertical.center,
                onChanged: widget.onChanged,
                readOnly: true, // タップでモーダルを開くので読み取り専用
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 位置情報選択画面を表示
  void _showLocationSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationSelectionView(
        initialLocation: widget.controller.text,
        onLocationSelected: (
          String location,
          double? latitude,
          double? longitude,
          LocationType type,
        ) {
          // コントローラーを更新
          widget.controller.text = location;

          // コールバックを呼び出し
          widget.onLocationChanged?.call(location, latitude, longitude, type);
          widget.onChanged?.call(location);

          // 状態を更新してUIを再描画
          setState(() {});
        },
      ),
    );
  }

  // 位置情報種別に応じた色を取得
  Color _getLocationTypeColor(LocationType type) {
    switch (type) {
      case LocationType.map:
        return const Color(0xFF4CAF50); // 緑
      case LocationType.gps:
        return const Color(0xFF2196F3); // 青
      case LocationType.manual:
        return const Color(0xFF757575); // グレー
    }
  }
}