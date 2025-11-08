import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_video_banner_carousel/video_banner_carousel_item.dart';
import 'package:sahifa/core/widgets/custom_video_banner_carousel/video_carousel_dots_indicator.dart';

class VideoBannersCarousel extends StatelessWidget {
  const VideoBannersCarousel({
    super.key,
    required this.videoBanners,
    required this.currentIndex,
    required this.carouselController,
    required this.onPageChanged,
  });

  final List<VideoModel> videoBanners;
  final int currentIndex;
  final CarouselSliderController carouselController;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          _VideoCarouselSliderSection(
            videoBanners: videoBanners,
            carouselController: carouselController,
            onPageChanged: onPageChanged,
          ),
          const SizedBox(height: 16),
          _DotsIndicatorSection(
            videoBanners: videoBanners,
            currentIndex: currentIndex,
            carouselController: carouselController,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _VideoCarouselSliderSection extends StatelessWidget {
  const _VideoCarouselSliderSection({
    required this.videoBanners,
    required this.carouselController,
    required this.onPageChanged,
  });

  final List<VideoModel> videoBanners;
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
      items: videoBanners.asMap().entries.map((entry) {
        return _VideoBannerCarouselItemWrapper(
          index: entry.key,
          videoBanner: entry.value,
        );
      }).toList(),
    );
  }
}

class _VideoBannerCarouselItemWrapper extends StatelessWidget {
  const _VideoBannerCarouselItemWrapper({
    required this.index,
    required this.videoBanner,
  });

  final int index;
  final VideoModel videoBanner;

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      delay: Duration(milliseconds: index * 100),
      child: GestureDetector(
        onTap: () {
          // Navigate to video details page
          context.push(Routes.videoDetailsView, extra: videoBanner);
        },
        child: VideoBannerCarouselItem(videoBanner: videoBanner),
      ),
    );
  }
}

class _DotsIndicatorSection extends StatelessWidget {
  const _DotsIndicatorSection({
    required this.videoBanners,
    required this.currentIndex,
    required this.carouselController,
  });

  final List<VideoModel> videoBanners;
  final int currentIndex;
  final CarouselSliderController carouselController;

  @override
  Widget build(BuildContext context) {
    return VideoCarouselDotsIndicator(
      videoBanners: videoBanners,
      currentIndex: currentIndex,
      onDotTap: (index) => carouselController.animateToPage(index),
    );
  }
}
