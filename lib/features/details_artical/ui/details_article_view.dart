import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';
import 'package:share_plus/share_plus.dart';

import 'widgets/details_article_body_view.dart';

class DetailsArticleView extends StatelessWidget {
  const DetailsArticleView({super.key, required this.articalModel});
  final ArticleItemModel articalModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorsTheme().whiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _shareArticle();
            },
            icon: const Icon(FontAwesomeIcons.share),
          ),
        ],
      ),
      body: DetailsArticleBodyView(articalModel: articalModel),
    );
  }

  void _shareArticle() {
    final String shareText =
        '''
📰 ${articalModel.title}

${articalModel.description}

🗞️ صحيفة الثورة
''';

    Share.share(shareText, subject: articalModel.title);
  }
}
