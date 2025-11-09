import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/func/format_date.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_metadata.dart';

class ArticleTextContent extends StatelessWidget {
  const ArticleTextContent({
    super.key,
    required this.categoryName,
    required this.title,
    required this.publishedAt,
    required this.isDarkMode,
  });

  final String? categoryName;
  final String? title;
  final String? publishedAt;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInLeft(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  categoryName ?? '',
                  style: AppTextStyles.styleBold20sp(context).copyWith(
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
                  title ?? '',
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
        FadeInUp(
          child: MetadataItem(
            icon: FontAwesomeIcons.clock,
            text: formatDate(
              publishedAt != null
                  ? DateTime.parse(publishedAt!)
                  : DateTime.now(),
            ),
          ),
        ),
      ],
    );
  }
}
