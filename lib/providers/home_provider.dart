import 'package:flutter/foundation.dart';
import '../models/person.dart';

class HomeProvider with ChangeNotifier {
  String _searchQuery = '';
  final List<String> _suggestedTags = ['先週会った', '渋谷', 'メガネ', '営業'];
  List<Person> _recentPersons = [];

  String get searchQuery => _searchQuery;
  List<String> get suggestedTags => _suggestedTags;
  List<Person> get recentPersons => _recentPersons;

  HomeProvider() {
    _loadMockData();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void _loadMockData() {
    _recentPersons = [
      Person(
        id: '1',
        name: '佐藤 健太',
        company: 'TechFlow Inc.',
        position: 'マーケティング部長',
        tags: ['メガネ', 'ゴルフ'],
        registeredDate: DateTime(2024, 10, 15),
        avatarColor: '#6B9FFF',
        additionalInfoCount: 1,
      ),
      Person(
        id: '2',
        name: '名前忘れた… (田…',
        company: 'フリーランス',
        position: 'デザイナー',
        tags: ['金髪', 'MacBook'],
        registeredDate: DateTime(2024, 11, 2),
        avatarColor: '#D4B3FF',
        additionalInfoCount: 1,
      ),
      Person(
        id: '3',
        name: '鈴木 さくら',
        company: 'StartUp Hub',
        position: '広報',
        tags: ['ショートカット', '犬好き'],
        registeredDate: DateTime(2024, 9, 20),
        avatarColor: '#FFB3D9',
        additionalInfoCount: 1,
      ),
    ];
    notifyListeners();
  }
}
