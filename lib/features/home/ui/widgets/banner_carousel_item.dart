import 'package:flutter/material.dart';
import 'package:sahifa/features/home/data/models/banner_model.dart';
import 'package:sahifa/features/home/ui/widgets/banner_gradient_overlay.dart';
import 'package:sahifa/features/home/ui/widgets/banner_image.dart';
import 'package:sahifa/features/home/ui/widgets/banner_info_section.dart';

class BannerCarouselItem extends StatelessWidget {
  const BannerCarouselItem({super.key, required this.banner});

  final BannerModel banner;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Banner Image
            BannerImage(imageUrl: banner.imageUrl),

            // Gradient Overlay
            const BannerGradientOverlay(),

            // Banner Info (Title, Date, Share)
            BannerInfoSection(title: banner.title, dateTime: banner.dateTime),
          ],
        ),
      ),
    );
  }
}
