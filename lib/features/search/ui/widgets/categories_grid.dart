import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/model/category_model/category_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/features/search/ui/manager/search_cateories_cubit/search_categories_cubit.dart';
import 'package:sahifa/features/search/ui/widgets/categories_grid_widgets/categories_grid_content.dart';
import 'package:sahifa/features/search/ui/widgets/categories_grid_widgets/categories_grid_error_section.dart';
import 'package:sahifa/features/search/ui/widgets/categories_grid_widgets/categories_grid_loading_section.dart';

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
          // Loading State
          if (state is SearchCategoriesLoading) {
            return const CategoriesGridLoadingSection();
          }

          // Error State
          if (state is SearchCategoriesError) {
            return CategoriesGridErrorSection(errorMessage: state.errorMessage);
          }

          // Loaded State
          if (state is SearchCategoriesLoaded) {
            final categories = state.categories
                .map(
                  (category) => CategoryFilterModel(
                    id: category.id.toString(),
                    name: category.name ?? '',
                    slug: category.slug ?? '',
                  ),
                )
                .toList();

            return CategoriesGridContent(categories: categories);
          }

          // Initial/Default State
          return const CategoriesGridLoadingSection();
        },
      ),
    );
  }
}
