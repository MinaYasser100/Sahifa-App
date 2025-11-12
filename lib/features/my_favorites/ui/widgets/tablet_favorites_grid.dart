import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_article_item/tablet_grid_article_card.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/tablet_grid_book_opinion_card.dart';
import 'package:sahifa/features/my_favorites/manager/my_favorite_cubit/my_favorite_cubit.dart';

class TabletFavoritesGrid extends StatefulWidget {
  const TabletFavoritesGrid({super.key, required this.favorites});

  final List<ArticleModel> favorites;

  @override
  State<TabletFavoritesGrid> createState() => _TabletFavoritesGridState();
}

class _TabletFavoritesGridState extends State<TabletFavoritesGrid> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when scrolled 80% of the grid
      final cubit = context.read<MyFavoriteCubit>();
      if (!cubit.isFetchingMore) {
        cubit.loadMoreFavorites();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final article = widget.favorites[index];

              return GestureDetector(
                onTap: () {
                  if (article.postType == 'Gallery') {
                    context.push(Routes.detailsGalleryView, extra: article);
                  } else {
                    context.push(Routes.detailsArticalView, extra: article);
                  }
                },
                child:
                    (article.ownerIsAuthor == true &&
                        article.postType != 'Gallery')
                    ? TabletGridBookOpinionCard(articleItem: article)
                    : TabletGridArticleCard(articleItem: article),
              );
            }, childCount: widget.favorites.length),
          ),
        ),

        // Loading More Indicator
        SliverToBoxAdapter(
          child: BlocBuilder<MyFavoriteCubit, MyFavoriteState>(
            builder: (context, state) {
              if (state is MyFavoriteLoadingMore) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorsTheme().primaryColor,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),

        // Bottom Spacing
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }
}
