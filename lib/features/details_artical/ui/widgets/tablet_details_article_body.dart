import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/utils/auth_checker.dart';
import 'package:sahifa/core/utils/colors.dart';
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
                          child: (articalModel.categoryId == "books_opinions")
                              ? CustomBookOpinionImage(
                                  imageUrl: articalModel.image ?? '',
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
                          child: FadeInDown(
                            child: CircleAvatar(
                              backgroundColor: ColorsTheme().whiteColor
                                  .withValues(alpha: 0.9),
                              child: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.heart,
                                  color: ColorsTheme().primaryColor,
                                ),
                                onPressed: () async {
                                  // Check authentication before like
                                  if (await AuthChecker.checkAuthAndNavigate(
                                    context,
                                  )) {
                                    // User is logged in - handle favorite
                                    // TODO: Add your favorite logic here
                                  }
                                },
                              ),
                            ),
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
