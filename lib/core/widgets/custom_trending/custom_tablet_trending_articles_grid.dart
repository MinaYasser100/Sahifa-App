import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_trending/manager/trending_cubit/trending_cubit.dart';
import 'package:sahifa/core/widgets/custom_trending/repo/trending_repo.dart';
import 'package:sahifa/core/widgets/custom_trending/tablet_trending_article_card.dart';

class CustomTabletTrendingArticlesGrid extends StatelessWidget {
  const CustomTabletTrendingArticlesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final language = LanguageHelper.getCurrentLanguageCode(context);
    return BlocProvider(
      create: (context) =>
          TrendingCubit(getIt<TrendingRepoImpl>())
            ..fetchTrendingArticles(language),
      child: const _TabletTrendingArticlesGridBody(),
    );
  }
}

class _TabletTrendingArticlesGridBody extends StatelessWidget {
  const _TabletTrendingArticlesGridBody();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: Row(
            children: [
              Icon(
                Icons.trending_up,
                color: isDarkMode
                    ? ColorsTheme().whiteColor
                    : ColorsTheme().primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              FadeInLeft(
                child: Text(
                  'trending_now'.tr(),
                  style: AppTextStyles.styleBold18sp(context).copyWith(
                    color: isDarkMode
                        ? ColorsTheme().whiteColor
                        : ColorsTheme().primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Trending Articles Grid with BLoC
        BlocBuilder<TrendingCubit, TrendingState>(
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
                    childAspectRatio: 2.3,
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
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
