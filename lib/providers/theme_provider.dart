import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeColorKey = 'theme_color';
  static const _storage = FlutterSecureStorage();

  // 全人口向けのカラーパレット
  final List<Color> _presetColors = [
    // 可愛いピンク系（デフォルト）
    Color(0xFFFF6B9D), // コーラルピンク
    // デフォルト（アイコンに合わせた紫色）
    Color(0xFF8B5CF6), // バイオレット（新しいデフォルト）
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
    // モダンな色
    Color(0xFF8D6E63), // ブラウン
    Color(0xFF607D8B), // ブルーグレー
    Color(0xFF78909C), // ブルーグレーライト
  ];

  Color _themeColor = Color(0xFF8B5CF6); // デフォルトはバイオレット（アイコンに合わせた）

  Color get themeColor => _themeColor;
  List<Color> get presetColors => _presetColors;

  // グラデーション用の2色目を生成
  Color getGradientEndColor() {
    // テーマカラーに応じて相性の良い2色目を返す（調整済みのグラデーション）
    if (_themeColor.toARGB32() == 0xFF8B5CF6) {
      // バイオレット（デフォルト）-> 薄いバイオレット
      return const Color(0xFFE1C4FF); // 薄い紫
    } else if (_themeColor.toARGB32() == 0xFFFF6B9D) {
      // コーラルピンク -> 薄いピンク
      return const Color(0xFFFFCDD8); // 薄いピンク
    } else if (_themeColor.toARGB32() == 0xFF4D6FFF ||
        _themeColor.toARGB32() == 0xFF2196F3) {
      // ブルー系 -> 薄いブルー
      return const Color(0xFFD4E4FF); // 薄い青
    } else if (_themeColor.toARGB32() == 0xFF3F51B5) {
      // インディゴ -> 薄いインディゴ
      return const Color(0xFFDDE1F0); // 薄いインディゴ
    } else if (_themeColor.toARGB32() == 0xFFFF7043 ||
        _themeColor.toARGB32() == 0xFFFFA726) {
      // オレンジ系 -> 薄いオレンジ
      return const Color(0xFFFFE0DB); // 薄いオレンジ
    } else if (_themeColor.toARGB32() == 0xFF66BB6A ||
        _themeColor.toARGB32() == 0xFF26A69A) {
      // グリーン系 -> 薄いグリーン
      return const Color(0xFFD4F1D4); // 薄い緑
    } else if (_themeColor.toARGB32() == 0xFF9CCC65) {
      // ライトグリーン -> 薄いライムグリーン
      return const Color(0xFFE8F5D9); // 薄い黄緑
    } else if (_themeColor.toARGB32() == 0xFF42A5F5) {
      // ライトブルー -> 薄いライトブルー
      return const Color(0xFFD2EDFF); // 薄い水色
    } else if (_themeColor.toARGB32() == 0xFFAB47BC ||
        _themeColor.toARGB32() == 0xFFEC407A) {
      // パープル系 -> 薄いパープル
      return const Color(0xFFF8D4E2); // 薄い紫ピンク
    } else {
      // その他 -> 薄いグレー
      return const Color(0xFFEFEFEF); // 薄いグレー
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
        value: color.toARGB32().toRadixString(16),
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
}
