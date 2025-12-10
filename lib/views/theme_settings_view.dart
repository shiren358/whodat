import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../l10n/l10n.dart';

class ThemeSettingsView extends StatefulWidget {
  final VoidCallback? onClose;

  const ThemeSettingsView({super.key, required this.onClose});

  @override
  State<ThemeSettingsView> createState() => _ThemeSettingsViewState();
}

class _ThemeSettingsViewState extends State<ThemeSettingsView>
    with TickerProviderStateMixin {
  // 色の名前マッピング
  String _getColorName(Color color) {
    final colorMap = {
      0xFF4D6FFF: 'Clear Blue',
      0xFF2196F3: 'Ocean',
      0xFF3F51B5: 'Indigo',
      0xFF5C6BC0: 'Lavender',
      0xFFFF7043: 'Coral',
      0xFFFFA726: 'Sunset',
      0xFF66BB6A: 'Forest',
      0xFF26A69A: 'Teal',
      0xFF9CCC65: 'Lime',
      0xFF42A5F5: 'Sky',
      0xFFAB47BC: 'Purple',
      0xFFEC407A: 'Rose',
      0xFFFF6B9D: 'Pink',
      0xFF8D6E63: 'Mocha',
      0xFF607D8B: 'Slate',
      0xFF78909C: 'Steel',
    };
    return colorMap[color.toARGB32()] ?? 'Custom';
  }

  @override
  void initState() {
    super.initState();
  }

  Color _getGradientEndColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withHue((hsl.hue + 30) % 360)
        .withSaturation((hsl.saturation * 0.8).clamp(0.0, 1.0))
        .withLightness((hsl.lightness * 0.85).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          widget.onClose?.call();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            S.of(context)!.themeSettings,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black87,
                size: 18,
              ),
            ),
            onPressed: () {
              widget.onClose?.call();
            },
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 24),
            // プレビューカード
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return _buildPreviewCard(themeProvider);
                },
              ),
            ),
            const SizedBox(height: 32),
            // セクションタイトル
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    S.of(context)!.selectThemeColor,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // カラーグリッド
            Expanded(
              child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return _buildColorGrid(themeProvider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard(ThemeProvider themeProvider) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: themeProvider.themeColor.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // グラデーション背景
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeProvider.themeColor,
                    themeProvider.getGradientEndColor(),
                  ],
                ),
              ),
            ),
            // 装飾パターン
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              right: 40,
              bottom: -50,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            // コンテンツ
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          S.of(context)!.themePreview,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getColorName(themeProvider.themeColor),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '#${themeProvider.themeColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorGrid(ThemeProvider themeProvider) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: themeProvider.presetColors.length,
      itemBuilder: (context, index) {
        final color = themeProvider.presetColors[index];
        final isSelected = themeProvider.themeColor == color;

        return GestureDetector(
          onTap: () async {
            await themeProvider.setThemeColor(color);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? color.withValues(alpha: 0.4)
                      : Colors.black.withValues(alpha: 0.08),
                  blurRadius: isSelected ? 12 : 8,
                  spreadRadius: isSelected ? 1 : 0,
                  offset: Offset(0, isSelected ? 4 : 2),
                ),
              ],
            ),
            child: AnimatedScale(
              scale: isSelected ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, _getGradientEndColor(color)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                ),
                child: Stack(
                  children: [
                    // 装飾
                    Positioned(
                      right: -10,
                      top: -10,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    // チェックマーク
                    if (isSelected)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: color,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
