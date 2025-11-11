import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/details_gallery/manager/details_gallery_cubit/details_gallery_cubit.dart';
import 'package:sahifa/features/details_gallery/ui/widgets/gallery_mobile_list_view.dart';
import 'package:sahifa/features/details_gallery/ui/widgets/gallery_tablet_grid_view.dart';

class DetailsGalleryBodyView extends StatelessWidget {
  const DetailsGalleryBodyView({
    super.key,
    required this.categorySlug,
    required this.gallerySlug,
  });

  final String categorySlug;
  final String gallerySlug;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsGalleryCubit, DetailsGalleryState>(
      builder: (context, state) {
        if (state is DetailsGalleryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DetailsGalleryError) {
          return CustomErrorLoadingWidget(
            message: state.message,
            onPressed: () {
              context.read<DetailsGalleryCubit>().fetchGalleryDetails(
                categorySlug: categorySlug,
                gallerySlug: gallerySlug,
              );
            },
          );
        } else if (state is DetailsGalleryLoaded) {
          final gallery = state.gallery;
          final isTablet = ResponsiveHelper.isTablet(context);

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DetailsGalleryCubit>().refresh(
                categorySlug: categorySlug,
                gallerySlug: gallerySlug,
              );
            },
            child: CustomScrollView(
              slivers: [
                // Gallery Images - Adaptive Layout
                if (isTablet)
                  GalleryTabletGridView(
                    gallery: gallery,
                    onImageTap: (index) {},
                  )
                else
                  GalleryMobileListView(
                    gallery: gallery,
                    onImageTap: (index) {},
                  ),

                // Bottom spacing
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
