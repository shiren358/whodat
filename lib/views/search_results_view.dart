import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/person_card.dart'; // Import PersonCard
import '../models/person.dart';
import '../l10n/l10n.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({super.key, this.onPersonTap});

  // 人物をタップした時のコールバック
  final Function(Person?)? onPersonTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (!provider.hasSearchQuery) {
          return const SizedBox.shrink();
        }

        if (!provider.hasSearchResults) {
          return _buildEmptyState(context, provider.searchQuery);
        }

        return _buildSearchResults(context, provider);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String query) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40), // 上部に余白を追加
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context)!.searchResultsFor(query),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context)!.notFound,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Provider.of<HomeProvider>(context, listen: false).clearSearch();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Provider.of<ThemeProvider>(context).themeColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(S.of(context)!.clearSearch),
          ),
          const SizedBox(height: 40), // 下部に余白を追加
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, HomeProvider provider) {
    return Column(
      children: [
        // 検索結果ヘッダー
        Container(
          padding: const EdgeInsets.all(24),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context)!.searchResultsFor(provider.searchQuery),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.of(context)!.foundResultsCount(provider.searchResults.length),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  provider.clearSearch();
                },
                icon: const Icon(Icons.clear),
                color: Colors.grey[600],
              ),
            ],
          ),
        ),

        // 検索結果リスト
        Expanded(
          child: Container(
            color: const Color(0xFFF5F5F7),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: provider.searchResults.length,
              itemBuilder: (context, index) {
                final person = provider.searchResults[index];
                return PersonCard(
                  person: person,
                  onTap: () {
                    onPersonTap?.call(person);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}