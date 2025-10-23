import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/model/category_model/category_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/search/ui/manager/search_cateories_cubit/search_categories_cubit.dart';
import 'package:sahifa/features/search/ui/widgets/categories_grid_loading.dart';
import 'package:sahifa/features/search/ui/widgets/category_card.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final language = LanguageHelper.getCurrentLanguageCode(context);

    return BlocProvider(
      create: (context) {
        final cubit = SearchCategoriesCubit(getIt());
        cubit.fetchSearchCategories(language);
        return cubit;
      },
      child: BlocBuilder<SearchCategoriesCubit, SearchCategoriesState>(
        builder: (context, state) {
          if (state is SearchCategoriesLoading) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Al-Thawra Archive - دايماً موجودة
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: FadeInLeft(
                    child: CategoryCard(
                      categoryName: 'altharwa_archive'.tr(),
                      isLarge: true,
                      onTap: () {
                        context.push(Routes.alThawraArchiveView);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Loading skeleton
                const CategoriesGridLoading(),
              ],
            );
          } else if (state is SearchCategoriesError) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Al-Thawra Archive - دايماً موجودة
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: FadeInLeft(
                    child: CategoryCard(
                      categoryName: 'altharwa_archive'.tr(),
                      isLarge: true,
                      onTap: () {
                        context.push(Routes.alThawraArchiveView);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Error with retry
                CustomErrorLoadingWidget(
                  message: state.errorMessage,
                  onPressed: () {
                    final lang = LanguageHelper.getCurrentLanguageCode(context);
                    context
                        .read<SearchCategoriesCubit>()
                        .refreshSearchCategories(lang);
                  },
                ),
              ],
            );
          } else if (state is SearchCategoriesLoaded) {
            // الـ categories جايه جاهزة من الـ Cubit (filtered & sorted)
            final List<CategoryFilterModel> categories = state.categories
                .map(
                  (category) => CategoryFilterModel(
                    id: category.id.toString(),
                    name: category.name ?? '',
                    slug: category.slug ?? '',
                  ),
                )
                .toList();

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Al-Thawra Archive - Large Category (full width)
                  FadeInLeft(
                    child: CategoryCard(
                      categoryName: 'altharwa_archive'.tr(),
                      isLarge: true,
                      onTap: () {
                        context.push(Routes.alThawraArchiveView);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // API Categories Grid
                  categories.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'no_categories_available'.tr(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1,
                              ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return CategoryCard(
                              categoryName: category.name,
                              onTap: () {
                                context.push(
                                  Routes.searchCategoryView,
                                  extra: category,
                                );
                              },
                            );
                          },
                        ),
                ],
              ),
            );
          }

          // Initial state - show archive + loading
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: FadeInLeft(
                  child: CategoryCard(
                    categoryName: 'altharwa_archive'.tr(),
                    isLarge: true,
                    onTap: () {
                      context.push(Routes.alThawraArchiveView);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const CategoriesGridLoading(),
            ],
          );
        },
      ),
    );
  }
}
