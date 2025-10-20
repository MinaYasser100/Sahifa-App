import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/custom_banner_carousel_section.dart';
import 'package:sahifa/features/tv/data/models/video_item_model.dart';
import 'package:sahifa/features/tv/manager/tv_cubit/tv_cubit.dart';

import 'video_item_card.dart';

class TvSuccessVideosLoadedWidget extends StatelessWidget {
  const TvSuccessVideosLoadedWidget({super.key, required this.videos});

  final List<VideoItemModel> videos;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<TvCubit>().refreshVideos();
      },
      color: ColorsTheme().primaryColor,
      child: CustomScrollView(
        slivers: [
          // Banner Carousel Section
          const SliverToBoxAdapter(child: CustomBannerCarouselSection()),

          // Videos Title Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  FadeInDown(
                    child: const Icon(FontAwesomeIcons.film, size: 20),
                  ),
                  const SizedBox(width: 10),
                  FadeInRight(
                    child: Text(
                      'latest_videos'.tr(),
                      style: AppTextStyles.styleBold20sp(context),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Videos List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return VideoItemCard(video: videos[index]);
              }, childCount: videos.length),
            ),
          ),

          // Bottom Spacing
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}
