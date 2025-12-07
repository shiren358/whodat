import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/person.dart';
import '../models/meeting_record.dart';
import '../providers/add_person_provider.dart';
import '../widgets/location_input_widget.dart';
import '../services/location_service.dart';

class AddPersonView extends StatefulWidget {
  final VoidCallback? onSave;
  final VoidCallback? onCancel; // キャンセル時のコールバック
  final Person? person; // 編集時の既存Person
  final MeetingRecord? meetingRecord; // 編集時の既存MeetingRecord

  const AddPersonView({
    super.key,
    this.onSave,
    this.onCancel,
    this.person,
    this.meetingRecord,
  });

  @override
  State<AddPersonView> createState() => _AddPersonViewState();
}

class _AddPersonViewState extends State<AddPersonView> {
  // TextEditingControllers (View層で管理)
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _tagInputController = TextEditingController();

  // UIユーティリティ
  final ImagePicker _picker = ImagePicker();

  // Provider
  late AddPersonProvider _provider;
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();

    // デバッグログ
    if (kDebugMode) {
      print(
        'AddPersonView: 初期化 - person=${widget.person?.name ?? 'null'}, personId=${widget.person?.id ?? 'null'}',
      );
    }

    // Provider作成（3つのモードに対応）
    _provider = AddPersonProvider(
      person: widget.person,
      meetingRecord: widget.meetingRecord,
    );

