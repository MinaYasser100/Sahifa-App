import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_trending/manager/trending_cubit/trending_cubit.dart';
import 'package:sahifa/core/widgets/custom_trending/repo/trending_repo.dart';

import 'trending_mobile_articles_list_with_bloc.dart';

class CustomMobileTrendingArticlesSectionBody extends StatelessWidget {
  const CustomMobileTrendingArticlesSectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final language = LanguageHelper.getCurrentLanguageCode(context);

    return BlocProvider(
      create: (context) =>
          TrendingCubit(getIt<TrendingRepoImpl>())
            ..fetchTrendingArticles(language),
      child: Column(
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
          TrendingMobileArticlesListWithBLoC(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
