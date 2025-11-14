import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/like_post/ui/like_button_widget.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_book_opinion_image.dart';
import 'package:sahifa/core/widgets/custom_image_widget.dart';
import 'package:sahifa/core/widgets/custom_trending/custom_mobile_trending_articles_section_body.dart';
import 'package:sahifa/features/details_artical/ui/widgets/details_article_content.dart';
import 'package:sahifa/features/details_artical/ui/widgets/related_articles_section.dart';

class DetailsArticleBodyView extends StatelessWidget {
  const DetailsArticleBodyView({super.key, required this.articalModel});

  final ArticleModel articalModel;

  @override
  Widget build(BuildContext context) {
    log(articalModel.ownerIsAuthor.toString());
    return CustomScrollView(
      slivers: [
        // Article Image
        SliverToBoxAdapter(
          child: Hero(
            tag: 'article_${articalModel.image}',
            child: Stack(
              children: [
                FadeIn(
                  child: articalModel.ownerIsAuthor == true
                      ? CustomBookOpinionImage(
                          imageUrl: articalModel.authorImage ?? '',
                          authorName: articalModel.authorName ?? '',
                          containerWidth: double.infinity,
                          isListItem: true,
                        )
                      : CustomImageWidget(
                          imageUrl: articalModel.image ?? '',
                          height: 300,
                          changeBorderRadius: true,
                        ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: LikeButtonWidget(
                    article: articalModel,
                    size: 24,
                    radius: 20,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Content Section
        SliverToBoxAdapter(
          child: DetailsArticleContent(articalModel: articalModel),
        ),

        // Comments Section
        // SliverToBoxAdapter(child: CommentsSection()),

        // Related Articles Section
        SliverToBoxAdapter(
          child: RelatedArticlesSection(
            categorySlug: articalModel.categorySlug!,
            articleSlug: articalModel.slug!,
          ),
        ),

        // Trending Articles Section
        SliverToBoxAdapter(child: CustomMobileTrendingArticlesSectionBody()),
      ],
    );
  }
}
