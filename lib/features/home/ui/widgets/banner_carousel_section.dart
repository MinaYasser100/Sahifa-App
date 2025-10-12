import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/features/home/data/models/banner_model.dart';
import 'package:sahifa/features/home/ui/widgets/banner_carousel_item.dart';
import 'package:sahifa/features/home/ui/widgets/carousel_dots_indicator.dart';

class BannerCarouselSection extends StatefulWidget {
  const BannerCarouselSection({super.key});

  @override
  State<BannerCarouselSection> createState() => _BannerCarouselSectionState();
}

class _BannerCarouselSectionState extends State<BannerCarouselSection> {
  int _currentBannerIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final List<BannerModel> banners = [
    BannerModel(
      title: 'Breaking News',
      imageUrl:
          'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800',
      dateTime: DateTime(2025, 10, 12),
    ),
    BannerModel(
      title: 'Exclusive Videos',
      imageUrl:
          'https://images.unsplash.com/photo-1522869635100-9f4c5e86aa37?w=800',
      dateTime: DateTime(2025, 10, 12),
    ),
    BannerModel(
      title: 'Featured Articles',
      imageUrl:
          'https://images.unsplash.com/photo-1586339949916-3e9457bef6d3?w=800',
      dateTime: DateTime(2025, 10, 12),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        // Carousel Slider
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.25,
            viewportFraction: 0.85,
            aspectRatio: 16 / 9,
            onPageChanged: (index, reason) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
          ),
          items: banners.map((banner) {
            return BannerCarouselItem(banner: banner);
          }).toList(),
        ),
        const SizedBox(height: 16),
        // Dots Indicator
        CarouselDotsIndicator(
          banners: banners,
          currentIndex: _currentBannerIndex,
          onDotTap: (index) => _carouselController.animateToPage(index),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
