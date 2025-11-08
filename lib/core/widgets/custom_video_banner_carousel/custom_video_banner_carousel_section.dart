import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/widgets/custom_video_banner_carousel/manager/video_banners_cubit/video_banners_cubit.dart';
import 'package:sahifa/core/widgets/custom_video_banner_carousel/video_banner_empty_state.dart';
import 'package:sahifa/core/widgets/custom_video_banner_carousel/video_banner_error_state.dart';
import 'package:sahifa/core/widgets/custom_video_banner_carousel/video_banner_loading_state.dart';
import 'package:sahifa/core/widgets/custom_video_banner_carousel/video_banners_carousel.dart';

class CustomVideoBannerCarouselSection extends StatefulWidget {
  const CustomVideoBannerCarouselSection({super.key});

  @override
  State<CustomVideoBannerCarouselSection> createState() =>
      _CustomVideoBannerCarouselSectionState();
}

class _CustomVideoBannerCarouselSectionState
    extends State<CustomVideoBannerCarouselSection> {
  int _currentBannerIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoBannersCubit, VideoBannersState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _buildStateWidget(state),
        );
      },
    );
  }

  Widget _buildStateWidget(VideoBannersState state) {
    if (state is VideoBannersLoading) {
      return const VideoBannerLoadingState();
    }
    if (state is VideoBannersError) {
      return VideoBannerErrorState(message: state.message);
    }
    if (state is VideoBannersLoaded) {
      if (state.videoBanners.isEmpty) {
        return const VideoBannerEmptyState();
      }
      return VideoBannersCarousel(
        videoBanners: state.videoBanners,
        currentIndex: _currentBannerIndex,
        carouselController: _carouselController,
        onPageChanged: (index) {
          setState(() {
            _currentBannerIndex = index;
          });
        },
      );
    }
    return const SizedBox.shrink();
  }
}
