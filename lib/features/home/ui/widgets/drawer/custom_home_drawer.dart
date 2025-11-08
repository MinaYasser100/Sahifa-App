import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/home/data/repo/drawer_categories_repo.dart';
import 'package:sahifa/features/home/manger/drawer_categories_cubit/drawer_categories_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/drawer/drawer_categories_list.dart';
import 'package:sahifa/features/home/ui/widgets/drawer/drawer_categories_loading.dart'
    as loading_widget;
import 'package:sahifa/features/home/ui/widgets/drawer/drawer_header.dart';

class CustomHomeDrawer extends StatelessWidget {
  const CustomHomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final currentLanguage = LanguageHelper.getCurrentLanguageCode(context);

    return BlocProvider(
      create: (context) =>
          DrawerCategoriesCubit(getIt<DrawerCategoriesRepoImpl>())
            ..fetchDrawerCategories(currentLanguage),
      child: Drawer(
        backgroundColor: isDarkMode
            ? ColorsTheme().backgroundColor
            : ColorsTheme().whiteColor,
        child: Column(
          children: [
            // Drawer Header
            const CustomDrawerHeader(),

            // Categories Content - Controlled by BLoC
            BlocBuilder<DrawerCategoriesCubit, DrawerCategoriesState>(
              builder: (context, state) {
                // Loading State
                if (state is DrawerCategoriesLoading) {
                  return const loading_widget.DrawerCategoriesLoading();
                }

                // Error State
                if (state is DrawerCategoriesError) {
                  return Expanded(
                    child: CustomErrorLoadingWidget(
                      message: state.message,
                      onPressed: () {
                        context
                            .read<DrawerCategoriesCubit>()
                            .fetchDrawerCategories(currentLanguage);
                      },
                    ),
                  );
                }

                // Loaded State
                if (state is DrawerCategoriesLoaded) {
                  return DrawerCategoriesList(
                    categories: state.parentCategories,
                  );
                }

                // Initial State
                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
