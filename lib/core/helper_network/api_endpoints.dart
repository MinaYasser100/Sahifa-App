/// API Endpoints Enum
enum ApiEndpoints {
  // Magazines
  magazines('magazines/'),

  // Magazines by Date
  magazinesByDate('magazines/by-date'),

  // Trending Articles
  trendingArticles('trending-articles/'),

  // TV Videos
  tvVideos('tv-videos/'),

  // Products (placeholder)
  products('products/');

  final String path;
  const ApiEndpoints(this.path);

  @override
  String toString() => path;
}

class AppConst {
  // Singleton instance
  static final AppConst _instance = AppConst._internal();

  // Private constructor
  AppConst._internal();

  // Factory constructor to return the same instance
  factory AppConst() {
    return _instance;
  }

  // Static constants - DEPRECATED: Use ApiEndpoints enum instead
  @Deprecated('Use ApiEndpoints.products instead')
  static const String products = '';
}
