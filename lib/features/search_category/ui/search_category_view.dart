import 'package:flutter/material.dart';
import 'package:sahifa/core/widgets/custom_article_item_card.dart';
import 'package:sahifa/features/details_artical/data/local_data.dart';

class SearchCategoryView extends StatelessWidget {
  const SearchCategoryView({super.key, required this.categoryName});
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName), elevation: 0),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    height: 320,
                    child: CustomArticleItemCard(
                      articleItem: trendingArticles[index],
                      cardWidth: double.infinity,
                      isItemList: true,
                    ),
                  ),
                );
              }, childCount: trendingArticles.length),
            ),
          ),
        ],
      ),
    );
  }
}
