import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '../providers/home_provider.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/tag_chip.dart';
import '../widgets/person_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
      ),
      bottomNavigationBar: DefaultTextStyle(
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        child: ConvexAppBar(
          items: const [
            TabItem(icon: Icons.home_outlined, title: 'Home'),
            TabItem(icon: Icons.calendar_today_outlined, title: 'Calendar'),
            TabItem(icon: Icons.add, title: 'Add'),
            TabItem(icon: Icons.map_outlined, title: 'Map'),
            TabItem(icon: Icons.person_outline, title: 'MyPage'),
          ],
          initialActiveIndex: 0,
          backgroundColor: Colors.white,
          color: const Color(0xFFB0B0B0),
          activeColor: const Color(0xFF4D6FFF),
          style: TabStyle.reactCircle,
          height: 60,
          top: -25,
          curveSize: 90,
          onTap: (int i) {},
        ),
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
                      '最近の記録',
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
                  itemCount: provider.recentPersons.length,
                  itemBuilder: (context, index) {
                    final person = provider.recentPersons[index];
                    return PersonCard(person: person, onTap: () {});
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
