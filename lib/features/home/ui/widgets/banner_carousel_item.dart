import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/data/models/banner_model.dart';

class BannerCarouselItem extends StatelessWidget {
  const BannerCarouselItem({super.key, required this.banner});

  final BannerModel banner;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
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
                // الصورة
                _buildBannerImage(),
                // Gradient Overlay
                _buildGradientOverlay(),
                // العنوان في أسفل الصورة
                _buildBannerTitle(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBannerImage() {
    return Image.network(
      banner.imageUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: ColorsTheme().primaryColor,
          child: const Center(
            child: Icon(Icons.image, size: 50, color: Colors.white),
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: ColorsTheme().primaryColor,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerTitle() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          banner.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
