import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import
import '../providers/my_page_provider.dart';
import 'tag_settings_view.dart';
import 'feedback_screen.dart';

class MyPageView extends StatefulWidget {
  const MyPageView({super.key});

  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _showingTagSettings = false;
  bool _showingFeedback = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    // 初期表示時にアニメーションを開始
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showTagSettings() {
    _animationController.reverse().then((_) {
      if (!mounted) return;
      setState(() {
        _showingTagSettings = true;
      });
      _animationController.forward();
    });
  }

  void _hideTagSettings() {
    _animationController.reverse().then((_) {
      if (!mounted) return;
      setState(() {
        _showingTagSettings = false;
      });
      _animationController.forward();
    });
  }

  void _showFeedback() {
    _animationController.reverse().then((_) {
      if (!mounted) return;
      setState(() {
        _showingFeedback = true;
      });
      _animationController.forward();
    });
  }

  void _hideFeedback() {
    _animationController.reverse().then((_) {
      if (!mounted) return;
      setState(() {
        _showingFeedback = false;
      });
      _animationController.forward();
    });
  }

  // URLを開く汎用関数
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    final fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1), // 下から開始
      end: Offset.zero,
    ).animate(fadeAnimation);

    return ChangeNotifierProvider(
      create: (_) => MyPageProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        body: SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: _getSelectedContent(),
          ),
        ),
      ),
    );
  }

  Widget _getSelectedContent() {
    if (_showingTagSettings) {
      return TagSettingsView(onClose: _hideTagSettings);
    }
    if (_showingFeedback) {
      return FeedbackScreen(onClose: _hideFeedback);
    }

    return Consumer<MyPageProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4D6FFF)),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // タイトル
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Text(
                    'マイページ',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // プロフィールセクション
                Center(
                  child: Column(
                    children: [
                      // アバター
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF4D6FFF), Color(0xFF9B72FF)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            provider.userProfile?.initials ?? '?',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 名前（タップで編集）
                      GestureDetector(
                        onTap: () => _showEditNameDialog(context, provider),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              provider.userProfile?.name ?? '名前を設定',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: provider.userProfile == null
                                    ? Colors.black38
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.edit,
                              size: 20,
                              color: provider.userProfile == null
                                  ? Colors.black38
                                  : Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // サブタイトル
                      Text(
                        '記憶ランク: ${provider.memoryRank}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 統計カード
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      // 覚えた人
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3EEFF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${provider.totalPersons}',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4D6FFF),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '覚えた人',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // 今月の出会い
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDE8F4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${provider.thisMonthMeetings}',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD946C4),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '今月の出会い',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // メニュー項目
                _buildMenuItem(
                  context,
                  title: 'タグ設定',
                  onTap: () {
                    _showTagSettings();
                  },
                  icon: Icons.local_offer,
                ),
                _buildMenuItem(
                  context,
                  title: 'フィードバック',
                  onTap: () {
                    _showFeedback();
                  },
                  icon: Icons.feedback,
                ),
                // _buildMenuItem(
                //   context,
                //   title: 'データのエクスポート',
                //   onTap: () {
                //     // データエクスポート機能
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text('データのエクスポートは開発中です')),
                //     );
                //   },
                //   icon: Icons.download,
                // ),
                _buildMenuItem(
                  context,
                  title: 'プライバシーポリシー',
                  onTap: () =>
                      _launchURL('https://tomople.com/privacy-policy/'),
                  icon: Icons.privacy_tip,
                ),
                _buildMenuItem(
                  context,
                  title: '利用規約',
                  onTap: () => _launchURL(
                    'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
                  ),
                  icon: Icons.description,
                ),
                const SizedBox(height: 32), // スペースを追加
                Center(
                  child: Text(
                    'バージョン: ${provider.appVersion}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ),
                const SizedBox(height: 24), // 下にスペースを追加
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: const Color(0xFF4D6FFF),
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                ] else ...[
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, MyPageProvider provider) {
    final nameController = TextEditingController(
      text: provider.userProfile?.name ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('名前の設定'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '名前',
            border: OutlineInputBorder(),
          ),
          maxLength: 20,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                await provider.updateUserProfile(name);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('保存', style: TextStyle(color: Color(0xFF4D6FFF))),
          ),
        ],
      ),
    );
  }
}
