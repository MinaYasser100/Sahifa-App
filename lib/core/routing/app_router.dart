import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/model/category_model/category_model.dart';
import 'package:sahifa/core/model/magazine_model/magazine_model/pdf_model.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/core/model/parent_category/subcategory_info_model.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/routing/animation_route.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/features/altharwa_archive/ui/altharwa_archive_view.dart';
import 'package:sahifa/features/altharwa_archive/ui/widgets/archive_pdf_widget.dart';
import 'package:sahifa/features/articals_category_section/ui/articles_category_section_view.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/features/audio/ui/audio_book_details_view.dart';
import 'package:sahifa/features/audio/ui/audio_magazine_view.dart';
import 'package:sahifa/features/audio/ui/audio_player_view.dart';
import 'package:sahifa/features/confirm_email/ui/confirm_email_view.dart';
import 'package:sahifa/features/details_artical/ui/details_article_view.dart';
import 'package:sahifa/features/edit_info/ui/edit_info_view.dart';
import 'package:sahifa/features/my_favorites/ui/my_favorites_view.dart';
import 'package:sahifa/features/forget_password/ui/forget_password_view.dart';
import 'package:sahifa/features/home/ui/home_view.dart';
import 'package:sahifa/features/home/ui/widgets/drawer/drawer_subcategory_content.dart';
import 'package:sahifa/features/layout/ui/layout_view.dart';
import 'package:sahifa/features/login/ui/login_view.dart';
import 'package:sahifa/features/pdf/ui/pdf_view.dart';
import 'package:sahifa/features/profile/ui/profile_view.dart';
import 'package:sahifa/features/profile/ui/views/about_us_view.dart';
import 'package:sahifa/features/profile/ui/views/contact_us_view.dart';
import 'package:sahifa/features/profile/ui/views/privacy_policy_view.dart';
import 'package:sahifa/features/reels/ui/reels_view.dart';
import 'package:sahifa/features/register/ui/register_view.dart';
import 'package:sahifa/features/search/ui/search_view.dart';
import 'package:sahifa/features/search_category/ui/search_category_view.dart';
import 'package:sahifa/features/splash/ui/splash_view.dart';
import 'package:sahifa/features/tv/ui/tv_view.dart';
import 'package:sahifa/features/video_details/ui/video_details_view.dart';

abstract class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.splashView,
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
        path: Routes.confirmEmailView,
        pageBuilder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return fadeTransitionPage(ConfirmEmailView(email: email));
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
        path: Routes.articalsCategorySectionView,
        pageBuilder: (context, state) {
          final parentCategory = state.extra as ParentCategory?;
          if (parentCategory == null) {
            throw Exception('Parent category is not found');
          }
          return fadeTransitionPage(
            ArticlesCategorySectionView(parentCategory: parentCategory),
          );
        },
      ),

      GoRoute(
        path: Routes.detailsArticalView,
        pageBuilder: (context, state) {
          final articalModel = state.extra as ArticleModel?;
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
          final category = state.extra as CategoryFilterModel?;
          if (category == null) {
            throw Exception('Category name is not found');
          }
          return fadeTransitionPage(SearchCategoryView(category: category));
        },
      ),
      GoRoute(
        path: Routes.alThawraArchiveView,
        pageBuilder: (context, state) =>
            fadeTransitionPage(AltharwaArchiveView()),
      ),
      GoRoute(
        path: Routes.archivePdfView,
        pageBuilder: (context, state) {
          final pdfModel = state.extra as PdfModel?;
          if (pdfModel == null) {
            throw Exception('PDF model is not found');
          }
          return fadeTransitionPage(ArchivePDFWidget(pdfModel: pdfModel));
        },
      ),
      GoRoute(
        path: Routes.profileView,
        pageBuilder: (context, state) => fadeTransitionPage(ProfileView()),
      ),
      GoRoute(
        path: Routes.favoritesView,
        pageBuilder: (context, state) => fadeTransitionPage(FavoriteView()),
      ),
      GoRoute(
        path: Routes.editInfoView,
        pageBuilder: (context, state) => fadeTransitionPage(EditInfoView()),
      ),
      GoRoute(
        path: Routes.splashView,
        pageBuilder: (context, state) => fadeTransitionPage(SplashView()),
      ),
      GoRoute(
        path: Routes.drawerSubCategoryContent,
        pageBuilder: (context, state) {
          final subcategory = state.extra as SubcategoryInfoModel?;
          if (subcategory == null) {
            throw Exception('Subcategory is not found');
          }
          return fadeTransitionPage(
            DrawerSubCategoryContentView(subcategory: subcategory),
          );
        },
      ),
      GoRoute(
        path: Routes.aboutUsView,
        pageBuilder: (context, state) => fadeTransitionPage(AboutUsView()),
      ),
      GoRoute(
        path: Routes.privacyPolicyView,
        pageBuilder: (context, state) =>
            fadeTransitionPage(PrivacyPolicyView()),
      ),
      GoRoute(
        path: Routes.contactUsView,
        pageBuilder: (context, state) => fadeTransitionPage(ContactUsView()),
      ),
      GoRoute(
        path: Routes.videoDetailsView,
        pageBuilder: (context, state) {
          final video = state.extra as VideoModel?;
          if (video == null) {
            throw Exception('Video is not found');
          }
          return fadeTransitionPage(VideoDetailsView(video: video));
        },
      ),
      GoRoute(
        path: Routes.audioMagazineView,
        pageBuilder: (context, state) =>
            fadeTransitionPage(AudioMagazineView()),
      ),
      GoRoute(
        path: Routes.audioBookDetails,
        pageBuilder: (context, state) {
          final audioItem = state.extra as AudioItemModel;
          return fadeTransitionPage(AudioBookDetailsView(audioItem: audioItem));
        },
      ),
      GoRoute(
        path: Routes.audioPlayerView,
        pageBuilder: (context, state) {
          final audioItem = state.extra as AudioItemModel;
          return fadeTransitionPage(AudioPlayerView(audioItem: audioItem));
        },
      ),
    ],
  );
}
