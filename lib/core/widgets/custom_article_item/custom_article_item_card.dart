import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_image.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_content.dart';

class CustomArticleItemCard extends StatelessWidget {
  const CustomArticleItemCard({
    super.key,
    required this.articleItem,
    this.cardWidth = 280,
    this.isItemList = false,
  });

  final ArticleModel articleItem;
  final double cardWidth;
  final bool isItemList;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 325,
      child: FadeInLeft(
        child: Container(
          width: cardWidth,
          margin: EdgeInsets.only(left: isItemList ? 0 : 12, bottom: 10),
          decoration: BoxDecoration(
            color: isDarkMode
                ? ColorsTheme().primaryDark
                : ColorsTheme().whiteColor,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  CustomArticleImage(
                    imageUrl: articleItem.image ?? '',
                    height: 180,
                  ),
                  // Content Section
                  CustomArticleItemContent(articleItem: articleItem),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    // Handle favorite icon tap
                  },
                  child: FadeInDown(
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: ColorsTheme().whiteColor,
                      child: Icon(
                        FontAwesomeIcons.heart,
                        color: ColorsTheme().primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
