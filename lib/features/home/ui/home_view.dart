import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item_card.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/repo/banner_repo.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/manager/banners_cubit/banners_cubit.dart';
import 'package:sahifa/features/details_artical/data/local_data.dart';
import 'package:sahifa/features/home/ui/widgets/custom_home_drawer.dart';
import 'package:sahifa/features/home/ui/widgets/home_app_bar.dart';
import 'package:sahifa/features/home/ui/widgets/home_body_view.dart';
import 'package:sahifa/features/home/ui/widgets/categories_horizontal_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _selectedCategoryId = 'home';

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return BlocProvider(
      create: (context) =>
          BannersCubit(getIt<BannerRepoImpl>())..fetchBanners(),
      child: Scaffold(
        key: ValueKey(currentLocale.languageCode),
        drawer: CustomHomeDrawer(),
        appBar: HomeAppBar(),
        body: Column(
          children: [
            // Categories Horizontal Bar
            CategoriesHorizontalBar(
              selectedCategoryId: _selectedCategoryId,
              onCategoryTap: (categoryId, categoryName) {
                setState(() {
                  _selectedCategoryId = categoryId;
                });
              },
            ),
            // Body Content
            Expanded(
              child: _selectedCategoryId == 'home'
                  ? HomeBodyView()
                  : const HomeCategoryView(),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeCategoryView extends StatelessWidget {
  const HomeCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    context.push(
                      Routes.detailsArticalView,
                      extra: trendingArticles[index],
                    );
                  },
                  child: CustomArticleItemCard(
                    articleItem: trendingArticles[index],
                    cardWidth: double.infinity,
                    isItemList: true,
                  ),
                ),
              );
            }, childCount: trendingArticles.length),
          ),
        ),
      ],
    );
  }
}
