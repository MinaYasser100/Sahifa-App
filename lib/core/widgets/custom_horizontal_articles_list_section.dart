import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';
import 'package:sahifa/core/widgets/custom_article_item_card.dart';

class CustomHorizontalArticlesListSection extends StatelessWidget {
  const CustomHorizontalArticlesListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ArticalItemModel> articlesItems = [
      ArticalItemModel(
        imageUrl:
            'https://images.unsplash.com/photo-1495020689067-958852a7765e?w=400',
        title: 'Breaking: Major Political Event',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        date: DateTime(2025, 10, 12),
        viewerCount: 15420,
      ),
      ArticalItemModel(
        imageUrl:
            'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=400',
        title: 'Technology News Update',
        description: 'Sed do eiusmod tempor incididunt ut labore et dolore.',
        date: DateTime(2025, 10, 11),
        viewerCount: 8750,
      ),
      ArticalItemModel(
        imageUrl:
            'https://images.unsplash.com/photo-1522869635100-9f4c5e86aa37?w=400',
        title: 'Sports Championship Finals',
        description: 'Ut enim ad minim veniam, quis nostrud exercitation.',
        date: DateTime(2025, 10, 10),
        viewerCount: 23500,
      ),
      ArticalItemModel(
        imageUrl:
            'https://images.unsplash.com/photo-1586339949916-3e9457bef6d3?w=400',
        title: 'Business Market Analysis',
        description: 'Duis aute irure dolor in reprehenderit in voluptate.',
        date: DateTime(2025, 10, 9),
        viewerCount: 12300,
      ),
    ];

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: articlesItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.push(
                Routes.detailsArticalView,
                extra: articlesItems[index],
              );
            },
            child: FadeInLeft(
              child: CustomArticleItemCard(articleItem: articlesItems[index]),
            ),
          );
        },
      ),
    );
  }
}
