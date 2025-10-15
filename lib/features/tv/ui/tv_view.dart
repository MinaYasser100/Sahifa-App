import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/custom_banner_carousel_section.dart';
import 'package:sahifa/features/tv/data/models/video_item_model.dart';
import 'package:sahifa/features/tv/ui/widgets/video_item_card.dart';

import 'widgets/tv_app_bar.dart';

class TvView extends StatefulWidget {
  const TvView({super.key});

  @override
  State<TvView> createState() => _TvViewState();
}

class _TvViewState extends State<TvView> {
  late List<VideoItemModel> videos;

  @override
  void initState() {
    super.initState();
    videos = VideoItemModel.getSampleVideos();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: TvAppBar(isDarkMode: isDarkMode),
      body: videos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.videoSlash,
                    size: 80,
                    color: isDarkMode
                        ? ColorsTheme().primaryLight.withValues(alpha: 0.5)
                        : ColorsTheme().grayColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No videos available',
                    style: TextStyle(
                      fontSize: 18,
                      color: isDarkMode
                          ? ColorsTheme().whiteColor.withValues(alpha: 0.6)
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                // Simulate refresh
                await Future.delayed(const Duration(seconds: 1));
                setState(() {
                  videos = VideoItemModel.getSampleVideos();
                });
              },
              color: ColorsTheme().primaryColor,
              child: CustomScrollView(
                slivers: [
                  // Banner Carousel Section
                  SliverToBoxAdapter(child: CustomBannerCarouselSection()),

                  // Videos Title Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.film, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Latest Videos',
                            style: AppTextStyles.styleBold20sp(context),
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
            ),
    );
  }
}
