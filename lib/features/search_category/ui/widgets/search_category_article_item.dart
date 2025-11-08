import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_card.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_books_opinions.dart';

class SearchCategoryArticleItem extends StatelessWidget {
  const SearchCategoryArticleItem({
    super.key,
    required this.articleItem,
    required this.isBookOpinion,
  });

  final ArticleModel articleItem;
  final bool isBookOpinion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          context.push(Routes.detailsArticalView, extra: articleItem);
        },
        child: isBookOpinion
            ? CustomBooksOpinionsItem(
                articleItem: articleItem,
                cardWidth: double.infinity,
                isItemList: true,
              )
            : CustomArticleItemCard(
                articleItem: articleItem,
                cardWidth: double.infinity,
                isItemList: true,
              ),
      ),
    );
  }
}
