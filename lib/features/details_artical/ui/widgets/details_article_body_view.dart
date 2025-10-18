import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_article_image.dart';
import 'package:sahifa/core/widgets/custom_trending/custom_trending_articles_section.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';

import 'comments_section.dart';
import 'details_article_content.dart';
import 'related_articles_section.dart';

class DetailsArticleBodyView extends StatelessWidget {
  const DetailsArticleBodyView({super.key, required this.articalModel});

  final ArticleItemModel articalModel;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Article Image
        SliverToBoxAdapter(
          child: Hero(
            tag: 'article_${articalModel.imageUrl}',
            child: Stack(
              children: [
                FadeIn(
                  child: CustomArticleImage(
                    imageUrl: articalModel.imageUrl,
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
                        alpha: 0.3,
                      ),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.heart,
                          color: ColorsTheme().primaryColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
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
        SliverToBoxAdapter(child: RelatedArticlesSection()),

        // Trending Articles Section
        SliverToBoxAdapter(child: CustomTrendingArticlesSection()),
      ],
    );
  }
}
