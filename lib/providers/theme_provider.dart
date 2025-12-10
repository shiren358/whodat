import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeColorKey = 'theme_color';
  static const _storage = FlutterSecureStorage();

  // 全人口向けのカラーパレット
  final List<Color> _presetColors = [
    // プロフェッショナル系
    Color(0xFF4D6FFF), // クリアブルー
    Color(0xFF2196F3), // ブルー
    Color(0xFF3F51B5), // インディゴ
    Color(0xFF5C6BC0), // ライトインディゴ
    // 明るいカラー系
    Color(0xFFFF7043), // コーラルオレンジ
    Color(0xFFFFA726), // アンバー
    Color(0xFF66BB6A), // グリーン
    Color(0xFF26A69A), // ティール
    // 優しい色合い
    Color(0xFF9CCC65), // ライトグリーン
    Color(0xFF42A5F5), // ライトブルー
    Color(0xFFAB47BC), // パープル
    Color(0xFFEC407A), // ライトピンク
    // 可愛いピンク系（デフォルト）
    Color(0xFFFF6B9D), // コーラルピンク
    // モダンな色
    Color(0xFF8D6E63), // ブラウン
    Color(0xFF607D8B), // ブルーグレー
    Color(0xFF78909C), // ブルーグレーライト
  ];

  Color _themeColor = Color(0xFFFF6B9D); // デフォルトは可愛いコーラルピンク

  Color get themeColor => _themeColor;
  List<Color> get presetColors => _presetColors;

  // グラデーション用の2色目を生成
  Color getGradientEndColor() {
    // テーマカラーに応じて相性の良い2色目を返す
    if (_themeColor.value == 0xFFFF6B9D) {
      // コーラルピンク
      return const Color(0xFFE91E63); // ピンク
    } else if (_themeColor.value == 0xFF4D6FFF ||
        _themeColor.value == 0xFF2196F3) {
      // ブルー系
      return const Color(0xFF9B72FF); // パープル
    } else if (_themeColor.value == 0xFF3F51B5) {
      // インディゴ
      return const Color(0xFF5C6BC0); // ライトインディゴ
    } else if (_themeColor.value == 0xFFFF7043 ||
        _themeColor.value == 0xFFFFA726) {
      // オレンジ系
      return const Color(0xFF9B72FF); // パープル
    } else if (_themeColor.value == 0xFF66BB6A ||
        _themeColor.value == 0xFF26A69A) {
      // グリーン系
      return const Color(0xFF42A5F5); // ライトブルー
    } else if (_themeColor.value == 0xFF9CCC65) {
      // ライトグリーン
      return const Color(0xFF42A5F5); // ライトブルー
    } else if (_themeColor.value == 0xFF42A5F5) {
      // ライトブルー
      return const Color(0xFF9B72FF); // パープル
    } else if (_themeColor.value == 0xFFAB47BC ||
        _themeColor.value == 0xFFEC407A) {
      // パープル系
      return const Color(0xFF4D6FFF); // クリアブルー
    } else {
      // その他
      return const Color(0xFF9B72FF); // パープル
    }
  }

  Future<void> loadThemeColor() async {
    try {
      final savedColor = await _storage.read(key: _themeColorKey);
      if (savedColor != null) {
        _themeColor = Color(int.parse(savedColor, radix: 16));
        notifyListeners();
      }
    } catch (e) {
      // 読み込みエラーの場合はデフォルトカラーを使用
      debugPrint('Failed to load theme color: $e');
    }
  }

  Future<void> setThemeColor(Color color) async {
    _themeColor = color;
    try {
      await _storage.write(
        key: _themeColorKey,
        value: color.value.toRadixString(16),
      );
    } catch (e) {
      // 保存エラーの場合も通知は行う
      debugPrint('Failed to save theme color: $e');
    }
    notifyListeners();
  }

  // カラーに基づいてテーマを生成
  ThemeData getThemeData(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _themeColor,
        brightness: Brightness.light,
      ),
      primaryColor: _themeColor,
      useMaterial3: true,
    );
  }

  Color _lightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}
