import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/details_artical/data/local_data.dart';
import 'package:sahifa/core/widgets/custom_trending/trending_article_card.dart';

class CustomTrendingArticlesSection extends StatelessWidget {
  const CustomTrendingArticlesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample trending articles data

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: Row(
            children: [
              Icon(
                Icons.trending_up,
                color: ColorsTheme().primaryLight,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Trending Now',
                style: AppTextStyles.styleBold18sp(
                  context,
                ).copyWith(color: ColorsTheme().primaryLight),
              ),
            ],
          ),
        ),

        // Trending Articles List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: trendingArticles.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                context.push(
                  Routes.detailsArticalView,
                  extra: trendingArticles[index],
                );
              },
              child: TrendingArticleCard(
                articleItem: trendingArticles[index],
                index: index,
              ),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
