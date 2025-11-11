import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/galleries_model/galleries_model.dart';
import 'package:sahifa/features/details_gallery/ui/widgets/gallery_image_card.dart';

class GalleryTabletGridView extends StatelessWidget {
  const GalleryTabletGridView({
    super.key,
    required this.gallery,
    required this.onImageTap,
  });

  final GalleriesModel gallery;
  final Function(int index) onImageTap;

  @override
  Widget build(BuildContext context) {
    final items = gallery.items ?? [];

    if (items.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            'no_images_in_gallery'.tr(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return GalleryImageCard(
            galleryItem: items[index],
            onTap: () => onImageTap(index),
          );
        }, childCount: items.length),
      ),
    );
  }
}
