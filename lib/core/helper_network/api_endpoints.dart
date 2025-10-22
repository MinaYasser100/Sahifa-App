/// API Endpoints Enum
enum ApiEndpoints {
  // Magazines
  magazines('/api/v1/magazines'),

  // Magazines by Date
  magazinesByDate('/api/v1/magazines/by-date'),

  // Trending Articles
  articles('/api/articles'),

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

class ApiQueryParams {
  static const String from = 'From';
  static const String categorySlug = 'CategorySlug';
  static const String authorId = 'AuthorId';
  static const String status = 'Status';
  static const String isFeatured = 'IsFeatured';
  static const String isBreaking = 'IsBreaking';
  static const String isSlider = 'IsSlider';
  static const String language = 'Language';
  static const String to = 'To';
  static const String pageNumber = 'PageNumber';
  static const String pageSize = 'PageSize';
  static const String searchPhrase = "SearchPhrase";
}
