import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/details_artical/ui/data/repo/details_article_repo.dart';
import 'package:sahifa/features/details_artical/ui/manager/cubit/details_article_cubit.dart';
import 'package:share_plus/share_plus.dart';

import 'widgets/details_article_body_view.dart';
import 'widgets/details_article_loading_widget.dart';
import 'widgets/tablet_details_article_body.dart';
import 'widgets/tablet_details_article_skeleton.dart';

class DetailsArticleView extends StatefulWidget {
  const DetailsArticleView({super.key, required this.articalModel});
  final ArticleModel articalModel;

  @override
  State<DetailsArticleView> createState() => _DetailsArticleViewState();
}

class _DetailsArticleViewState extends State<DetailsArticleView> {
  late final DetailsArticleCubit _cubit;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _cubit = DetailsArticleCubit(getIt<DetailsArticleRepoImpl>());
    // Fetch immediately in initState
    _fetchData();
  }

  void _fetchData() {
    if (!_isDisposed && mounted && !_cubit.isClosed) {
      _cubit.fetchArticleDetails(
        articleSlug: widget.articalModel.slug!,
        categorySlug: widget.articalModel.categorySlug!,
      );
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
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
              final isTablet = ResponsiveHelper.isTablet(context);
              return isTablet
                  ? const TabletDetailsArticleSkeleton()
                  : const DetailsArticleLoadingWidget();
            } else if (state is DetailsArticleError) {
              return CustomErrorLoadingWidget(
                message: state.message,
                onPressed: () {
                  context.read<DetailsArticleCubit>().fetchArticleDetails(
                    articleSlug: widget.articalModel.slug!,
                    categorySlug: widget.articalModel.categorySlug!,
                  );
                },
              );
            } else if (state is DetailsArticleLoaded) {
              final isTablet = ResponsiveHelper.isTablet(context);
              return isTablet
                  ? TabletDetailsArticleBody(articalModel: state.article)
                  : DetailsArticleBodyView(articalModel: state.article);
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
📰 ${widget.articalModel.title ?? ''}

${widget.articalModel.summary ?? ''}

🗞️ صحيفة الثورة
''';

    Share.share(shareText, subject: widget.articalModel.title ?? '');
  }
}
