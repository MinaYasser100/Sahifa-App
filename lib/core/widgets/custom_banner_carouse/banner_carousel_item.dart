import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/banner_gradient_overlay.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/banner_image.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/banner_info_section.dart';

class BannerCarouselItem extends StatelessWidget {
  const BannerCarouselItem({super.key, required this.banner});

  final ArticleItemModel banner;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorsTheme().blackColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Banner Image
          BannerImage(imageUrl: banner.imageUrl),

          // Gradient Overlay
          const BannerGradientOverlay(),

          // Banner Info (Title, Date, Share)
          BannerInfoSection(title: banner.title, dateTime: banner.date),
        ],
      ),
    );
  }
}
