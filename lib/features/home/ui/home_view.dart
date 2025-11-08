import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/adaptive_layout.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/manager/banners_cubit/banners_cubit.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/repo/banner_repo.dart';
import 'package:sahifa/features/home/data/repo/articles_horizontal_bar_category.dart';
import 'package:sahifa/features/home/data/repo/categories_horizontal_bar_repo.dart';
import 'package:sahifa/features/home/manger/articles_horizontal_bar_category_cubit/articles_horizontal_bar_category_cubit.dart';
import 'package:sahifa/features/home/manger/cateogries_horizontal_bar_cubit/categories_horizontal_bar_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/home_mobile_view.dart';
import 'package:sahifa/features/home/ui/widgets/home_tablet_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final language = LanguageHelper.getCurrentLanguageCode(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              BannersCubit(getIt<BannerRepoImpl>())..fetchBanners(language),
        ),
        BlocProvider(
          create: (context) => ArticlesHorizontalBarCategoryCubit(
            getIt<ArticlesHorizontalBarCategoryRepoImpl>(),
          ),
        ),
        BlocProvider(
          create: (context) => CategoriesHorizontalBarCubit(
            getIt<CategoriesHorizontalBarRepoImpl>(),
          ),
        ),
      ],
      child: AdaptiveLayout(
        // Mobile Layout - مع Carousel عادي
        mobileLayout: (context) => const HomeMobileView(),

        // Tablet Layout - مع Horizontal List للبانرز و Grid للترندينج
        tabletLayout: (context) => const HomeTabletView(),

        // Desktop Layout - نفس الـ Tablet
        desktopLayout: (context) => const HomeTabletView(),
      ),
    );
  }
}
