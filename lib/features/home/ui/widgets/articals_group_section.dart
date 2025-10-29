import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/features/home/data/repo/articles_home_category_repo.dart';
import 'package:sahifa/features/home/manger/articles_home_category_cubit/articles_home_category_cubit.dart';

import '../../../../core/widgets/custom_horizontal_articles_list_section.dart';

class ArticalsGroupSection extends StatelessWidget {
  const ArticalsGroupSection({
    super.key,
    required this.parentCategory,
  });

  final ParentCategory parentCategory;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final language = LanguageHelper.getCurrentLanguageCode(context);

    return BlocProvider(
      create: (context) =>
          ArticlesHomeCategoryCubit(getIt<ArticlesHomeCategoryRepoImpl>())
            ..fetchArticlesHomeByCategory(parentCategory.slug ?? '', language),
      child: BlocBuilder<ArticlesHomeCategoryCubit, ArticlesHomeCategoryState>(
        builder: (context, state) {
          // Check if we should show the section
          if (state is ArticlesHomeCategorySuccess) {
            final articles = state.articles;

            // If no articles, hide entire section
            if (articles.isEmpty) {
              return const SizedBox.shrink();
            }
          }

          // Show section with title and list
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  context.push(
                    Routes.articalsCategorySectionView,
                    extra: parentCategory,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    children: [
                      Text(
                        parentCategory.name ?? 'Category'.tr(),
                        style: AppTextStyles.styleBold24sp(context).copyWith(
                          color: isDarkMode
                              ? ColorsTheme().whiteColor
                              : ColorsTheme().primaryColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: isDarkMode
                            ? ColorsTheme().whiteColor
                            : ColorsTheme().primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              CustomHorizontalArticlesListSection(
                categorySlug: parentCategory.slug ?? '',
              ),
            ],
          );
        },
      ),
    );
  }
}
