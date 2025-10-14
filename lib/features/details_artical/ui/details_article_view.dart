import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';

import 'widgets/details_article_body_view.dart';

class DetailsArticleView extends StatelessWidget {
  const DetailsArticleView({super.key, required this.articalModel});
  final ArticalItemModel articalModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorsTheme().whiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Share functionality
            },
            icon: const Icon(FontAwesomeIcons.share),
          ),
        ],
      ),
      body: DetailsArticleBodyView(articalModel: articalModel),
    );
  }
}
