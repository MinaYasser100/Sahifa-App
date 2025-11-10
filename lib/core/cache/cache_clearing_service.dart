import 'dart:developer';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/features/audio/data/repo/audios_by_category_repo.dart';
import 'package:sahifa/features/author_profile/data/repo/author_profile_repo.dart';
import 'package:sahifa/features/home/data/repo/articles_books_opinions_bar_category_repo.dart';
import 'package:sahifa/features/home/data/repo/articles_horizontal_books_opinions_repo.dart';
import 'package:sahifa/features/home/data/repo/categories_horizontal_bar_repo.dart';
import 'package:sahifa/features/my_favorites/data/repo/my_favorite_repo.dart';
import 'package:sahifa/features/profile/data/repo/profile_user_repo.dart';
import 'package:sahifa/features/tv/data/repo/tv_repo.dart';

/// Service to clear all caches across the application
/// Used on login/logout to ensure fresh data
///
/// IMPORTANT: This service clears ONLY data caches (articles, videos, etc.)
/// It does NOT clear authentication tokens or user session data.
/// Auth tokens are managed separately by AuthService and TokenService.
class CacheClearingService {
  // Singleton Pattern
  static final CacheClearingService _instance =
      CacheClearingService._internal();
  factory CacheClearingService() => _instance;
  CacheClearingService._internal();

  /// Clear all caches from all repositories
  void clearAllCaches() {
    log(
      '🧹 Starting to clear all application caches...',
      name: 'CacheClearingService',
    );

    try {
      // Clear TV cache
      TVRepoImpl().clearAllCache();
      log('✅ Cleared TV cache', name: 'CacheClearingService');
    } catch (e) {
      log('⚠️ Error clearing TV cache: $e', name: 'CacheClearingService');
    }

    try {
      // Clear Categories Horizontal Bar cache
      CategoriesHorizontalBarRepoImpl(DioHelper()).clearCache();
      log(
        '✅ Cleared Categories Horizontal Bar cache',
        name: 'CacheClearingService',
      );
    } catch (e) {
      log(
        '⚠️ Error clearing Categories Horizontal Bar cache: $e',
        name: 'CacheClearingService',
      );
    }

    try {
      // Clear Articles Books Opinions Bar Category cache
      ArticlesBooksOpinionsBarCategoryRepoImpl().clearAllCache();
      log(
        '✅ Cleared Articles Books Opinions Bar Category cache',
        name: 'CacheClearingService',
      );
    } catch (e) {
      log(
        '⚠️ Error clearing Articles Books Opinions Bar Category cache: $e',
        name: 'CacheClearingService',
      );
    }

    try {
      // Clear Articles Horizontal Books Opinions cache
      ArticlesHorizontalBooksOpinionsRepoImpl().clearAllCache();
      log(
        '✅ Cleared Articles Horizontal Books Opinions cache',
        name: 'CacheClearingService',
      );
    } catch (e) {
      log(
        '⚠️ Error clearing Articles Horizontal Books Opinions cache: $e',
        name: 'CacheClearingService',
      );
    }

    try {
      // Clear Author Profile cache
      AuthorProfileRepoImpl().clearAllCache();
      log('✅ Cleared Author Profile cache', name: 'CacheClearingService');
    } catch (e) {
      log(
        '⚠️ Error clearing Author Profile cache: $e',
        name: 'CacheClearingService',
      );
    }

    try {
      // Clear My Favorites cache (ETags only, no memory cache)
      MyFavoriteRepoImpl().clearAllCache();
      log('✅ Cleared My Favorites cache', name: 'CacheClearingService');
    } catch (e) {
      log(
        '⚠️ Error clearing My Favorites cache: $e',
        name: 'CacheClearingService',
      );
    }

    try {
      // Clear Audios By Category cache (requires DioHelper)
      AudiosByCategoryRepoImpl(DioHelper()).clearAllCache();
      log('✅ Cleared Audios By Category cache', name: 'CacheClearingService');
    } catch (e) {
      log(
        '⚠️ Error clearing Audios By Category cache: $e',
        name: 'CacheClearingService',
      );
    }

    try {
      // Clear Profile User cache (ETags only, no memory cache)
      ProfileUserRepoImpl().clearAllCache();
      log('✅ Cleared Profile User cache', name: 'CacheClearingService');
    } catch (e) {
      log(
        '⚠️ Error clearing Profile User cache: $e',
        name: 'CacheClearingService',
      );
    }

    log(
      '✅ All application caches cleared successfully!',
      name: 'CacheClearingService',
    );
  }

  /// Clear cache and log the action
  void clearAllCachesWithReason(String reason) {
    log(
      '🧹 Clearing all caches - Reason: $reason',
      name: 'CacheClearingService',
    );
    clearAllCaches();
  }
}
