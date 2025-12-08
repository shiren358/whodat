import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../models/meeting_record.dart';
import '../models/person.dart';
import '../providers/home_provider.dart';
import '../l10n/l10n.dart';
import 'add_person_view.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView>
    with TickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Person? _personToEdit; // 編集対象のPerson
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<MeetingRecord> _getEventsForDay(
    DateTime day,
    List<MeetingRecord> records,
  ) {
    return records.where((record) {
      return isSameDay(record.meetingDate, day);
    }).toList();
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

    return Scaffold(
      body: SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: _getSelectedContent(),
        ),
      ),
    );
  }

  Widget _getSelectedContent() {
    if (_personToEdit != null) {
      return _buildAddPersonContent();
    } else {
      return _buildCalendarContent();
    }
  }

  Widget _buildCalendarContent() {
    return Container(
      color: const Color(0xFFF5F5F7),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [_buildCalendar(), _buildEventList()]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPersonContent() {
    return AddPersonView(
      key: ValueKey(_personToEdit?.id ?? 'add'),
      person: _personToEdit,
      onSave: () {
        // データを再読み込み
        final provider = Provider.of<HomeProvider>(context, listen: false);
        provider.loadData();

        // アニメーション付きでCalendar画面に戻る
        _animationController.reverse().then((_) {
          if (!mounted) return;
          setState(() {
            _personToEdit = null; // 編集対象をクリア
          });
          _animationController.forward();
        });
      },
      onCancel: () {
        // アニメーション付きでCalendar画面に戻る（保存時と同じ処理）
        _animationController.reverse().then((_) {
          if (!mounted) return;
          setState(() {
            _personToEdit = null; // 編集対象をクリア
          });
          _animationController.forward();
        });
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context)!.calendar,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            S.of(context)!.reviewMeetings,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) =>
                _getEventsForDay(day, provider.allLatestMeetingRecordsByPerson),
            locale: 'ja_JP',
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: false,
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black87),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.black87,
              ),
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: const Color(0xFF4D6FFF).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                color: Color(0xFF4D6FFF),
                fontWeight: FontWeight.bold,
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF4D6FFF),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              markerDecoration: const BoxDecoration(
                color: Color(0xFF4D6FFF),
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        );
      },
    );
  }

  Widget _buildEventList() {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final events = _getEventsForDay(
          _selectedDay!,
          provider.allLatestMeetingRecordsByPerson,
        );

        if (events.isEmpty) {
          return const SizedBox();
        }

        final weekdayNames = [
      S.of(context)!.monday,
      S.of(context)!.tuesday,
      S.of(context)!.wednesday,
      S.of(context)!.thursday,
      S.of(context)!.friday,
      S.of(context)!.saturday,
      S.of(context)!.sunday,
    ];
        final weekday = weekdayNames[_selectedDay!.weekday - 1];

        return Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context)!.dateWithWeekday(
                  _selectedDay!.year,
                  _selectedDay!.month,
                  _selectedDay!.day,
                  weekday,
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ...events.map((record) => _buildEventCard(record, provider)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventCard(MeetingRecord record, HomeProvider provider) {
    final person = provider.getPersonForRecord(record);

    return GestureDetector(
      onTap: () {
        // アニメーション付きで編集画面に移動
        _animationController.reverse().then((_) {
          if (!mounted) return;
          setState(() {
            _personToEdit = person;
          });
          _animationController.forward();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: person?.avatarColor != null
                    ? _parseColor(person!.avatarColor)
                    : const Color(0xFF4D6FFF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person?.name ?? S.of(context)!.nameNotRegistered,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (record.location != null &&
                      record.location!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      record.location!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                  if (record.notes != null && record.notes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      record.notes!,
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
