/// API Endpoints Enum
enum ApiEndpoints {
  // Magazines
  magazines('/api/v1/magazines'),

  // Magazines by Date
  magazinesByDate('/api/v1/magazines/by-date'),

  // Trending Articles
  articles('/api/v1/posts/categories/articles'),

  // Parent Categories
  parentCategories('/api/v1/categories'),

  // Products (placeholder)
  videos('/api/v1/posts/categories/videos'),

  articleDetails('/api/v1/posts/categories/{categorySlug}/articles/{slug}');

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
  static const String order = "Order";
  static const String colorHex = "ColorHex";
  static const String isActive = "IsActive";
  static const String showOnMenu = "ShowOnMenu";
  static const String showOnHomepage = "ShowOnHomepage";
  static const String parentCategoryId = "ParentCategoryId";
  static const String slug = "Slug";
  static const String withSub = "WithSub";
  static const String sortBy = "SortBy";
}
