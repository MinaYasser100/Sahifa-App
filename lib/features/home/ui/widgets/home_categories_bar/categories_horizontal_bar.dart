import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/features/home/manger/cateogries_horizontal_bar_cubit/categories_horizontal_bar_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/categories_horizontal_bar_loading.dart'
    as loading_widget;
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/categories_horizontal_bar_error.dart'
    as error_widget;
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/categories_horizontal_bar_content.dart';
import 'package:sahifa/core/model/category_model/category_model.dart';

class CategoriesHorizontalBar extends StatelessWidget {
  const CategoriesHorizontalBar({
    super.key,
    required this.selectedCategoryId,
    required this.onCategoryTap,
  });

  final String selectedCategoryId;
  final void Function(CategoryFilterModel category) onCategoryTap;

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
                return CategoriesHorizontalBarContent(
                  categories: state.categories,
                  selectedCategoryId: selectedCategoryId,
                  onCategoryTap: onCategoryTap,
                );
              }

              // Initial state
              return const loading_widget.CategoriesHorizontalBarLoading();
            },
          ),
    );
  }
}
