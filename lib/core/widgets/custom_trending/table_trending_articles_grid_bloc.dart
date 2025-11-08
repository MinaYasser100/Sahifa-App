import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/widgets/custom_trending/manager/trending_cubit/trending_cubit.dart';

import 'tablet_trending_article_card.dart';

class TabletTrendingArticlesGridBloc extends StatelessWidget {
  const TabletTrendingArticlesGridBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrendingCubit, TrendingState>(
      builder: (context, state) {
        if (state is TrendingLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is TrendingError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                state.message,
                style: AppTextStyles.styleRegular14sp(context),
              ),
            ),
          );
        } else if (state is TrendingLoaded) {
          final articles = state.articles;
          if (articles.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'no_trending_articles'.tr(),
                  style: AppTextStyles.styleRegular14sp(context),
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.push(
                      Routes.detailsArticalView,
                      extra: articles[index],
                    );
                  },
                  child: TabletTrendingArticleCard(
                    articleItem: articles[index],
                    index: index,
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
