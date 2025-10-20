import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/features/altharwa_archive/manager/magazines_cubit/magazines_cubit.dart';

import 'magazines_empty_widget.dart';
import 'magazines_error_widget.dart';
import 'magazines_grid_view.dart';
import 'magazines_loading_more_indicator.dart';
import 'magazines_loading_widget.dart';

class AlthawraArchiveBlocBuilderBody extends StatelessWidget {
  const AlthawraArchiveBlocBuilderBody({
    super.key,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MagazinesCubit, MagazinesState>(
      builder: (context, state) {
        if (state is MagazinesLoading) {
          return const MagazinesLoadingWidget();
        }

        if (state is MagazinesError) {
          return MagazinesErrorWidget(message: state.message);
        }

        if (state is MagazinesLoaded || state is MagazinesLoadingMore) {
          final magazines = state is MagazinesLoaded
              ? state.magazines
              : (state as MagazinesLoadingMore).magazines;

          if (magazines.isEmpty) {
            return const MagazinesEmptyWidget();
          }

          return Column(
            children: [
              Expanded(
                child: MagazinesGridView(
                  magazines: magazines,
                  scrollController: _scrollController,
                ),
              ),
              // Loading more indicator
              if (state is MagazinesLoadingMore)
                const MagazinesLoadingMoreIndicator(),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
