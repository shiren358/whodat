import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/person.dart';
import '../models/meeting_record.dart';
import '../services/person_storage.dart';
import '../services/meeting_record_storage.dart';
import '../services/location_service.dart';

/// 会った記録の入力データを管理するクラス
class MeetingRecordInput {
  String id;
  DateTime? date;
  TextEditingController locationController;
  TextEditingController notesController;
  double? latitude;
  double? longitude;
  LocationType? locationType;

  MeetingRecordInput({
    String? id,
    this.date,
    String? location,
    String? notes,
    this.latitude,
    this.longitude,
    this.locationType,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       locationController = TextEditingController(text: location ?? ''),
       notesController = TextEditingController(text: notes ?? '');

  void dispose() {
    locationController.dispose();
    notesController.dispose();
  }
}

/// AddPersonView のビジネスロジックを管理するProvider
class AddPersonProvider with ChangeNotifier {
  // ===== プライベート状態フィールド =====

  // モード追跡
  Person? _existingPerson;
  MeetingRecord? _existingMeetingRecord;
  bool _isEditingPerson = false;
  bool _isEditingRecord = false;

  // Person データ
  String _name = '';
  String _company = '';
  String _position = '';
  File? _selectedImage;
  final List<String> _tags = [];
  int _selectedColorIndex = 0;

  // タグ管理
  List<String> _suggestedTags = [];

  // 会った記録
  final List<MeetingRecordInput> _meetingRecords = [];
  int? _newlyAddedIndex;

  // アバター色（定数）
  final List<String> _avatarColors = [
    '#4D6FFF',
    '#9B72FF',
    '#FF6B9D',
    '#FF6F00',
    '#00D4AA',
    '#607D8B',
  ];

  // ===== パブリックゲッター =====

  String get name => _name;
  String get company => _company;
  String get position => _position;
  File? get selectedImage => _selectedImage;
  List<String> get tags => List.unmodifiable(_tags);
  List<String> get suggestedTags => List.unmodifiable(_suggestedTags);
  List<MeetingRecordInput> get meetingRecords =>
      List.unmodifiable(_meetingRecords);
  int get selectedColorIndex => _selectedColorIndex;
  int? get newlyAddedIndex => _newlyAddedIndex;
  List<String> get avatarColors => List.unmodifiable(_avatarColors);
  bool get isEditingPerson => _isEditingPerson;
  bool get isEditingRecord => _isEditingRecord;

  // ===== コンストラクタと初期化 =====

  AddPersonProvider({Person? person, MeetingRecord? meetingRecord}) {
    _initializeMode(person, meetingRecord);
  }

  // 初期化完了を待つFuture
  Future<void> get initializationFuture => _initializationFuture;

  late Future<void> _initializationFuture;

  // ===== 初期化メソッド =====

  Future<void> _initializeMode(
    Person? person,
    MeetingRecord? meetingRecord,
  ) async {
    _initializationFuture = _performInitialization(person, meetingRecord);
  }

  Future<void> _performInitialization(
    Person? person,
    MeetingRecord? meetingRecord,
  ) async {
    _existingPerson = person;
    _existingMeetingRecord = meetingRecord;
    _isEditingPerson = person != null;
    _isEditingRecord = meetingRecord != null;

    // デバッグログ
    if (kDebugMode) {
      print('AddPersonProvider: _initializeMode');
      print('  _isEditingPerson: $_isEditingPerson');
      print('  _isEditingRecord: $_isEditingRecord');
      print('  person.name: ${person?.name}');
    }

    // 提案タグを読み込み
    await _loadSuggestedTags();

    // Personデータを読み込む
    if (person != null) {
      _initializePersonData(person);
      await _loadMeetingRecordsForPerson(person.id);
    } else if (meetingRecord != null) {
      _initializeSingleMeetingRecord(meetingRecord);
    } else {
      _meetingRecords.add(MeetingRecordInput());
    }

    // デバッグログ
    if (kDebugMode) {
      print('  meetingRecords数: ${_meetingRecords.length}');
      print('  name: $_name');
      print('  company: $_company');
      print('  position: $_position');
    }

    notifyListeners();
  }

  void _initializePersonData(Person person) {
    _name = person.name ?? '';
    _company = person.company ?? '';
    _position = person.position ?? '';
    _tags.addAll(person.tags);

    if (person.photoPath != null) {
      _selectedImage = File(person.photoPath!);
    }

    final colorIndex = _avatarColors.indexOf(person.avatarColor);
    if (colorIndex != -1) {
      _selectedColorIndex = colorIndex;
    }
  }

  void _initializeSingleMeetingRecord(MeetingRecord record) {
    _meetingRecords.add(
      MeetingRecordInput(
        id: record.id,
        date: record.meetingDate,
        location: record.location,
        notes: record.notes,
        latitude: record.latitude,
        longitude: record.longitude,
        locationType: LocationType.manual, // 既存データは手動入力として扱う
      ),
    );
  }

  // ===== データロードメソッド =====

  Future<void> _loadSuggestedTags() async {
    final persons = await PersonStorage.getAllPersons();
    final tagCounts = <String, int>{};

    for (final person in persons) {
      for (final tag in person.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }

    // 使用回数でソートして上位を取得
    final sortedTags = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    _suggestedTags = sortedTags.take(10).map((e) => e.key).toList();
  }

  Future<void> _loadMeetingRecordsForPerson(String personId) async {
    final records = await MeetingRecordStorage.getMeetingRecordsByPersonId(
      personId,
    );

    // 日付順にソート（新しい順）
    records.sort((a, b) {
      if (a.meetingDate == null && b.meetingDate == null) return 0;
      if (a.meetingDate == null) return 1;
      if (b.meetingDate == null) return -1;
      return b.meetingDate!.compareTo(a.meetingDate!);
    });

    _meetingRecords.clear();
    for (final record in records) {
      _meetingRecords.add(
        MeetingRecordInput(
          id: record.id,
          date: record.meetingDate,
          location: record.location,
          notes: record.notes,
          latitude: record.latitude,
          longitude: record.longitude,
          locationType: LocationType.manual, // 既存データは手動入力として扱う
        ),
      );
    }

    // 記録が1つもない場合は、1つ追加
    if (_meetingRecords.isEmpty) {
      _meetingRecords.add(MeetingRecordInput());
    }
  }

  // ===== 状態更新メソッド =====

  void updateName(String value) {
    _name = value;
    notifyListeners();
  }

  void updateCompany(String value) {
    _company = value;
    notifyListeners();
  }

  void updatePosition(String value) {
    _position = value;
    notifyListeners();
  }

  void setSelectedImage(File? image) {
    _selectedImage = image;
    notifyListeners();
  }

  void removeImage() {
    _selectedImage = null;
    notifyListeners();
  }

  void selectColor(int index) {
    _selectedColorIndex = index;
    notifyListeners();
  }

  // ===== タグ管理メソッド =====

  bool handleTagInput(String input) {
    // スペースが入力されたらタグを追加
    if (input.endsWith(' ')) {
      final tag = input.trim();
      if (tag.isNotEmpty && !_tags.contains(tag)) {
        _tags.add(tag);
        notifyListeners();
        return true; // TextFieldをクリアすべき
      }
    }
    return false;
  }

  void addSuggestedTag(String tag) {
    if (!_tags.contains(tag)) {
      _tags.add(tag);
      notifyListeners();
    }
  }

  void removeTag(String tag) {
    _tags.remove(tag);
    notifyListeners();
  }

  // ===== 会った記録管理メソッド =====

  void addMeetingRecord() {
    final newRecord = MeetingRecordInput();
    _meetingRecords.add(newRecord);
    _newlyAddedIndex = _meetingRecords.length - 1;

    // デバッグログ
    if (kDebugMode) {
      print('addMeetingRecord: 新規レコードID=${newRecord.id}, 総数=${_meetingRecords.length}');
    }

    notifyListeners();

    // アニメーション完了後にリセット
    Future.delayed(const Duration(milliseconds: 500), () {
      _newlyAddedIndex = null;
      notifyListeners();
    });
  }

  void removeMeetingRecord(int index) {
    if (_meetingRecords.length > 1) {
      _meetingRecords[index].dispose();
      _meetingRecords.removeAt(index);
      notifyListeners();
    }
  }

  void updateMeetingDate(int index, DateTime? date) {
    _meetingRecords[index].date = date;
    notifyListeners();
  }

  void updateMeetingLocation(
    int index,
    double? lat,
    double? lng,
    String? locationName,
    LocationType? locationType,
  ) {
    _meetingRecords[index].latitude = lat;
    _meetingRecords[index].longitude = lng;
    _meetingRecords[index].locationType = locationType;
    if (locationName != null) {
      _meetingRecords[index].locationController.text = locationName;
    }
    notifyListeners();
  }

  void updateMeetingLocationWithCoordinates(
    int index,
    String locationName,
    double? latitude,
    double? longitude,
    LocationType locationType,
  ) {
    // デバッグログ
    if (kDebugMode) {
      print('Provider: updateMeetingLocationWithCoordinates');
      print('  index: $index');
      print('  locationName: $locationName');
      print('  latitude: $latitude');
      print('  longitude: $longitude');
      print('  locationType: $locationType');
      print('  更新前のlat: ${_meetingRecords[index].latitude}');
      print('  更新前のlng: ${_meetingRecords[index].longitude}');
    }

    _meetingRecords[index].latitude = latitude;
    _meetingRecords[index].longitude = longitude;
    _meetingRecords[index].locationType = locationType;
    _meetingRecords[index].locationController.text = locationName;

    // デバッグログ
    if (kDebugMode) {
      print('  更新後のlat: ${_meetingRecords[index].latitude}');
      print('  更新後のlng: ${_meetingRecords[index].longitude}');
    }

    notifyListeners();
  }

  // recordのIDで直接更新するメソッド
  void updateMeetingLocationById(
    String recordId,
    String locationName,
    double? latitude,
    double? longitude,
    LocationType locationType,
  ) {
    // デバッグログ：現在のレコード一覧を表示
    if (kDebugMode) {
      print('Provider: 現在のレコード一覧 (${_meetingRecords.length}件):');
      for (int i = 0; i < _meetingRecords.length; i++) {
        print('  [$i] ID: ${_meetingRecords[i].id}, 場所: ${_meetingRecords[i].locationController.text}');
      }
      print('Provider: 検索対象ID: $recordId');
    }

    final index = _meetingRecords.indexWhere((record) => record.id == recordId);

    if (index != -1) {
      // デバッグログ
      if (kDebugMode) {
        print('Provider: updateMeetingLocationById');
        print('  recordId: $recordId');
        print('  index: $index');
        print('  locationName: $locationName');
        print('  latitude: $latitude');
        print('  longitude: $longitude');
        print('  locationType: $locationType');
        print('  更新前のlat: ${_meetingRecords[index].latitude}');
        print('  更新前のlng: ${_meetingRecords[index].longitude}');
      }

      _meetingRecords[index].latitude = latitude;
      _meetingRecords[index].longitude = longitude;
      _meetingRecords[index].locationType = locationType;
      _meetingRecords[index].locationController.text = locationName;

      // デバッグログ
      if (kDebugMode) {
        print('  更新後のlat: ${_meetingRecords[index].latitude}');
        print('  更新後のlng: ${_meetingRecords[index].longitude}');
      }

      notifyListeners();
    } else {
      if (kDebugMode) {
        print('Provider: recordId $recordId が見つかりません');
      }
    }
  }

  void clearMeetingLocation(int index) {
    _meetingRecords[index].latitude = null;
    _meetingRecords[index].longitude = null;
    _meetingRecords[index].locationType = null;
    _meetingRecords[index].locationController.clear();
    notifyListeners();
  }

  // ===== 保存メソッド =====

  Future<bool> save() async {
    try {
      // Personオブジェクトを作成または更新
      final person = Person(
        id: _isEditingPerson
            ? _existingPerson!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name.trim().isEmpty ? null : _name.trim(),
        company: _company.trim().isEmpty ? null : _company.trim(),
        position: _position.trim().isEmpty ? null : _position.trim(),
        tags: _tags,
        avatarColor: _avatarColors[_selectedColorIndex],
        photoPath: _selectedImage?.path,
      );

      if (_isEditingPerson) {
        await PersonStorage.updatePerson(person);
      } else {
        await PersonStorage.savePerson(person);
      }

      // 全てのMeetingRecordを保存または更新
      for (final recordInput in _meetingRecords) {
        final meetingRecord = MeetingRecord(
          id: recordInput.id,
          personId: person.id,
          meetingDate: recordInput.date,
          location: recordInput.locationController.text.trim().isEmpty
              ? null
              : recordInput.locationController.text.trim(),
          notes: recordInput.notesController.text.trim().isEmpty
              ? null
              : recordInput.notesController.text.trim(),
          latitude: recordInput.latitude,
          longitude: recordInput.longitude,
        );

        // デバッグログ
        if (kDebugMode) {
          print('保存するMeetingRecord: ${meetingRecord.toJson()}');
          print('LocationType: ${recordInput.locationType}');
        }

        // 既存のMeetingRecordを編集している場合
        if (_isEditingRecord && recordInput.id == _existingMeetingRecord!.id) {
          await MeetingRecordStorage.updateMeetingRecord(meetingRecord);
        } else {
          // 新規作成の場合（既存のIDがあっても新規として保存）
          final existingRecord =
              await MeetingRecordStorage.getMeetingRecordById(recordInput.id);
          if (existingRecord != null) {
            await MeetingRecordStorage.updateMeetingRecord(meetingRecord);
          } else {
            await MeetingRecordStorage.saveMeetingRecord(meetingRecord);
          }
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // ===== クリーンアップ =====

  @override
  void dispose() {
    for (final record in _meetingRecords) {
      record.dispose();
    }
    super.dispose();
  }
}
