import 'package:flutter/material.dart';
import 'package:sahifa/core/widgets/custom_article_image.dart';
import 'package:sahifa/core/widgets/custom_trending/custom_trending_articles_section.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';

import 'details_article_content.dart';
import 'related_articles_section.dart';

class DetailsArticleBodyView extends StatelessWidget {
  const DetailsArticleBodyView({super.key, required this.articalModel});

  final ArticalItemModel articalModel;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Article Image
        SliverToBoxAdapter(
          child: Hero(
            tag: 'article_${articalModel.imageUrl}',
            child: CustomArticleImage(
              imageUrl: articalModel.imageUrl,
              height: 300,
            ),
          ),
        ),

        // Content Section
        SliverToBoxAdapter(
          child: DetailsArticleContent(articalModel: articalModel),
        ),

        // Related Articles Section
        SliverToBoxAdapter(child: RelatedArticlesSection()),

        // Trending Articles Section
        SliverToBoxAdapter(child: CustomTrendingArticlesSection()),
      ],
    );
  }
}
