import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/model/category_model/category_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_audio_magazine_section/custom_audio_magazine_section.dart';
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
                // Audio Magazine Section
                const CustomAudioMagazineSection(notMargin: true),
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
                      ? const CustomAudioMagazineSection(notMargin: true)
                      : _buildCategoriesWithAudioMagazine(context, categories),
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
              // Audio Magazine Section
              const CustomAudioMagazineSection(notMargin: true),
              const SizedBox(height: 16),
              const CategoriesGridLoading(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoriesWithAudioMagazine(
    BuildContext context,
    List<CategoryFilterModel> categories,
  ) {
    // بناء الـ Grid مع إضافة AudioMagazineSection بعد أول صفين
    return Column(
      children: [
        // First row (2 items)
        if (categories.isNotEmpty)
          Row(
            children: [
              Expanded(
                child: CategoryCard(
                  categoryName: categories[0].name,
                  onTap: () {
                    context.push(
                      Routes.searchCategoryView,
                      extra: categories[0],
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              if (categories.length > 1)
                Expanded(
                  child: CategoryCard(
                    categoryName: categories[1].name,
                    onTap: () {
                      context.push(
                        Routes.searchCategoryView,
                        extra: categories[1],
                      );
                    },
                  ),
                )
              else
                const Expanded(child: SizedBox()),
            ],
          ),

        // Audio Magazine Section بعد أول صفين
        const CustomAudioMagazineSection(notMargin: true),

        // باقي الـ Grid items
        if (categories.length > 2)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: categories.length - 2,
            itemBuilder: (context, index) {
              final category = categories[index + 2]; // Start from 3rd item
              return CategoryCard(
                categoryName: category.name,
                onTap: () {
                  context.push(Routes.searchCategoryView, extra: category);
                },
              );
            },
          ),
      ],
    );
  }
}