    // デバッグログ
    if (kDebugMode) {
      print(
        'AddPersonView: Provider作成完了 - isEditingPerson=${_provider.isEditingPerson}',
      );
    }
  }

  void _initializeControllers() {
    if (_controllersInitialized) return; // 二重初期化防止

    // Controllerの初期化（Provider の状態から）
    _nameController.text = _provider.name;
    _companyController.text = _provider.company;
    _positionController.text = _provider.position;

    // デバッグログ
    if (kDebugMode) {
      print('AddPersonView: Controller初期化');
      print('  Controller - name: "${_nameController.text}"');
      print('  Controller - company: "${_companyController.text}"');
      print('  Controller - position: "${_positionController.text}"');
      print('  Provider - name: "${_provider.name}"');
      print('  Provider - company: "${_provider.company}"');
      print('  Provider - position: "${_provider.position}"');
    }

    // Controller -> Provider 同期（双方向バインディング）
    _nameController.addListener(() {
      _provider.updateName(_nameController.text);
    });
    _companyController.addListener(() {
      _provider.updateCompany(_companyController.text);
    });
    _positionController.addListener(() {
      _provider.updatePosition(_positionController.text);
    });

    _controllersInitialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _positionController.dispose();
    _tagInputController.dispose();
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: FutureBuilder<void>(
        future: _provider.initializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 初期化中はローディングを表示
            return const Scaffold(
              backgroundColor: Color(0xFFF8FAFC),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            // エラー時はエラーメッセージを表示
            return Scaffold(
              backgroundColor: const Color(0xFFF8FAFC),
              body: Center(child: Text('エラーが発生しました: ${snapshot.error}')),
            );
          }

          // 初期化完了後にControllerを初期化してUIを構築
          if (!_controllersInitialized) {
            _initializeControllers();
          }
          return _buildScaffold();
        },
      ),
    );
  }

  Widget _buildScaffold() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAvatarPreview(),
                      const SizedBox(height: 16),
                      _buildColorPicker(),
                      const SizedBox(height: 24),
                      _buildNameSection(),
                      const SizedBox(height: 24),
                      _buildCompanySection(),
                      if (widget.person != null) ...[
                        const SizedBox(height: 24),
                        _buildMemorizedSwitch(),
                      ],
                      const SizedBox(height: 32),
                      _buildConnectionInfo(),
                      const SizedBox(height: 24),
                      // 編集モードの場合のみ削除ボタンを表示
                      if (widget.person != null) ...[
                        const SizedBox(height: 16),
                        _buildDeleteButton(),
                      ],
                      const SizedBox(height: 100), // 広めの余白
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemorizedSwitch() {
    return Consumer<AddPersonProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SwitchListTile(
            title: const Text(
              'この人を覚えた',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            value: provider.isMemorized,
            onChanged: (bool value) {
              provider.updateIsMemorized(value);
            },
            activeThumbColor: const Color(0xFF4D6FFF),
            secondary: Icon(
              provider.isMemorized
                  ? Icons.check_circle
                  : Icons.check_circle_outline,
              color: provider.isMemorized
                  ? const Color(0xFF4D6FFF)
                  : Colors.grey[400],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 編集モードの場合のみキャンセルボタンを表示
          widget.person != null
              ? GestureDetector(
                  onTap: () {
                    // onCancelコールバックがあれば呼び出し、なければ単純にpop
                    if (widget.onCancel != null) {
                      widget.onCancel!();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFF666666),
                    size: 24,
                  ),
                )
              : const SizedBox(width: 48),
          const Text(
            '記憶を記録',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: () async {
              final success = await _provider.save();
              if (success) {
                widget.onSave?.call();
              }
            },
            child: const Text(
              '保存',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF4D6FFF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPreview() {
    final name = _provider.name;
    final initial = name.isEmpty ? '？' : name[0];
    final hasPhoto = _provider.selectedImage != null;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 130,
            width: 130,
            decoration: BoxDecoration(
              color: hasPhoto
                  ? Colors.transparent
                  : _parseColor(
                      _provider.avatarColors[_provider.selectedColorIndex],
                    ).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(24),
              border: hasPhoto
                  ? Border.all(
                      color: _parseColor(
                        _provider.avatarColors[_provider.selectedColorIndex],
                      ),
                      width: 4,
                    )
                  : null,
            ),
            child: hasPhoto
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      _provider.selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Text(
                      initial,
                      style: TextStyle(
                        color: _parseColor(
                          _provider.avatarColors[_provider.selectedColorIndex],
                        ),
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
          // カメラボタン（写真がない時）
          if (!hasPhoto)
            Positioned(
              bottom: -10,
              right: -10,
              child: GestureDetector(
                onTap: _handleAddPhoto,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
              ),
            ),
          // 削除ボタン（写真がある時）
          if (hasPhoto)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  _provider.removeImage();
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[700]?.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    return Consumer<AddPersonProvider>(
      builder: (context, provider, child) {
        return Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,  // 16.0から8.0に減らして間隔を縮小
            runSpacing: 8.0,
            children: List.generate(provider.avatarColors.length, (index) {
              final isSelected = index == provider.selectedColorIndex;
              return GestureDetector(
                onTap: () {
                  provider.selectColor(index);
                },
                child: Container(
                  width: 42,  // 48から42にサイズを縮小
                  height: 42,
                  alignment: Alignment.center,
                  child: Container(
                    width: isSelected ? 42 : 36,  // サイズを縮小
                    height: isSelected ? 42 : 36,
                    decoration: BoxDecoration(
                      color: _parseColor(provider.avatarColors[index]),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 2,  // 3から2に減らす
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: _parseColor(
                                  provider.avatarColors[index],
                                ).withValues(alpha: 0.5),
                                blurRadius: 6,  // 8から6に減らす
                                spreadRadius: 1,  // 2から1に減らす
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)  // 24から20に縮小
                        : null,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  Widget _buildNameSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '名前',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'わからなければ空欄でOK',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '所属',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _companyController,
                  decoration: InputDecoration(
                    hintText: '会社、学校など',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '肩書き',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _positionController,
                  decoration: InputDecoration(
                    hintText: '役職、学年など',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '特徴・タグ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _buildTagsCard(),
        const SizedBox(height: 24),
        const Text(
          'いつ、どこで会った？',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _buildMeetingRecordsSection(),
      ],
    );
  }

  Widget _buildMeetingRecordsSection() {
    return Consumer<AddPersonProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // 各会合記録のカード
            ...provider.meetingRecords.asMap().entries.map((entry) {
              final index = entry.key;
              final record = entry.value;
              final isNew = index == provider.newlyAddedIndex;

              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: isNew ? 0.0 : 1.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * 20),
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildMeetingRecordCard(record, index),
                ),
              );
            }),
            // 会合記録追加ボタン
            GestureDetector(
              onTap: () => provider.addMeetingRecord(),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF4D6FFF), width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: Color(0xFF4D6FFF)),
                    const SizedBox(width: 8),
                    const Text(
                      '別の日を追加',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4D6FFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMeetingRecordCard(MeetingRecordInput record, int index) {
    return Consumer<AddPersonProvider>(
      builder: (context, provider, child) {
        final currentRecord = provider.meetingRecords[index];
        final String dateText;
        final Color dateColor;

        if (currentRecord.date == null) {
          dateText = 'いつ会った？（タップして設定）';
          dateColor = Colors.grey.shade600;
        } else {
          final now = DateTime.now();
          final isToday =
              currentRecord.date!.year == now.year &&
              currentRecord.date!.month == now.month &&
              currentRecord.date!.day == now.day;
          dateText =
              '${currentRecord.date!.year}.${currentRecord.date!.month.toString().padLeft(2, '0')}.${currentRecord.date!.day.toString().padLeft(2, '0')}${isToday ? ' (今日)' : ''}';
          dateColor = Colors.black87;
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // ヘッダー（削除ボタン）
              if (_provider.meetingRecords.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => _provider.removeMeetingRecord(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              // 日付選択
              GestureDetector(
                onTap: () => _selectDateForRecord(index),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF4CAF50),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        dateText,
                        style: TextStyle(fontSize: 16, color: dateColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // 場所入力
              LocationInputWidget(
                controller: currentRecord.locationController,
                hintText: '場所',
                latitude: currentRecord.latitude,
                longitude: currentRecord.longitude,
                locationType: currentRecord.locationType,
                onLocationChanged:
                    (
                      String location,
                      double? latitude,
                      double? longitude,
                      LocationType type,
                    ) {
                      // デバッグログ
                      if (kDebugMode) {
                        print(
                          '位置情報更新: recordId=${currentRecord.id}, location=$location, lat=$latitude, lng=$longitude, type=$type',
                        );
                      }

                      // recordのIDで直接更新
                      _provider.updateMeetingLocationById(
                        currentRecord.id,
                        location,
                        latitude,
                        longitude,
                        type,
                      );
                    },
              ),
              const SizedBox(height: 16),
              // メモ入力
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE3F2FD),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_note,
                      color: Color(0xFF2196F3),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: record.notesController,
                      decoration: InputDecoration(
                        hintText: 'メモ（会話内容など）',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 16),
                      maxLines: null,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTagsCard() {
    return Consumer<AddPersonProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3E5F5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_offer,
                      color: Color(0xFF9C27B0),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _tagInputController,
                      decoration: InputDecoration(
                        hintText: '特徴タグ（スペース区切り）',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: _handleTagInputWrapper,
                    ),
                  ),
                ],
              ),
              if (provider.tags.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: provider.tags.map((tag) => _buildTag(tag)).toList(),
                ),
              ],
              if (provider.suggestedTags.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: provider.suggestedTags
                      .where((tag) => !provider.tags.contains(tag))
                      .map((tag) => _buildSuggestedTag(tag))
                      .toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTag(String label) {
    return GestureDetector(
      onTap: () => _provider.removeTag(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.close, size: 16, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedTag(String label) {
    return GestureDetector(
      onTap: () => _provider.addSuggestedTag(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ),
    );
  }

  void _handleAddPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _provider.setSelectedImage(File(image.path));
    }
  }

  void _handleTagInputWrapper(String input) {
    final shouldClear = _provider.handleTagInput(input);
    if (shouldClear) {
      _tagInputController.clear();
    }
  }

  void _selectDateForRecord(int index) async {
    final currentDate = _provider.meetingRecords[index].date;

    // 日付が設定されている場合、クリアするオプションを提供
    if (currentDate != null) {
      final shouldClear = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('日付を変更'),
          content: const Text('日付を変更しますか？それとも未設定にしますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('未設定にする'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('日付を変更'),
            ),
          ],
        ),
      );

      if (shouldClear == true) {
        _provider.updateMeetingDate(index, null);
        return;
      } else if (shouldClear == null) {
        return; // キャンセル
      }
    }

    // 日付選択ダイアログを表示
    if (!mounted) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      _provider.updateMeetingDate(index, picked);
    }
  }

  Widget _buildDeleteButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _showDeleteConfirmDialog(),
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          label: const Text(
            '記録をすべて削除',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('削除の確認'),
        content: Text(
          '${widget.person?.name ?? 'この人'}の記録をすべて削除します。\n削除した記録は復元できません。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // ダイアログを閉じる

              if (widget.person != null) {
                final success = await _provider.deletePerson(widget.person!.id);
                if (success && mounted) {
                  widget.onSave?.call(); // データ更新を通知
                }
              }
            },
            child: const Text('削除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class DashedBorder extends StatelessWidget {
  final Widget child;

  const DashedBorder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: DashedBorderPainter(), child: child);
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueGrey[200]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 4.0;
    const radius = 20.0;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(radius),
        ),
      );

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
