import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/core/widgets/vertical_articles_loading_skeleton.dart';
import 'package:sahifa/features/author_profile/manager/autor_profile_cubit/author_profile_cubit.dart';
import 'package:sahifa/features/author_profile/ui/widgets/author_articles_grid.dart';
import 'package:sahifa/features/author_profile/ui/widgets/author_profile_header.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/empty_articles_view.dart';

class AuthorProfileTabletView extends StatelessWidget {
  const AuthorProfileTabletView({
    super.key,
    required this.authorName,
    required this.authorImage,
    required this.scrollController,
  });

  final String authorName;
  final String? authorImage;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final language = LanguageHelper.getCurrentLanguageCode(context);

    return BlocBuilder<AuthorProfileCubit, AuthorProfileState>(
      builder: (context, state) {
        if (state is AuthorProfileLoading) {
          return const VerticalArticlesLoadingSkeleton();
        } else if (state is AuthorProfileError) {
          return CustomErrorLoadingWidget(
            message: state.message,
            onPressed: () {
              context.read<AuthorProfileCubit>().refresh(
                authorName: authorName,
                language: language,
              );
            },
          );
        } else if (state is AuthorProfileLoaded) {
          final articles = state.articles;

          if (articles.isEmpty) {
            return const EmptyArticlesView();
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<AuthorProfileCubit>().refresh(
                authorName: authorName,
                language: language,
              );
            },
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                // Header Section
                SliverToBoxAdapter(
                  child: AuthorProfileHeader(
                    authorImage: authorImage,
                    authorName: authorName,
                  ),
                ),

                // Articles Grid (Tablet - 2 Columns)
                AuthorArticlesGrid(articles: articles),

                // Loading Indicator for Pagination
                if (state.hasMorePages)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          );
        }

        return const EmptyArticlesView();
      },
    );
  }
}
