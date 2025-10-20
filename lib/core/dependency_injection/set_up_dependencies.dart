import 'package:get_it/get_it.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/repo/banner_repo.dart';
import 'package:sahifa/core/widgets/custom_trending/repo/trending_repo.dart';
import 'package:sahifa/features/tv/data/repo/tv_repo.dart';

final getIt = GetIt.instance;

void setupDependencies() async {
  getIt.registerSingleton<BannerRepoImpl>(BannerRepoImpl());
  getIt.registerSingleton<TrendingRepoImpl>(TrendingRepoImpl());
  getIt.registerSingleton<TVRepoImpl>(TVRepoImpl());
}
