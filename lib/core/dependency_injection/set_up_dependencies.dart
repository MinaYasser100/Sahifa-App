import 'package:get_it/get_it.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/repo/banner_repo.dart';
import 'package:sahifa/core/widgets/custom_trending/repo/trending_repo.dart';
import 'package:sahifa/core/widgets/custom_video_banner_carousel/repo/video_banner_repo.dart';
import 'package:sahifa/features/altharwa_archive/data/repo/magazines_repo.dart';
import 'package:sahifa/features/auth/data/repo/auth_repo.dart';
import 'package:sahifa/features/auth/data/repo/auth_repo_impl.dart';
import 'package:sahifa/features/auth/manager/auth_cubit/auth_cubit.dart';
import 'package:sahifa/core/widgets/custom_trending/manager/trending_cubit/trending_cubit.dart';
import 'package:sahifa/features/articals_category_section/data/repo/all_category_articles_repo.dart';
import 'package:sahifa/features/articals_category_section/data/repo/horizontal_bar_subcategories.dart';
import 'package:sahifa/features/articals_category_section/data/repo/subcategory_articles_repo.dart';
import 'package:sahifa/features/details_artical/ui/data/repo/details_article_repo.dart';
import 'package:sahifa/features/home/data/repo/articles_books_opinions_bar_category_repo.dart';
import 'package:sahifa/features/video_details/data/repo/details_video_repo.dart';
import 'package:sahifa/features/home/data/repo/articles_breaking_news_repo.dart';
import 'package:sahifa/features/home/data/repo/articles_drawer_subcategory_repo.dart';
import 'package:sahifa/features/home/data/repo/articles_home_category_repo.dart';
import 'package:sahifa/features/home/data/repo/articles_horizontal_bar_category.dart';
import 'package:sahifa/features/home/data/repo/categories_horizontal_bar_repo.dart';
import 'package:sahifa/features/home/data/repo/drawer_categories_repo.dart';
import 'package:sahifa/features/my_favorites/data/repo/my_favorite_repo.dart';
import 'package:sahifa/features/pdf/data/repo/pdf_repo.dart';
import 'package:sahifa/features/search/data/repo/search_articles_repo.dart';
import 'package:sahifa/features/search/data/repo/search_categories_repo.dart';
import 'package:sahifa/features/search_category/data/repo/articles_search_category_repo.dart';
import 'package:sahifa/features/tv/data/repo/tv_repo.dart';

final getIt = GetIt.instance;

