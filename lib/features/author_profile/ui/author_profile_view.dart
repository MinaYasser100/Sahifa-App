import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/adaptive_layout.dart';
import 'package:sahifa/features/author_profile/data/repo/author_profile_repo.dart';
import 'package:sahifa/features/author_profile/manager/autor_profile_cubit/author_profile_cubit.dart';
import 'package:sahifa/features/author_profile/ui/widgets/author_profile_mobile_view.dart';
import 'package:sahifa/features/author_profile/ui/widgets/author_profile_tablet_view.dart';

class AuthorProfileView extends StatelessWidget {
  const AuthorProfileView({super.key, required this.oldArticle});

  final ArticleModel oldArticle;

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return BlocProvider(
      create: (_) {
        final cubit = AuthorProfileCubit(getIt<AuthorProfileRepoImpl>());
        // يمكنك بدء تحميل المقالات هنا مباشرة بعد الإنشاء
        cubit.fetchArticles(
          authorName: oldArticle.authorName ?? 'No Name'.tr(),
          language: LanguageHelper.getCurrentLanguageCode(context),
        );
        // إضافة استماع للسكروول لتحميل المزيد
        scrollController.addListener(() {
          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.7) {
            cubit.loadMoreArticles(
              authorName: oldArticle.authorName ?? 'No Name'.tr(),
              language: LanguageHelper.getCurrentLanguageCode(context),
            );
          }
        });
        return cubit;
      },
      child: Scaffold(
        body: AdaptiveLayout(
          mobileLayout: (context) => AuthorProfileMobileView(
            authorName: oldArticle.authorName ?? 'No Name'.tr(),
            authorImage: oldArticle.authorImage,
            scrollController: scrollController,
          ),
          tabletLayout: (context) => AuthorProfileTabletView(
            authorName: oldArticle.authorName ?? 'No Name'.tr(),
            authorImage: oldArticle.authorImage,
            scrollController: scrollController,
          ),
          desktopLayout: (context) => AuthorProfileTabletView(
            authorName: oldArticle.authorName ?? 'No Name'.tr(),
            authorImage: oldArticle.authorImage,
            scrollController: scrollController,
          ),
        ),
      ),
    );
  }
}
