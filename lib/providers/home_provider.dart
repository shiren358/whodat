import 'package:flutter/foundation.dart';
import '../models/person.dart';
import '../services/person_storage.dart';

class HomeProvider with ChangeNotifier {
  String _searchQuery = '';
  final List<String> _suggestedTags = ['先週会った', '渋谷', 'メガネ', '営業'];
  List<Person> _recentPersons = [];

  String get searchQuery => _searchQuery;
  List<String> get suggestedTags => _suggestedTags;
  List<Person> get recentPersons => _recentPersons;

  HomeProvider() {
    loadPersons();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadPersons() async {
    _recentPersons = await PersonStorage.getAllPersons();
    // 登録日の新しい順にソート
    _recentPersons.sort((a, b) => b.registeredDate.compareTo(a.registeredDate));
    notifyListeners();
  }
}