void setupDependencies() async {
  getIt.registerSingleton<DioHelper>(DioHelper());
  getIt.registerSingleton<BannerRepoImpl>(BannerRepoImpl());
  getIt.registerSingleton<VideoBannerRepoImpl>(VideoBannerRepoImpl());
  getIt.registerSingleton<TrendingRepoImpl>(TrendingRepoImpl());
  getIt.registerSingleton<TVRepoImpl>(TVRepoImpl());

  // Register MagazinesRepo as abstract type with implementation
  final magazinesRepo = MagazinesRepoImpl();
  getIt.registerSingleton<MagazinesRepoImpl>(magazinesRepo);
  getIt.registerSingleton<MagazinesRepo>(magazinesRepo);

  // Register PdfRepo as abstract type with implementation
  final pdfRepo = PdfRepoImpl(getIt<DioHelper>());
  getIt.registerSingleton<PdfRepoImpl>(pdfRepo);
  getIt.registerSingleton<PdfRepo>(pdfRepo);

  // Register MyFavoriteRepo as abstract type with implementation
  final myFavoriteRepo = MyFavoriteRepoImpl();
  getIt.registerSingleton<MyFavoriteRepoImpl>(myFavoriteRepo);
  getIt.registerSingleton<MyFavoriteRepo>(myFavoriteRepo);

  // Register DrawerCategoriesRepo as abstract type with implementation
  final drawerCategoriesRepo = DrawerCategoriesRepoImpl(getIt<DioHelper>());
  getIt.registerSingleton<DrawerCategoriesRepoImpl>(drawerCategoriesRepo);
  getIt.registerSingleton<DrawerCategoriesRepo>(drawerCategoriesRepo);

  // Register CategoriesHorizontalBarRepo as abstract type with implementation
  final categoriesHorizontalBarRepo = CategoriesHorizontalBarRepoImpl(
    getIt<DioHelper>(),
  );
  getIt.registerSingleton<CategoriesHorizontalBarRepoImpl>(
    categoriesHorizontalBarRepo,
  );
  getIt.registerSingleton<CategoriesHorizontalBarRepo>(
    categoriesHorizontalBarRepo,
  );

  // Register SearchCategoriesRepo as abstract type with implementation
  final searchCategoriesRepo = SearchCategoriesRepoImpl(getIt<DioHelper>());
  getIt.registerSingleton<SearchCategoriesRepoImpl>(searchCategoriesRepo);
  getIt.registerSingleton<SearchCategoriesRepo>(searchCategoriesRepo);

  // Register ArticlesDrawerSubcategoryRepo as singleton
  final articlesDrawerSubcategoryRepo = ArticlesDrawerSubcategoryRepoImpl();
  getIt.registerSingleton<ArticlesDrawerSubcategoryRepoImpl>(
    articlesDrawerSubcategoryRepo,
  );
  getIt.registerSingleton<ArticlesDrawerSubcategoryRepo>(
    articlesDrawerSubcategoryRepo,
  );

  // Register ArticlesHorizontalBarCategoryRepo as singleton
  final articlesHorizontalBarCategoryRepo =
      ArticlesHorizontalBarCategoryRepoImpl(getIt<DioHelper>());
  getIt.registerSingleton<ArticlesHorizontalBarCategoryRepoImpl>(
    articlesHorizontalBarCategoryRepo,
  );
  getIt.registerSingleton<ArticlesHorizontalBarCategoryRepo>(
    articlesHorizontalBarCategoryRepo,
  );

  // Register ArticlesHomeCategoryRepo as singleton
  final articlesHomeCategoryRepo = ArticlesHomeCategoryRepoImpl(
    getIt<DioHelper>(),
  );
  getIt.registerSingleton<ArticlesHomeCategoryRepoImpl>(
    articlesHomeCategoryRepo,
  );
  getIt.registerSingleton<ArticlesHomeCategoryRepo>(articlesHomeCategoryRepo);

  // Register ArticlesSearchCategoryRepo as singleton
  final articlesSearchCategoryRepo = ArticlesSearchCategoryRepoImpl(
    getIt<DioHelper>(),
  );
  getIt.registerSingleton<ArticlesSearchCategoryRepoImpl>(
    articlesSearchCategoryRepo,
  );
  getIt.registerSingleton<ArticlesSearchCategoryRepo>(
    articlesSearchCategoryRepo,
  );

  // Register HorizontalBarSubcategoriesRepo as singleton
  final horizontalBarSubcategoriesRepo = HorizontalBarSubcategoriesRepoImpl(
    getIt<DioHelper>(),
  );
  getIt.registerSingleton<HorizontalBarSubcategoriesRepoImpl>(
    horizontalBarSubcategoriesRepo,
  );
  getIt.registerSingleton<HorizontalBarSubcategoriesRepo>(
    horizontalBarSubcategoriesRepo,
  );

  // Register AllCategoryArticlesRepo as singleton
  final allCategoryArticlesRepo = AllCategoryArticlesRepoImpl(
    getIt<DioHelper>(),
  );
  getIt.registerSingleton<AllCategoryArticlesRepoImpl>(allCategoryArticlesRepo);
  getIt.registerSingleton<AllCategoryArticlesRepo>(allCategoryArticlesRepo);

  // Register SubcategoryArticlesRepo as singleton
  final subcategoryArticlesRepo = SubcategoryArticlesRepoImpl();
  getIt.registerSingleton<SubcategoryArticlesRepoImpl>(subcategoryArticlesRepo);
  getIt.registerSingleton<SubcategoryArticlesRepo>(subcategoryArticlesRepo);

  // Register ArticlesBreakingNewsRepo as singleton
  final articlesBreakingNewsRepo = ArticlesBreakingNewsRepoImpl(
    getIt<DioHelper>(),
  );
  getIt.registerSingleton<ArticlesBreakingNewsRepoImpl>(
    articlesBreakingNewsRepo,
  );
  getIt.registerSingleton<ArticlesBreakingNewsRepo>(articlesBreakingNewsRepo);

  getIt.registerSingleton<DetailsArticleRepoImpl>(
    DetailsArticleRepoImpl(getIt<DioHelper>()),
  );

  getIt.registerSingleton<DetailsVideoRepoImpl>(
    DetailsVideoRepoImpl(getIt<DioHelper>()),
  );

  getIt.registerSingleton<SearchArticlesRepoImpl>(
    SearchArticlesRepoImpl(getIt<DioHelper>()),
  );

  // Register Auth Repo as singleton
  final authRepo = AuthRepoImpl(getIt<DioHelper>());
  getIt.registerSingleton<AuthRepoImpl>(authRepo);
  getIt.registerSingleton<AuthRepo>(authRepo);

  // Register AuthCubit as singleton (Global state)
  getIt.registerSingleton<AuthCubit>(AuthCubit(getIt<AuthRepo>()));

  // Register TrendingCubit as singleton
  getIt.registerSingleton<TrendingCubit>(
    TrendingCubit(getIt<TrendingRepoImpl>()),
  );

  getIt.registerSingleton<ArticlesBooksOpinionsBarCategoryRepoImpl>(
    ArticlesBooksOpinionsBarCategoryRepoImpl(),
  );
}
