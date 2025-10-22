import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/features/my_favorites/data/repo/my_favorite_repo.dart';
import 'package:sahifa/features/my_favorites/manager/my_favorite_cubit/my_favorite_cubit.dart';

import 'widgets/my_favorites_body_view.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MyFavoriteCubit(getIt<MyFavoriteRepoImpl>())..fetchFavorites(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('my_favorites'.tr()),
          actions: [
            // Refresh button
            BlocBuilder<MyFavoriteCubit, MyFavoriteState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: state is MyFavoriteLoading
                      ? null
                      : () {
                          context.read<MyFavoriteCubit>().refreshFavorites();
                        },
                );
              },
            ),
          ],
        ),
        body: MyFavoritesBodyView(),
      ),
    );
  }
}
