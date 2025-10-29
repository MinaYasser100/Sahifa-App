import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/category_model/category_model.dart';
import 'package:sahifa/features/home/ui/widgets/home_app_bar.dart';
import 'package:sahifa/features/home/ui/widgets/home_body_view.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/categories_horizontal_bar.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/home_categories_veiw.dart';
import 'package:sahifa/features/home/ui/widgets/drawer/custom_home_drawer.dart';

class HomeMobileView extends StatefulWidget {
  const HomeMobileView({super.key});

  @override
  State<HomeMobileView> createState() => _HomeMobileViewState();
}

class _HomeMobileViewState extends State<HomeMobileView> {
  String _selectedCategoryId = 'home';
  String _selectedCategorySlug = 'home';

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return Scaffold(
      key: ValueKey(currentLocale.languageCode),
      drawer: CustomHomeDrawer(),
      appBar: HomeAppBar(),
      body: Column(
        children: [
          // Categories Horizontal Bar
          CategoriesHorizontalBar(
            selectedCategoryId: _selectedCategoryId,
            onCategoryTap: (CategoryFilterModel category) {
              setState(() {
                _selectedCategoryId = category.id;
                _selectedCategorySlug = category.slug;
              });
            },
          ),
          // Body Content
          Expanded(
            child: _selectedCategoryId == 'home'
                ? const HomeBodyView()
                : HomeCategoriesView(categorySlug: _selectedCategorySlug),
          ),
        ],
      ),
    );
  }
}
