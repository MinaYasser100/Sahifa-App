import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/utils/auth_checker.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_book_opinion_image.dart';
import 'package:sahifa/core/widgets/custom_image_widget.dart';
import 'package:sahifa/core/widgets/custom_trending/custom_mobile_trending_articles_section_body.dart';
import 'package:sahifa/features/details_artical/ui/widgets/comments/comments_section.dart';
import 'package:sahifa/features/details_artical/ui/widgets/details_article_content.dart';
import 'package:sahifa/features/details_artical/ui/widgets/related_articles_section.dart';

class DetailsArticleBodyView extends StatelessWidget {
  const DetailsArticleBodyView({super.key, required this.articalModel});

  final ArticleModel articalModel;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Article Image
        SliverToBoxAdapter(
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
                          height: 300,
                          changeBorderRadius: true,
                        ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: FadeInDown(
                    child: CircleAvatar(
                      backgroundColor: ColorsTheme().whiteColor.withValues(
                        alpha: 0.8,
                      ),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.heart,
                          color: ColorsTheme().primaryColor,
                        ),
                        onPressed: () async {
                          // Check authentication before like
                          if (await AuthChecker.checkAuthAndNavigate(context)) {
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

        // Content Section
        SliverToBoxAdapter(
          child: DetailsArticleContent(articalModel: articalModel),
        ),

        // Comments Section
        SliverToBoxAdapter(child: CommentsSection()),

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
