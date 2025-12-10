import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../l10n/l10n.dart';

class AppStoryView extends StatefulWidget {
  const AppStoryView({super.key});

  @override
  State<AppStoryView> createState() => _AppStoryViewState();
}

class _AppStoryViewState extends State<AppStoryView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          S.of(context)!.whodatStory,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ヒーローセクション
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeProvider.themeColor,
                            themeProvider.getGradientEndColor(),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.lightbulb,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            S.of(context)!.whoWasThatPerson,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            S.of(context)!.haveYouEver,
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // 問題提起
                _buildStorySection(
                  title: S.of(context)!.storyTitle,
                  icon: Icons.help_outline,
                  color: Colors.orange,
                  children: [
                    _buildStoryText(S.of(context)!.businessMeetings),
                    _buildStoryText(S.of(context)!.morePeopleBut),
                    _buildStoryText(S.of(context)!.forgetNames),
                    _buildStoryText(S.of(context)!.worriedAboutForgetting, isHighlight: true),
                  ],
                ),

                const SizedBox(height: 32),

                // 解決策
                _buildStorySection(
                  title: S.of(context)!.storySolution,
                  icon: Icons.psychology,
                  color: Colors.green,
                  children: [
                    _buildStoryText(S.of(context)!.forgettingIsNatural),
                    _buildStoryText(S.of(context)!.dontNeedToBePerfect),
                    _buildStoryText(S.of(context)!.littleRecords),
                    _buildStoryText(S.of(context)!.enrichNextEncounters, isHighlight: true),
                  ],
                ),

                const SizedBox(height: 32),

                // このアプリの価値
                _buildStorySection(
                  title: S.of(context)!.whodatFeatures,
                  icon: Icons.star,
                  color: Colors.purple,
                  children: [
                    _buildStoryText(S.of(context)!.recordNameAndFace),
                    _buildStoryText(S.of(context)!.rememberPlaceAndTime),
                    _buildStoryText(S.of(context)!.saveFeaturesAndMemo),
                    _buildStoryText(S.of(context)!.manageWithColors),
                    _buildStoryText(S.of(context)!.checkRememberedPeople),
                  ],
                ),

                const SizedBox(height: 32),

                // ミッション
                _buildStorySection(
                  title: S.of(context)!.missionTitle,
                  icon: Icons.favorite,
                  color: Colors.red,
                  children: [
                    _buildStoryText(S.of(context)!.turnMeetingsToAssets),
                    _buildStoryText(S.of(context)!.worldEasyToRemember),
                    _buildStoryText(S.of(context)!.createSuchWorld, isHighlight: true),
                  ],
                ),

                const SizedBox(height: 32),

                // 締め
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.waving_hand,
                        size: 48,
                        color: Color(0xFF4D6FFF),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context)!.save,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        S.of(context)!.appTitle,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 開発者からのメッセージ
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context)!.feature5,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        S.of(context)!.developerNote,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStorySection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildStoryText(String text, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          height: 1.6,
          color: isHighlight ? const Color(0xFF4D6FFF) : Colors.black87,
          fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
