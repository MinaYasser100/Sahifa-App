import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/my_favorites/manager/my_favorite_cubit/my_favorite_cubit.dart';

import 'my_favorites_empty_list_widget.dart';
import 'my_favorites_list_widget.dart';

class MyFavoritesBodyView extends StatelessWidget {
  const MyFavoritesBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyFavoriteCubit, MyFavoriteState>(
      listener: (context, state) {
        if (state is MyFavoriteLoading) {
          EasyLoading.show(
            status: 'loading'.tr(),
            maskType: EasyLoadingMaskType.black,
          );
        } else {
          EasyLoading.dismiss();
        }
      },
      builder: (context, state) {
        // Loading State - just show empty space since EasyLoading handles it
        if (state is MyFavoriteLoading) {
          return const SizedBox.shrink();
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

        // Loaded State
        if (state is MyFavoriteLoaded) {
          final favorites = state.favorites;

          // Empty State
          if (favorites.isEmpty) {
            return const MyFavoritesEmptyListWidget();
          }

          // List of Favorites
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<MyFavoriteCubit>().refreshFavorites();
            },
            child: MyFavoritesListWidget(favorites: favorites),
          );
        }

        // Initial State
        return const SizedBox.shrink();
      },
    );
  }
}
