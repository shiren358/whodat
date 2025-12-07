import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/my_page_provider.dart';

class MyPageView extends StatelessWidget {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyPageProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        body: Consumer<MyPageProvider>(
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
                        // TODO: タグ設定画面に遷移
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('タグ設定は開発中です')),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      title: 'データのエクスポート',
                      onTap: () {
                        // TODO: データエクスポート機能
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('データのエクスポートは開発中です')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
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
            hintText: '例: 山田太郎',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              provider.updateUserProfile(value.trim());
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                provider.updateUserProfile(name);
                Navigator.pop(context);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.black38,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
