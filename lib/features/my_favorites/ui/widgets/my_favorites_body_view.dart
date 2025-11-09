import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/my_favorites/manager/my_favorite_cubit/my_favorite_cubit.dart';

import 'my_favorites_empty_list_widget.dart';
import 'my_favorites_list_widget.dart';
import 'tablet_favorites_grid.dart';

class MyFavoritesBodyView extends StatelessWidget {
  const MyFavoritesBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyFavoriteCubit, MyFavoriteState>(
      builder: (context, state) {
        // Loading State
        if (state is MyFavoriteLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error State
        if (state is MyFavoriteError) {
          return CustomErrorLoadingWidget(
            message: state.message,
            onPressed: () {
              context.read<MyFavoriteCubit>().fetchFavorites();
            },
          );
        }

        // Loaded State (includes LoadingMore)
        if (state is MyFavoriteLoaded || state is MyFavoriteLoadingMore) {
          final favorites = state is MyFavoriteLoaded
              ? state.favorites
              : (state as MyFavoriteLoadingMore).favorites;

          // Empty State
          if (favorites.isEmpty) {
            return const MyFavoritesEmptyListWidget();
          }

          // List of Favorites
          final isTablet = ResponsiveHelper.isTablet(context);

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<MyFavoriteCubit>().refreshFavorites();
            },
            child: isTablet
                ? TabletFavoritesGrid(favorites: favorites)
                : MyFavoritesListWidget(favorites: favorites),
          );
        }

        // Initial State
        return const SizedBox.shrink();
      },
    );
  }
}
