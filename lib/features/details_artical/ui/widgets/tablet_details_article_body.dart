import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/like_post/ui/like_button_widget.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_book_opinion_image.dart';
import 'package:sahifa/core/widgets/custom_image_widget.dart';
import 'package:sahifa/core/widgets/custom_trending/custom_tablet_trending_articles_grid.dart';

import 'comments/comments_section.dart';
import 'details_article_content.dart';
import 'related_articles_section.dart';

class TabletDetailsArticleBody extends StatelessWidget {
  const TabletDetailsArticleBody({super.key, required this.articalModel});

  final ArticleModel articalModel;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Hero(
                    tag: 'article_${articalModel.image}',
                    child: Stack(
                      children: [
                        FadeIn(
                          child: articalModel.ownerIsAuthor == true
                              ? CustomBookOpinionImage(
                                  imageUrl: articalModel.image ?? '',
                                  authorName: articalModel.authorName ?? '',
                                  containerWidth: double.infinity,
                                  isListItem: true,
                                )
                              : CustomImageWidget(
                                  imageUrl: articalModel.image ?? '',
                                  height: 500,
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
                const SizedBox(width: 32),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailsArticleContent(articalModel: articalModel),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CommentsSection(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: RelatedArticlesSection(
              categorySlug: articalModel.categorySlug!,
              articleSlug: articalModel.slug!,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CustomTabletTrendingArticlesGrid(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
