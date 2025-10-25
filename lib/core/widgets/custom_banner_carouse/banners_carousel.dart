import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/banner_carousel_item.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/carousel_dots_indicator.dart';

class BannersCarousel extends StatelessWidget {
  const BannersCarousel({
    super.key,
    required this.banners,
    required this.currentIndex,
    required this.carouselController,
    required this.onPageChanged,
  });

  final List<ArticleModel> banners;
  final int currentIndex;
  final CarouselSliderController carouselController;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          _CarouselSliderSection(
            banners: banners,
            carouselController: carouselController,
            onPageChanged: onPageChanged,
          ),
          const SizedBox(height: 16),
          _DotsIndicatorSection(
            banners: banners,
            currentIndex: currentIndex,
            carouselController: carouselController,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _CarouselSliderSection extends StatelessWidget {
  const _CarouselSliderSection({
    required this.banners,
    required this.carouselController,
    required this.onPageChanged,
  });

  final List<ArticleModel> banners;
  final CarouselSliderController carouselController;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: carouselController,
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: false,
        viewportFraction: 1.0,
        aspectRatio: 16 / 9,
        pauseAutoPlayOnTouch: true,
        onPageChanged: (index, reason) => onPageChanged(index),
      ),
      items: banners.asMap().entries.map((entry) {
        return _BannerCarouselItemWrapper(
          index: entry.key,
          banner: entry.value,
        );
      }).toList(),
    );
  }
}

class _BannerCarouselItemWrapper extends StatelessWidget {
  const _BannerCarouselItemWrapper({required this.index, required this.banner});

  final int index;
  final ArticleModel banner;

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      delay: Duration(milliseconds: index * 100),
      child: GestureDetector(
        onTap: () {
          context.push(Routes.detailsArticalView, extra: banner);
        },
        child: BannerCarouselItem(banner: banner),
      ),
    );
  }
}

class _DotsIndicatorSection extends StatelessWidget {
  const _DotsIndicatorSection({
    required this.banners,
    required this.currentIndex,
    required this.carouselController,
  });

  final List<ArticleModel> banners;
  final int currentIndex;
  final CarouselSliderController carouselController;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 300),
      child: CarouselDotsIndicator(
        banners: banners,
        currentIndex: currentIndex,
        onDotTap: (index) => carouselController.animateToPage(index),
      ),
    );
  }
}
