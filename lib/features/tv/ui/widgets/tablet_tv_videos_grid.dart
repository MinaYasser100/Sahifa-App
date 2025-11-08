import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_video_banner_carousel/custom_video_banner_carousel_section.dart';
import 'package:sahifa/features/tv/manager/tv_cubit/tv_cubit.dart';

import 'video_item_card.dart';

class TabletTvVideosGrid extends StatefulWidget {
  const TabletTvVideosGrid({
    super.key,
    required this.videos,
    required this.language,
  });

  final List<VideoModel> videos;
  final String language;

  @override
  State<TabletTvVideosGrid> createState() => _TabletTvVideosGridState();
}

class _TabletTvVideosGridState extends State<TabletTvVideosGrid> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final cubit = context.read<TvCubit>();
      if (!cubit.isFetchingMore) {
        cubit.loadMoreVideos(language: widget.language);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<TvCubit>().refreshVideos(language: widget.language);
      },
      color: ColorsTheme().primaryColor,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverToBoxAdapter(child: CustomVideoBannerCarouselSection()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Row(
                children: [
                  FadeInDown(
                    child: const Icon(FontAwesomeIcons.film, size: 24),
                  ),
                  const SizedBox(width: 12),
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
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return VideoItemCard(video: widget.videos[index]);
                },
                childCount: widget.videos.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<TvCubit, TvState>(
              builder: (context, state) {
                if (state is TvLoadingMore) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorsTheme().primaryColor,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
