import 'package:flutter/foundation.dart';
import '../services/person_storage.dart';

class TagSettingsProvider with ChangeNotifier {
  List<String> _tags = [];
  Map<String, int> _tagUsageCount = {};

  List<String> get tags => List.unmodifiable(_tags);

  Future<void> loadData() async {
    final persons = await PersonStorage.getAllPersons();

    // すべてのタグと使用数を収集
    final tagCounts = <String, int>{};
    for (final person in persons) {
      for (final tag in person.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }

    _tagUsageCount = tagCounts;
    _tags = tagCounts.keys.toList()
      ..sort((a, b) => _tagUsageCount[b]!.compareTo(_tagUsageCount[a]!)); // 使用数が多い順

    notifyListeners();
  }

  int getTagUsageCount(String tag) {
    return _tagUsageCount[tag] ?? 0;
  }

  Future<void> addTag(String tag) async {
    if (tag.trim().isEmpty) return;

    final trimmedTag = tag.trim();

    // 既に存在するかチェック
    if (_tags.contains(trimmedTag)) {
      return;
    }

    // 追加してソート
    _tags.add(trimmedTag);
    _tagUsageCount[trimmedTag] = 0;
    _tags.sort((a, b) => _tagUsageCount[b]!.compareTo(_tagUsageCount[a]!));

    notifyListeners();

    if (kDebugMode) {
      print('タグを追加: $trimmedTag');
    }
  }

  Future<void> deleteTag(String tag) async {
    if (!_tags.contains(tag)) return;

    // このタグが設定されているすべての人物からタグを削除
    final persons = await PersonStorage.getAllPersons();
    for (final person in persons) {
      if (person.tags.contains(tag)) {
        final updatedTags = List<String>.from(person.tags)..remove(tag);
        await PersonStorage.updatePerson(person.copyWith(tags: updatedTags));
      }
    }

    // プロバイダーから削除
    _tags.remove(tag);
    _tagUsageCount.remove(tag);

    notifyListeners();

    if (kDebugMode) {
      print('タグを削除: $tag');
    }
  }
}