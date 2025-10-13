import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_article_image.dart';
import 'package:sahifa/core/widgets/custom_horizontal_articles_list_section.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';

import 'widgets/details_article_content.dart';

class DetailsArticleView extends StatelessWidget {
  const DetailsArticleView({super.key, required this.articalModel});
  final ArticalItemModel articalModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsTheme().primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Share functionality
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image
            Hero(
              tag: 'article_${articalModel.imageUrl}',
              child: CustomArticleImage(
                imageUrl: articalModel.imageUrl,
                height: 300,
              ),
            ),

            // Content Section
            DetailsArticleContent(articalModel: articalModel),
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
        ),
      ),
    );
  }
}
