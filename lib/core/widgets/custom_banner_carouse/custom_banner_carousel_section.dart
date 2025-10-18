import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';
import 'package:sahifa/features/home/ui/widgets/banner_carousel_item.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/carousel_dots_indicator.dart';

class CustomBannerCarouselSection extends StatefulWidget {
  const CustomBannerCarouselSection({super.key});

  @override
  State<CustomBannerCarouselSection> createState() =>
      _CustomBannerCarouselSectionState();
}

class _CustomBannerCarouselSectionState
    extends State<CustomBannerCarouselSection> {
  int _currentBannerIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final List<ArticalItemModel> banners = [
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1495020689067-958852a7765e?w=400',
      title: 'Breaking: Major Political Development Shakes Nation',
      description: 'Latest political news and analysis',
      date: DateTime(2025, 10, 13),
      viewerCount: 45200,
    ),
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1522869635100-9f4c5e86aa37?w=400',
      title: 'Championship Finals: Historic Victory',
      description: 'Sports highlights and match analysis',
      date: DateTime(2025, 10, 13),
      viewerCount: 38900,
    ),
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=400',
      title: 'Tech Revolution: AI Breakthrough Announced',
      description: 'Technology innovation and trends',
      date: DateTime(2025, 10, 12),
      viewerCount: 32500,
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
            return GestureDetector(
              onTap: () {
                context.push(Routes.detailsArticalView, extra: banner);
              },
              child: BannerCarouselItem(banner: banner),
            );
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
