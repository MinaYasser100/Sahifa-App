import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/func/format_date.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_metadata.dart';

class CustomBooksOpinionsArticleContent extends StatelessWidget {
  const CustomBooksOpinionsArticleContent({
    super.key,
    required this.articleItem,
  });

  final ArticleModel articleItem;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: FadeInRight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              articleItem.authorImage ?? '',
                            ),
                            radius: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              articleItem.authorName ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode
                                    ? ColorsTheme().secondaryLight
                                    : ColorsTheme().secondaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle share action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Share functionality will be implemented'.tr(),
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: FadeInDown(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(
                          backgroundColor: isDarkMode
                              ? ColorsTheme().whiteColor.withValues(alpha: 0.3)
                              : ColorsTheme().grayColor.withValues(alpha: 0.3),
                          radius: 15,
                          child: Icon(
                            FontAwesomeIcons.share,
                            size: 14,
                            color: isDarkMode
                                ? ColorsTheme().secondaryLight
                                : ColorsTheme().primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                context.push(Routes.detailsArticalView, extra: articleItem);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInLeft(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            articleItem.categoryName ?? '',
                            style: AppTextStyles.styleBold20sp(context)
                                .copyWith(
                                  color: isDarkMode
                                      ? ColorsTheme().secondaryLight
                                      : ColorsTheme().primaryDark,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FadeInLeft(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            articleItem.title ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? ColorsTheme().secondaryLight
                                  : ColorsTheme().secondaryColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // التاريخ و عدد المشاهدين
                  FadeInUp(
                    child: MetadataItem(
                      icon: FontAwesomeIcons.clock,
                      text: formatDate(
                        articleItem.publishedAt != null
                            ? DateTime.parse(articleItem.publishedAt!)
                            : DateTime.now(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
