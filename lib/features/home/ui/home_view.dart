import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/repo/banner_repo.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/manager/banners_cubit/banners_cubit.dart';
import 'package:sahifa/features/search/data/category_model.dart';
import 'package:sahifa/features/home/ui/widgets/drawer/custom_home_drawer.dart';
import 'package:sahifa/features/home/ui/widgets/home_app_bar.dart';
import 'package:sahifa/features/home/ui/widgets/home_body_view.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/categories_horizontal_bar.dart';

import 'widgets/home_categories_bar/home_categories_veiw.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _selectedCategoryId = 'home';

  @override
  Widget build(BuildContext context) {
    final language = LanguageHelper.getCurrentLanguageCode(context);
    final currentLocale = context.locale;
    return BlocProvider(
      create: (context) =>
          BannersCubit(getIt<BannerRepoImpl>())..fetchBanners(language),
      child: Scaffold(
        key: ValueKey(currentLocale.languageCode),
        drawer: CustomHomeDrawer(),
        appBar: HomeAppBar(),
        body: Column(
          children: [
            // Categories Horizontal Bar
            CategoriesHorizontalBar(
              selectedCategoryId: _selectedCategoryId,
              onCategoryTap: (CategoryModel category) {
                setState(() {
                  _selectedCategoryId = category.id;
                });
              },
            ),
            // Body Content
            Expanded(
              child: _selectedCategoryId == 'home'
                  ? HomeBodyView()
                  : HomeCategoriesView(categoryId: _selectedCategoryId),
            ),
          ],
        ),
      ),
    );
  }
}
