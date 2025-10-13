import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/artical_image.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';

import 'widgets/details_artical_content.dart';

class DetailsArticalView extends StatelessWidget {
  const DetailsArticalView({super.key, required this.articalModel});
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
              child: ArticalImage(imageUrl: articalModel.imageUrl, height: 300),
            ),

            // Content Section
            DetailsArticalContent(articalModel: articalModel),
          ],
        ),
      ),
    );
  }
}
