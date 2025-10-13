import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_horizontal_articles_list_section.dart';

class RelatedArticlesSection extends StatelessWidget {
  const RelatedArticlesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Related Articles Placeholder',
            style: AppTextStyles.styleBold18sp(
              context,
            ).copyWith(color: ColorsTheme().primaryLight),
          ),
        ), // Placeholder for related articles
        SizedBox(height: 10),
        CustomHorizontalArticlesListSection(),
      ],
    );
  }
}
