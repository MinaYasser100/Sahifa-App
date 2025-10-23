import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/manger/cateogries_horizontal_bar_cubit/categories_horizontal_bar_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/categories_horizontal_bar_loading.dart'
    as loading_widget;
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/categories_horizontal_bar_error.dart'
    as error_widget;
import 'package:sahifa/features/search/data/category_model.dart';

class CategoriesHorizontalBar extends StatelessWidget {
  const CategoriesHorizontalBar({
    super.key,
    required this.selectedCategoryId,
    required this.onCategoryTap,
  });

  final String selectedCategoryId;
  final void Function(CategoryBarModel category) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final language = LanguageHelper.getCurrentLanguageCode(context);

    return BlocProvider(
      create: (context) {
        final cubit = CategoriesHorizontalBarCubit(getIt());
        cubit.fetchCategoriesHorizontalBar(language);
        return cubit;
      },
      child:
          BlocBuilder<
            CategoriesHorizontalBarCubit,
            CategoriesHorizontalBarState
          >(
            builder: (context, state) {
              if (state is CategoriesHorizontalBarLoading) {
                return const loading_widget.CategoriesHorizontalBarLoading();
              } else if (state is CategoriesHorizontalBarError) {
                return error_widget.CategoriesHorizontalBarError(
                  message: state.errorMessage,
                  onRetry: () {
                    final language = LanguageHelper.getCurrentLanguageCode(
                      context,
                    );
                    context
                        .read<CategoriesHorizontalBarCubit>()
                        .refreshCategoriesHorizontalBar(language);
                  },
                );
              } else if (state is CategoriesHorizontalBarLoaded) {
                final isDarkMode =
                    Theme.of(context).brightness == Brightness.dark;

                // الـ 3 عناصر الثابتة
                final List<CategoryBarModel> fixedCategories = [
                  CategoryBarModel(id: 'home', name: 'home'.tr(), slug: 'home'),
                  CategoryBarModel(
                    id: 'Breaking News',
                    name: 'Breaking News'.tr(),
                    slug: 'breaking-news',
                  ),
                  CategoryBarModel(
                    id: 'books_opinions',
                    name: 'books_opinions'.tr(),
                    slug: 'books_opinions',
                  ),
                ];

                // الـ API categories جايه جاهزة من الـ Cubit (filtered & sorted)
                final List<CategoryBarModel> apiCategoryModels = state
                    .categories
                    .map(
                      (category) => CategoryBarModel(
                        id: category.id.toString(),
                        name: category.name ?? '',
                        slug: category.slug ?? '',
                      ),
                    )
                    .toList();

                // دمج الـ fixed + API categories
                final allCategories = [
                  ...fixedCategories,
                  ...apiCategoryModels,
                ];

                return Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryDark
                        : ColorsTheme().primaryColor,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                      final category = allCategories[index];
                      final isSelected = selectedCategoryId == category.id;

                      return GestureDetector(
                        onTap: () {
                          onCategoryTap(category);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 8,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: isSelected
                                ? Border(
                                    bottom: BorderSide(
                                      color: ColorsTheme().whiteColor,
                                      style: BorderStyle.solid,
                                      width: 2,
                                    ),
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              category.name,
                              style: TextStyle(
                                color: ColorsTheme().whiteColor,
                                fontSize: 18,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              // Initial state
              return const loading_widget.CategoriesHorizontalBarLoading();
            },
          ),
    );
  }
}
