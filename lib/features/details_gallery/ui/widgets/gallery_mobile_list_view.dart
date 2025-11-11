import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/galleries_model/galleries_model.dart';
import 'package:sahifa/features/details_gallery/ui/widgets/gallery_image_card.dart';

class GalleryMobileListView extends StatelessWidget {
  const GalleryMobileListView({
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
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GalleryImageCard(
              galleryItem: items[index],
              onTap: () => onImageTap(index),
            ),
          );
        }, childCount: items.length),
      ),
    );
  }
}
