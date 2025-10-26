import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/details_artical/ui/data/repo/details_article_repo.dart';
import 'package:sahifa/features/details_artical/ui/manager/cubit/details_article_cubit.dart';
import 'package:share_plus/share_plus.dart';

import 'widgets/details_article_body_view.dart';
import 'widgets/details_article_loading_widget.dart';

class DetailsArticleView extends StatelessWidget {
  const DetailsArticleView({super.key, required this.articalModel});
  final ArticleModel articalModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsArticleCubit(getIt<DetailsArticleRepoImpl>())
        ..fetchArticleDetails(
          articleSlug: articalModel.slug!,
          categorySlug: articalModel.categorySlug!,
        ),
      child: Scaffold(
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
        body: BlocBuilder<DetailsArticleCubit, DetailsArticleState>(
          builder: (context, state) {
            if (state is DetailsArticleLoading) {
              return const DetailsArticleLoadingWidget();
            } else if (state is DetailsArticleError) {
              return CustomErrorLoadingWidget(
                message: state.message,
                onPressed: () {
                  context.read<DetailsArticleCubit>().fetchArticleDetails(
                    articleSlug: articalModel.slug!,
                    categorySlug: articalModel.categorySlug!,
                  );
                },
              );
            } else if (state is DetailsArticleLoaded) {
              return DetailsArticleBodyView(articalModel: state.article);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  void _shareArticle() {
    final String shareText =
        '''
📰 ${articalModel.title ?? ''}

${articalModel.summary ?? ''}

🗞️ صحيفة الثورة
''';

    Share.share(shareText, subject: articalModel.title ?? '');
  }
}
