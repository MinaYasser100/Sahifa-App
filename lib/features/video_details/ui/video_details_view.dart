import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';
import 'package:sahifa/features/video_details/data/repo/details_video_repo.dart';
import 'package:sahifa/features/video_details/manager/details_video_cubit/details_video_cubit.dart';

import 'widgets/tablet_video_details_body.dart';
import 'widgets/video_details_body_view.dart';

class VideoDetailsView extends StatefulWidget {
  const VideoDetailsView({super.key, required this.video});

  final VideoModel video;

  @override
  State<VideoDetailsView> createState() => _VideoDetailsViewState();
}

class _VideoDetailsViewState extends State<VideoDetailsView> {
  late final DetailsVideoCubit _cubit;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _cubit = DetailsVideoCubit(getIt<DetailsVideoRepoImpl>());
    // Fetch immediately in initState
    _fetchData();
  }

  void _fetchData() {
    if (!_isDisposed && mounted && !_cubit.isClosed) {
      _cubit.fetchVideoDetails(
        videoSlug: widget.video.slug!,
        categorySlug: widget.video.categorySlug!,
      );
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isTablet = ResponsiveHelper.isTablet(context);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: FadeIn(
            child: Text(
              'video_details'.tr(),
              style: AppTextStyles.styleBold20sp(context),
            ),
          ),
        ),
        body: BlocBuilder<DetailsVideoCubit, DetailsVideoState>(
          builder: (context, state) {
            if (state is DetailsVideoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DetailsVideoError) {
              return Center(child: Text(state.message));
            } else if (state is DetailsVideoLoaded) {
              return isTablet
                  ? TabletVideoDetailsBody(
                      video: state.video,
                      isDarkMode: isDarkMode,
                    )
                  : VideoDetailsBodyView(
                      video: state.video,
                      isDarkMode: isDarkMode,
                    );
            }
            // Initial state - show current video
            return isTablet
                ? TabletVideoDetailsBody(
                    video: widget.video,
                    isDarkMode: isDarkMode,
                  )
                : VideoDetailsBodyView(
                    video: widget.video,
                    isDarkMode: isDarkMode,
                  );
          },
        ),
      ),
    );
  }
}
