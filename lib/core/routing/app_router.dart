import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/animation_route.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/features/altharwa_archive/ui/altharwa_archive_view.dart';
import 'package:sahifa/features/altharwa_archive/ui/widgets/search_pdf_widget.dart';
import 'package:sahifa/features/articals_section/ui/articasl_section_view.dart';
import 'package:sahifa/features/details_artical/ui/details_article_view.dart';
import 'package:sahifa/features/forget_password/ui/forget_password_view.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';
import 'package:sahifa/features/home/ui/home_view.dart';
import 'package:sahifa/features/layout/ui/layout_view.dart';
import 'package:sahifa/features/login/ui/login_view.dart';
import 'package:sahifa/features/pdf/ui/pdf_view.dart';
import 'package:sahifa/features/profile/ui/profile_view.dart';
import 'package:sahifa/features/reels/ui/reels_view.dart';
import 'package:sahifa/features/register/ui/register_view.dart';
import 'package:sahifa/features/search/ui/search_view.dart';
import 'package:sahifa/features/search_category/ui/search_category_view.dart';
import 'package:sahifa/features/tv/ui/tv_view.dart';

abstract class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.layoutView,
    routes: [
      //Register view
      GoRoute(
        path: Routes.registerView,
        pageBuilder: (context, state) => fadeTransitionPage(RegisterView()),
      ),

      GoRoute(
        path: Routes.loginView,
        pageBuilder: (context, state) {
          return fadeTransitionPage(LoginView());
        },
      ),

      GoRoute(
        path: Routes.forgotPasswordView,
        pageBuilder: (context, state) =>
            fadeTransitionPage(ForgetPasswordView()),
      ),

      GoRoute(
        path: Routes.homeView,
        pageBuilder: (context, state) => fadeTransitionPage(HomeView()),
      ),

      GoRoute(
        path: Routes.layoutView,
        pageBuilder: (context, state) => fadeTransitionPage(LayoutView()),
      ),

      GoRoute(
        path: Routes.reelsView,
        pageBuilder: (context, state) => fadeTransitionPage(ReelsView()),
      ),

      GoRoute(
        path: Routes.tvView,
        pageBuilder: (context, state) => fadeTransitionPage(TvView()),
      ),

      GoRoute(
        path: Routes.pdfView,
        pageBuilder: (context, state) {
          final pdfPath = state.extra as String?;
          return fadeTransitionPage(PdfView(pdfPath: pdfPath));
        },
      ),

      GoRoute(
        path: Routes.articalsSectionView,
        pageBuilder: (context, state) {
          final title = state.extra as String?;
          if (title == null) throw Exception('Level is not found');
          return fadeTransitionPage(ArticalsSectionView(title: title));
        },
      ),

      GoRoute(
        path: Routes.detailsArticalView,
        pageBuilder: (context, state) {
          final articalModel = state.extra as ArticalItemModel?;
          if (articalModel == null) {
            throw Exception('Artical model is not found');
          }
          return fadeTransitionPage(
            DetailsArticleView(articalModel: articalModel),
          );
        },
      ),

      GoRoute(
        path: Routes.searchView,
        pageBuilder: (context, state) => fadeTransitionPage(SearchView()),
      ),
      GoRoute(
        path: Routes.searchCategoryView,
        pageBuilder: (context, state) {
          final categoryName = state.extra as String?;
          if (categoryName == null) {
            throw Exception('Category name is not found');
          }
          return fadeTransitionPage(
            SearchCategoryView(categoryName: categoryName),
          );
        },
      ),
      GoRoute(
        path: Routes.alThawraArchiveView,
        pageBuilder: (context, state) =>
            fadeTransitionPage(AltharwaArchiveView()),
      ),
      GoRoute(
        path: Routes.searchPdfView,
        pageBuilder: (context, state) {
          final pdfPath = state.extra as String?;
          return fadeTransitionPage(SearchPDFWidget(pdfPath: pdfPath));
        },
      ),
      GoRoute(
        path: Routes.profileView,
        pageBuilder: (context, state) => fadeTransitionPage(ProfileView()),
      ),
    ],
  );
}
