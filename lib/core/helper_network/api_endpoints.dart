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

  articleDetails('/api/v1/posts/categories/{categorySlug}/articles/{slug}'),

  categoryInfoBySlug('/api/v1/categories/{slug}'),

  audiosByCategory('/api/v1/posts/categories/audios'),

  // Auth Endpoints
  login('/api/v1/auth/login'),
  register('/api/v1/auth/register'),
  refreshToken('/api/v1/auth/refresh-token'),
  logout('/api/v1/auth/logout'),
  forgotPassword('/api/v1/auth/forgot-password'),
  resetPassword('/api/v1/auth/reset-password'),
  changePassword('/api/v1/auth/change-password'),
  getUserProfile('/api/v1/users/profile'),
  updateProfile('/api/v1/user/profile'),
  posts('/api/v1/posts');

  final String path;
  const ApiEndpoints(this.path);

  @override
  String toString() => path;

  /// Replace path parameters with actual values
  /// Example: articleDetails.withParams({'categorySlug': 'sports', 'slug': 'article-1'})
  String withParams(Map<String, String> params) {
    String result = path;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
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
  static const String search = "SearchPhrase";
  static const String type = "Type";
}

enum PostType { article, video, audio }

extension PostTypeExtension on PostType {
  String get value {
    switch (this) {
      case PostType.article:
        return 'article';
      case PostType.video:
        return 'video';
      case PostType.audio:
        return 'audio';
    }
  }
}
