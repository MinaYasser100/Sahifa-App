import 'package:flutter/material.dart';
import 'package:sahifa/core/widgets/custom_image_widget.dart';
import 'package:sahifa/core/widgets/custom_trending/tablet_card_gradient_overlay.dart';
import 'package:sahifa/core/widgets/custom_trending/tablet_card_index_badge.dart';

class TabletCardImageSection extends StatelessWidget {
  const TabletCardImageSection({
    super.key,
    required this.imageUrl,
    required this.index,
  });

  final String imageUrl;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          CustomImageWidget(
            imageUrl: imageUrl,
            width: 160,
            height: double.infinity,
            changeBorderRadius: true,
          ),
          const TabletCardGradientOverlay(),
          Positioned(
            top: 8,
            left: 8,
            child: TabletCardIndexBadge(index: index),
          ),
        ],
      ),
    );
  }
}
