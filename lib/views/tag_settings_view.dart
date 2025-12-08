import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tag_settings_provider.dart';
import '../l10n/l10n.dart';

class TagSettingsView extends StatefulWidget {
  final VoidCallback? onClose;

  const TagSettingsView({super.key, this.onClose});

  @override
  State<TagSettingsView> createState() => _TagSettingsViewState();
}

class _TagSettingsViewState extends State<TagSettingsView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TagSettingsProvider()..loadData(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F7),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ヘッダー部分（タイトル + 閉じるボタン）
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    // タイトル行
                    Row(
                      children: [
                        // 左：閉じるボタン
                        IconButton(
                          onPressed: () {
                            if (widget.onClose != null) {
                              widget.onClose!();
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.close),
                        ),
                        const Spacer(),
                        // 真ん中：タイトル
                        Text(
                          S.of(context)!.tagSettings,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        // 右：追加ボタン
                        Consumer<TagSettingsProvider>(
                          builder: (context, provider, child) {
                            return IconButton(
                              icon: const Icon(Icons.add, size: 28),
                              onPressed: () =>
                                  _showAddTagDialog(context, provider),
                              tooltip: S.of(context)!.addTag,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 本文部分
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Consumer<TagSettingsProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        children: [
                          // タグ説明
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.blue[700],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      S.of(context)!.tagAbout,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '人物に付けるタグを管理できます。\n'
                                  'よく使うタグを登録しておくと、新しい記録を追加する時にタップで選べて便利です。',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),

                          // タグ一覧
                          Expanded(
                            child: provider.tags.isEmpty
                                ? _buildEmptyState(context)
                                : _buildTagList(context, provider),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            S.of(context)!.noRegisteredTags,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context)!.addFrequentTags,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildTagList(BuildContext context, TagSettingsProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: provider.tags.length,
      itemBuilder: (context, index) {
        final tag = provider.tags[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '#',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ),
            title: Text(
              tag,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${provider.getTagUsageCount(tag)}件の記録で使用',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red[400]),
              onPressed: () => _showDeleteConfirmDialog(context, provider, tag),
            ),
          ),
        );
      },
    );
  }

  void _showAddTagDialog(BuildContext context, TagSettingsProvider provider) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.addTag),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: S.of(context)!.tagPlaceholder,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          maxLength: 20,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              final tag = controller.text.trim();
              if (tag.isNotEmpty) {
                await provider.addTag(tag);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: Text(S.of(context)!.add, style: const TextStyle(color: Color(0xFF4D6FFF))),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    TagSettingsProvider provider,
    String tag,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.deleteTag),
        content: Text(S.of(context)!.deleteTagConfirmation('#$tag')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              await provider.deleteTag(tag);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Text(S.of(context)!.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
