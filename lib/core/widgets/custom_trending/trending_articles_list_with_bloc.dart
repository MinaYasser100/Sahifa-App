import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/core/widgets/custom_trending/manager/trending_cubit/trending_cubit.dart';
import 'package:sahifa/core/widgets/custom_trending/trending_article_card.dart';

class TrendingArticlesListWithBLoC extends StatelessWidget {
  const TrendingArticlesListWithBLoC({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrendingCubit, TrendingState>(
      builder: (context, state) {
        final language = LanguageHelper.getCurrentLanguageCode(context);
        if (state is TrendingLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is TrendingError) {
          return CustomErrorLoadingWidget(
            message: state.message,
            onPressed: () {
              context.read<TrendingCubit>().fetchTrendingArticles(language);
            },
          );
        }

        if (state is TrendingLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: state.articles.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  context.push(
                    Routes.detailsArticalView,
                    extra: state.articles[index],
                  );
                },
                child: TrendingArticleCard(
                  articleItem: state.articles[index],
                  index: index,
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
