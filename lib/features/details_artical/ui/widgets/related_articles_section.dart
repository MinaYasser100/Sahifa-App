import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_horizontal_articles_list_section.dart';
import 'package:sahifa/features/home/data/repo/articles_home_category_repo.dart';
import 'package:sahifa/features/home/manger/articles_home_category_cubit/articles_home_category_cubit.dart';

class RelatedArticlesSection extends StatelessWidget {
  const RelatedArticlesSection({
    super.key,
    required this.categorySlug,
    required this.articleSlug,
  });
  final String categorySlug;
  final String articleSlug;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final language = LanguageHelper.getCurrentLanguageCode(context);

    return BlocProvider(
      create: (context) =>
          ArticlesHomeCategoryCubit(getIt<ArticlesHomeCategoryRepoImpl>())
            ..fetchArticlesHomeByCategory(categorySlug, language),
      child: BlocBuilder<ArticlesHomeCategoryCubit, ArticlesHomeCategoryState>(
        builder: (context, state) {
          // Check if we should show the section
          if (state is ArticlesHomeCategorySuccess) {
            final articles = state.articles;
            final filteredArticles = articles
                .where((article) => article.slug != articleSlug)
                .toList();

            // If no related articles after filtering, hide entire section
            if (filteredArticles.isEmpty) {
              return const SizedBox.shrink();
            }
          }

          // Show section with title and list
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Related Articles Placeholder'.tr(),
                  style: AppTextStyles.styleBold18sp(context).copyWith(
                    color: isDarkMode
                        ? ColorsTheme().secondaryLight
                        : ColorsTheme().primaryLight,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomHorizontalArticlesListSection(
                categorySlug: categorySlug,
                articleSlug: articleSlug,
              ),
            ],
          );
        },
      ),
    );
  }
}
