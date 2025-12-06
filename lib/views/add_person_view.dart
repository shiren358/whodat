import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/person.dart';
import '../services/person_storage.dart';

class AddPersonView extends StatefulWidget {
  final VoidCallback? onSave;

  const AddPersonView({super.key, this.onSave});

  @override
  State<AddPersonView> createState() => _AddPersonViewState();
}

class _AddPersonViewState extends State<AddPersonView> {
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _locationController = TextEditingController();
  final _tagInputController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  File? _selectedImage;
  final List<String> _tags = [];
  final ImagePicker _picker = ImagePicker();

  final List<String> _avatarColors = [
    '#4D6FFF',
    '#9B72FF',
    '#FF6B9D',
    '#FF6F00',
    '#00D4AA',
    '#607D8B',
  ];
  int _selectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {}); // アバタープレビューを更新
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _positionController.dispose();
    _locationController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      const SizedBox(height: 32),
                      _buildConnectionInfo(),
                      const SizedBox(height: 24),
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

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48),
          const Text(
            '記憶を記録',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: _handleSave,
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
    final name = _nameController.text.trim();
    final initial = name.isEmpty ? '？' : name[0];
    final hasPhoto = _selectedImage != null;

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
                      _avatarColors[_selectedColorIndex],
                    ).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(24),
              border: hasPhoto
                  ? Border.all(
                      color: _parseColor(_avatarColors[_selectedColorIndex]),
                      width: 4,
                    )
                  : null,
            ),
            child: hasPhoto
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  )
                : Center(
                    child: Text(
                      initial,
                      style: TextStyle(
                        color: _parseColor(_avatarColors[_selectedColorIndex]),
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
                  setState(() {
                    _selectedImage = null;
                  });
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
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_avatarColors.length, (index) {
          final isSelected = index == _selectedColorIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColorIndex = index;
              });
            },
            child: Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              child: Container(
                width: isSelected ? 48 : 40,
                height: isSelected ? 48 : 40,
                decoration: BoxDecoration(
                  color: _parseColor(_avatarColors[index]),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: _parseColor(
                              _avatarColors[index],
                            ).withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 24)
                    : null,
              ),
            ),
          );
        }),
      ),
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
          'つながり情報',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.location_on,
          iconColor: const Color(0xFFFFC107),
          iconBgColor: const Color(0xFFFFF9E6),
          label: '場所',
          controller: _locationController,
        ),
        const SizedBox(height: 12),
        _buildDateCard(),
        const SizedBox(height: 12),
        _buildTagsCard(),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: label,
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
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
            Text(
              '${_selectedDate.year}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.day.toString().padLeft(2, '0')} (今日)',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsCard() {
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
                    hintText: '特徴タグを入力',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: Color(0xFF9C27B0),
                      ),
                      onPressed: () => _addTag(_tagInputController.text),
                    ),
                  ),
                  onSubmitted: _addTag,
                ),
              ),
            ],
          ),
          if (_tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags.map((tag) => _buildTag(tag)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return GestureDetector(
      onTap: () => _removeTag(label),
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

  void _handleAddPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addTag(String tag) {
    if (tag.trim().isNotEmpty && !_tags.contains(tag.trim())) {
      setState(() {
        _tags.add(tag.trim());
        _tagInputController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _handleSave() async {
    final person = Person(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim().isEmpty
          ? null
          : _nameController.text.trim(),
      company: _companyController.text.trim().isEmpty
          ? null
          : _companyController.text.trim(),
      position: _positionController.text.trim().isEmpty
          ? null
          : _positionController.text.trim(),
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      tags: _tags,
      registeredDate: _selectedDate,
      avatarColor: _avatarColors[_selectedColorIndex],
      photoPath: _selectedImage?.path,
    );

    await PersonStorage.savePerson(person);
    widget.onSave?.call();
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
