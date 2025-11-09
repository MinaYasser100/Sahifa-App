import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_horizontal_books_opinions.dart';
import 'package:sahifa/features/home/data/repo/articles_horizontal_books_opinions_repo.dart';
import 'package:sahifa/features/home/manger/articles_horizontal_books_opinions_cubit/articles_horizontal_books_opinions_cubit.dart';

class BooksOpinionsSection extends StatelessWidget {
  const BooksOpinionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final language = LanguageHelper.getCurrentLanguageCode(context);

    return BlocProvider(
      create: (context) => ArticlesHorizontalBooksOpinionsCubit(
        ArticlesHorizontalBooksOpinionsRepoImpl(),
      )..fetchArticles(language: language),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              context.push(
                Routes.articalsCategorySectionView,
                extra: 'books_opinions'.tr(),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    'books_opinions'.tr(),
                    style: AppTextStyles.styleBold24sp(context).copyWith(
                      color: isDarkMode
                          ? ColorsTheme().whiteColor
                          : ColorsTheme().primaryColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: isDarkMode
                        ? ColorsTheme().whiteColor
                        : ColorsTheme().primaryColor,
                  ),
                ],
              ),
            ),
          ),
          const CustomHorizontalBooksOpinions(),
        ],
      ),
    );
  }
}
