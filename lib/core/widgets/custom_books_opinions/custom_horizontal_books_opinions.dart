import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_books_opinions.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/core/widgets/horizontal_articles_loading_skeleton.dart';
import 'package:sahifa/features/home/manger/articles_horizontal_books_opinions_cubit/articles_horizontal_books_opinions_cubit.dart';

class CustomHorizontalBooksOpinions extends StatelessWidget {
  const CustomHorizontalBooksOpinions({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final language = LanguageHelper.getCurrentLanguageCode(context);

    return BlocBuilder<
      ArticlesHorizontalBooksOpinionsCubit,
      ArticlesHorizontalBooksOpinionsState
    >(
      builder: (context, state) {
        if (state is ArticlesHorizontalBooksOpinionsLoading) {
          return SizedBox(
            height: isTablet ? 400 : 330,
            child: const HorizontalArticlesLoadingSkeleton(),
          );
        } else if (state is ArticlesHorizontalBooksOpinionsError) {
          return SizedBox(
            height: isTablet ? 400 : 330,
            child: CustomErrorLoadingWidget(
              message: state.message,
              onPressed: () {
                context.read<ArticlesHorizontalBooksOpinionsCubit>().refresh(
                  language: language,
                );
              },
            ),
          );
        } else if (state is ArticlesHorizontalBooksOpinionsLoaded) {
          final articles = state.articles;

          if (articles.isEmpty) {
            return SizedBox(
              height: isTablet ? 400 : 330,
              child: Center(child: Text("No articles available".tr())),
            );
          }

          return SizedBox(
            height: isTablet ? 400 : 330,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return FadeInLeft(
                  child: CustomBooksOpinionsItem(articleItem: articles[index]),
                );
              },
            ),
          );
        }

        return SizedBox(
          height: isTablet ? 400 : 330,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
