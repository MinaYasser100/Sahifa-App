import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/manager/banners_cubit/banners_cubit.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/banner_loading_state.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/banner_error_state.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/banner_empty_state.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/banners_carousel.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannersCubit, BannersState>(
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

  Widget _buildStateWidget(BannersState state) {
    if (state is BannersLoading) {
      return const BannerLoadingState();
    }
    if (state is BannersError) {
      return BannerErrorState(message: state.message);
    }
    if (state is BannersLoaded) {
      if (state.banners.isEmpty) {
        return const BannerEmptyState();
      }
      return BannersCarousel(
        banners: state.banners,
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
