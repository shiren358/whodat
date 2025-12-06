import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '../providers/home_provider.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/tag_chip.dart';
import '../widgets/meeting_record_card.dart';
import '../models/person.dart';
import 'add_person_view.dart';
import 'calendar_view.dart';
import 'map_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  final GlobalKey<ConvexAppBarState> _tabKey = GlobalKey<ConvexAppBarState>();
  Person? _personToEdit; // 編集対象のPerson

  @override
  void initState() {
    super.initState();
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
      bottomNavigationBar: DefaultTextStyle(
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        child: ConvexAppBar(
          key: _tabKey,
          items: const [
            TabItem(icon: Icons.home_outlined, title: 'Home'),
            TabItem(icon: Icons.calendar_today_outlined, title: 'Calendar'),
            TabItem(icon: Icons.add, title: 'Add'),
            TabItem(icon: Icons.map_outlined, title: 'Map'),
            TabItem(icon: Icons.person_outline, title: 'MyPage'),
          ],
          initialActiveIndex: _selectedIndex,
          backgroundColor: Colors.white,
          color: const Color(0xFFB0B0B0),
          activeColor: const Color(0xFF4D6FFF),
          style: TabStyle.reactCircle,
          height: 60,
          top: -25,
          curveSize: 90,
          onTap: (int i) {
            if (_selectedIndex == i) return;
            _animationController.reverse().then((_) {
              if (!mounted) return;
              setState(() {
                if (i == 2) {
                  // Addタブの場合、編集対象をクリア
                  _personToEdit = null;
                }
                _selectedIndex = i;
              });
              _animationController.forward();
            });
          },
        ),
      ),
    );
  }

  Widget _getSelectedContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const CalendarView(key: ValueKey('calendar'));
      case 2:
        return _buildAddPersonContent();
      case 3:
        return const MapView(key: ValueKey('map'));
      case 4:
        return _buildPlaceholder('MyPage');
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      key: const ValueKey('home'),
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4D6FFF), Color(0xFF9B72FF)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [_buildTopBar(context), _buildHeroSection(context)],
            ),
          ),
        ),
        Expanded(child: _buildRecentSection(context)),
      ],
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

        // アニメーション付きでHome画面に戻る
        _animationController.reverse().then((_) {
          if (!mounted) return;
          setState(() {
            _personToEdit = null; // 編集対象をクリア
            _selectedIndex = 0; // Home画面に戻る
          });
          _animationController.forward();
        });
      },
    );
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      key: ValueKey(title),
      child: Text(
        '$title画面',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Whodat?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                '「あの人、誰だっけ？」\nをなくそう。',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 24),
              CustomSearchBar(onChanged: provider.updateSearchQuery),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: provider.suggestedTags
                    .map((tag) => TagChip(label: tag))
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentSection(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: const BoxDecoration(color: Color(0xFFF5F5F7)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '最近会った人',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'すべて見る',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4D6FFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: provider.latestMeetingRecordsByPerson.length,
                  itemBuilder: (context, index) {
                    final record = provider.latestMeetingRecordsByPerson[index];
                    final person = provider.getPersonForRecord(record);
                    return MeetingRecordCard(
                      record: record,
                      person: person,
                      onTap: () {
                        // TODO: Update to support editing meeting records
                        // when AddPersonView is refactored to support 3 modes
                        _animationController.reverse().then((_) {
                          if (!mounted) return;
                          setState(() {
                            _personToEdit = person;
                            _selectedIndex = 2; // Add画面に移動
                          });
                          _animationController.forward();
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
