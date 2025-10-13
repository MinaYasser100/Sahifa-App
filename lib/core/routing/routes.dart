class Routes {
  // Singleton instance
  static final Routes _instance = Routes._internal();

  // Private constructor
  Routes._internal();

  // Factory constructor to return the same instance
  factory Routes() {
    return _instance;
  }

  // Static route constants
  static const String registerView = '/register';
  static const String loginView = '/login';
  static const String homeView = '/home';
  static const String layoutView = '/layout';
  static const String forgotPasswordView = '/forgot-password';
  static const String reelsView = '/reels';
  static const String tvView = '/tv';
  static const String pdfView = '/pdf';
  static const String articalsSectionView = '/articals-section';
  static const String detailsArticalView = '/details-artical';
  static const String searchView = '/search';
}
