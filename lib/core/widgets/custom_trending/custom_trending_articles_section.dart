import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_trending/manager/trending_cubit/trending_cubit.dart';
import 'package:sahifa/core/widgets/custom_trending/repo/trending_repo.dart';

import 'custom_trending_articles_section_body.dart';

class CustomMobileTrendingArticlesSection extends StatelessWidget {
  const CustomMobileTrendingArticlesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final language = LanguageHelper.getCurrentLanguageCode(context);
    return BlocProvider(
      create: (context) =>
          TrendingCubit(getIt<TrendingRepoImpl>())
            ..fetchTrendingArticles(language),
      child: const CustomMobileTrendingArticlesSectionBody(),
    );
  }
}
