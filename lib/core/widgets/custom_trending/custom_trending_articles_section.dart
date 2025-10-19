import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_trending/manager/trending_cubit/trending_cubit.dart';
import 'package:sahifa/core/widgets/custom_trending/repo/trending_repo.dart';
import 'package:sahifa/core/widgets/custom_trending/trending_article_card.dart';

class CustomTrendingArticlesSection extends StatelessWidget {
  const CustomTrendingArticlesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TrendingCubit(getIt<TrendingRepoImpl>())..fetchTrendingArticles(),
      child: const _CustomTrendingArticlesSectionBody(),
    );
  }
}

class _CustomTrendingArticlesSectionBody extends StatelessWidget {
  const _CustomTrendingArticlesSectionBody();

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

        // Trending Articles List with BLoC
        BlocBuilder<TrendingCubit, TrendingState>(
          builder: (context, state) {
            if (state is TrendingLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is TrendingError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: ColorsTheme().primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: AppTextStyles.styleRegular14sp(context),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<TrendingCubit>().fetchTrendingArticles();
                        },
                        child: Text('retry'.tr()),
                      ),
                    ],
                  ),
                ),
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
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
