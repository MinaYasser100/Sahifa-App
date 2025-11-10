import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';
import 'package:sahifa/features/altharwa_archive/manager/magazines_cubit/magazines_cubit.dart';

import 'magazines_empty_widget.dart';
import 'magazines_error_widget.dart';
import 'magazines_grid_view.dart';
import 'magazines_loading_more_indicator.dart';
import 'magazines_loading_widget.dart';
import 'tablet_magazines_grid.dart';
import 'tablet_magazines_skeleton.dart';

class AlthawraArchiveBlocBuilderBody extends StatelessWidget {
  const AlthawraArchiveBlocBuilderBody({
    super.key,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);

    return BlocBuilder<MagazinesCubit, MagazinesState>(
      builder: (context, state) {
        if (state is MagazinesLoading) {
          return isTablet
              ? const TabletMagazinesSkeleton()
              : const MagazinesLoadingWidget();
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
                child: isTablet
                    ? TabletMagazinesGrid(
                        magazines: magazines,
                        scrollController: _scrollController,
                      )
                    : MagazinesGridView(
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
