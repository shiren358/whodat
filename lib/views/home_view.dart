import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import '../providers/home_provider.dart';
import '../providers/add_person_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/tag_chip.dart';
import '../widgets/person_card.dart';
import '../models/person.dart';
import '../services/app_update_service.dart';
import '../l10n/l10n.dart';
import 'add_person_view.dart';
import 'calendar_view.dart';
import 'map_view.dart';
import 'search_results_view.dart';
import 'all_records_view.dart';
import 'my_page_view.dart';
import 'app_story_view.dart';

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

  int _heroTextIndex = 0;
  late List<String> _heroTexts;

  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    // Initialize hero texts with empty strings first
    _heroTexts = ['', '', ''];

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
    _loadHeroTextIndex();

    // Update hero texts with localization after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final l10n = S.of(context)!;
        _heroTexts = [l10n.heroTitle1, l10n.heroTitle2, l10n.heroTitle3];

        // ローカライズされたタグをProviderに設定
        final provider = Provider.of<HomeProvider>(context, listen: false);
        provider.updateLocalizedSuggestedTags([
          l10n.metLastWeek,
          l10n.today,
          l10n.thisMonth,
        ]);

        setState(() {});
      }
    });

    // アップデートチェックは最初のフレーム後に実行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AppUpdateService().checkForUpdates(context);
      }
    });

    // ATTダイアログを表示（iOS 14.5以降）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestTrackingAuthorization();
    });
  }

  Future<void> _requestTrackingAuthorization() async {
    if (!Platform.isIOS) return;

    // ATTのステータスを確認
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      // 少し遅延させてから表示（UX向上のため）
      await Future.delayed(const Duration(milliseconds: 500));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  Future<void> _loadHeroTextIndex() async {
    final value = await _storage.read(key: 'heroTextIndex');
    if (value != null) {
      setState(() {
        _heroTextIndex = int.parse(value);
      });
    }
  }

  Future<void> _saveHeroTextIndex(int index) async {
    await _storage.write(key: 'heroTextIndex', value: index.toString());
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
      bottomNavigationBar: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return DefaultTextStyle(
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            child: ConvexAppBar(
              key: _tabKey,
              items: [
                TabItem(icon: Icons.home_outlined, title: S.of(context)!.home),
                TabItem(
                  icon: Icons.calendar_today_outlined,
                  title: S.of(context)!.calendar,
                ),
                TabItem(icon: Icons.add, title: S.of(context)!.addPerson),
                TabItem(icon: Icons.map_outlined, title: S.of(context)!.map),
                TabItem(
                  icon: Icons.person_outline,
                  title: S.of(context)!.myPage,
                ),
              ],
              initialActiveIndex: _selectedIndex,
              backgroundColor: Colors.white,
              color: const Color(0xFFB0B0B0),
              activeColor: themeProvider.themeColor,
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

                    // Homeタブに切り替わった時だけデータを再読み込みしてタグを更新
                    if (i == 0) {
                      final provider = Provider.of<HomeProvider>(
                        context,
                        listen: false,
                      );
                      provider.loadData();
                    }
                  });
                  _animationController.forward();
                });
              },
            ),
          );
        },
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
        return const MyPageView(key: ValueKey('my_page'));
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Column(
          key: const ValueKey('home'),
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: Stack(
                children: [
                  // グラデーション背景
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          themeProvider.themeColor,
                          themeProvider.getGradientEndColor(),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        children: [
                          _buildTopBar(context),
                          _buildHeroSection(context),
                        ],
                      ),
                    ),
                  ),
                  // 装飾パターン - 右上の円
                  Positioned(
                    right: -30,
                    top: -30,
                    child: IgnorePointer(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                  ),
                  // 装飾パターン - 右下の円
                  Positioned(
                    right: 40,
                    bottom: -50,
                    child: IgnorePointer(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildRecentSection(context)),
          ],
        );
      },
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
      onCancel: () {
        // アニメーション付きでHome画面に戻る（保存時と同じ処理）
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
              Text(
                S.of(context)!.appTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AppStoryView()),
              );
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lightbulb, color: Colors.white, size: 24),
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
              GestureDetector(
                onTap: () {
                  final newIndex = (_heroTextIndex + 1) % _heroTexts.length;
                  _saveHeroTextIndex(newIndex);
                  setState(() {
                    _heroTextIndex = newIndex;
                  });
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  layoutBuilder:
                      (Widget? currentChild, List<Widget> previousChildren) {
                        return Stack(
                          alignment: Alignment.centerLeft,
                          children: <Widget>[
                            ...previousChildren,
                            if (currentChild != null) currentChild,
                          ],
                        );
                      },
                  child: Text(
                    _heroTexts[_heroTextIndex],
                    key: ValueKey<int>(_heroTextIndex),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomSearchBar(onChanged: provider.updateSearchQuery),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // 固定タグ（1行目）
                  ...provider.suggestedTags.map(
                    (tag) => TagChip(
                      label: tag,
                      onTap: () {
                        provider.updateSearchQuery(tag);
                      },
                    ),
                  ),
                  // 動的タグ（2行目）
                  ...provider.randomTags.map(
                    (tag) => TagChip(
                      label: tag,
                      onTap: () {
                        provider.updateSearchQuery(tag);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentSection(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Consumer<HomeProvider>(
          builder: (context, provider, child) {
            // 検索クエリがある場合は検索結果を表示
            if (provider.hasSearchQuery) {
              return SearchResultsView(
                onPersonTap: (person) {
                  if (person == null) return;

                  // HomeViewのカードタップと同じ処理を実行
                  _animationController.reverse().then((_) {
                    if (!mounted) return;
                    setState(() {
                      _personToEdit = person;
                      _selectedIndex = 2; // Add画面に移動

                      // デバッグログ
                      if (kDebugMode) {
                        print(
                          'SearchResultsView: カードタップ - person=${person.name}, personId=${person.id}',
                        );
                      }
                    });
                    _animationController.forward();
                  });
                },
              );
            }

            // 通常の「最近登録した人」を表示
            return Container(
              decoration: const BoxDecoration(color: Color(0xFFF5F5F7)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context)!.recentlyRegistered,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _animationController.reverse().then((_) {
                              if (!mounted) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllRecordsView(
                                    onPersonTap: (person) {
                                      if (person == null) return;

                                      // 編集完了後にAllRecordsViewに戻るためのフラグ付きでAddPersonViewに遷移
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                                create: (_) =>
                                                    AddPersonProvider(
                                                      person: person,
                                                    ),
                                                child: AddPersonView(
                                                  person: person,
                                                  onSave: () {
                                                    // データを再読み込み
                                                    final provider =
                                                        Provider.of<
                                                          HomeProvider
                                                        >(
                                                          context,
                                                          listen: false,
                                                        );
                                                    provider.loadData();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ).then((_) {
                                if (!mounted) return;
                                _animationController.forward();
                              });
                            });
                          },
                          child: Text(
                            S.of(context)!.viewAll,
                            style: TextStyle(
                              fontSize: 14,
                              color: themeProvider.themeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: provider.latestRegisteredPersons.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: provider.latestRegisteredPersons.length,
                            itemBuilder: (context, index) {
                              final person =
                                  provider.latestRegisteredPersons[index];
                              return PersonCard(
                                person: person,
                                onTap: () {
                                  _animationController.reverse().then((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      _personToEdit = person;
                                      _selectedIndex = 2; // Add画面に移動

                                      // デバッグログ
                                      if (kDebugMode) {
                                        print(
                                          'HomeView: カードタップ - person=${person.name}, personId=${person.id}',
                                        );
                                      }
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
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            S.of(context)!.noRecords,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context)!.addFirstPerson,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
