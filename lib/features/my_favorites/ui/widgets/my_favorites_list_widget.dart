import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_card.dart';
import 'package:sahifa/features/my_favorites/manager/my_favorite_cubit/my_favorite_cubit.dart';

class MyFavoritesListWidget extends StatefulWidget {
  const MyFavoritesListWidget({super.key, required this.favorites});

  final List<ArticleModel> favorites;

  @override
  State<MyFavoritesListWidget> createState() => _MyFavoritesListWidgetState();
}

class _MyFavoritesListWidgetState extends State<MyFavoritesListWidget> {
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
      // Load more when scrolled 80% of the list
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
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  height: 325,
                  child: GestureDetector(
                    onTap: () {
                      context.push(
                        Routes.detailsArticalView,
                        extra: widget.favorites[index],
                      );
                    },
                    child: CustomArticleItemCard(
                      articleItem: widget.favorites[index],
                      cardWidth: double.infinity,
                      isItemList: true,
                    ),
                  ),
                ),
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
