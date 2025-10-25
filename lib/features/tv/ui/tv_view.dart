import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_video_banner_carousel/manager/video_banners_cubit/video_banners_cubit.dart';
import 'package:sahifa/core/widgets/custom_video_banner_carousel/repo/video_banner_repo.dart';
import 'package:sahifa/features/tv/data/repo/tv_repo.dart';
import 'package:sahifa/features/tv/manager/tv_cubit/tv_cubit.dart';
import 'widgets/tv_app_bar.dart';
import 'widgets/tv_error_state.dart';
import 'widgets/tv_success_videos_loaded_widget.dart';
import 'widgets/tv_videos_empty.dart';

class TvView extends StatelessWidget {
  const TvView({super.key});

  @override
  Widget build(BuildContext context) {
    final language = LanguageHelper.getCurrentLanguageCode(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              VideoBannersCubit(getIt<VideoBannerRepoImpl>())
                ..fetchVideoBanners(language),
        ),
        BlocProvider(
          create: (context) =>
              TvCubit(getIt<TVRepoImpl>())..fetchVideos(language: language),
        ),
      ],
      child: TvViewBody(language: language),
    );
  }
}

class TvViewBody extends StatelessWidget {
  const TvViewBody({super.key, required this.language});
  final String language;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: TvAppBar(isDarkMode: isDarkMode),
      body: BlocBuilder<TvCubit, TvState>(
        builder: (context, state) {
          // Loading State
          if (state is TvLoading) {
            return FadeInDown(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: ColorsTheme().primaryColor,
                    ),
                    const SizedBox(height: 16),
                    FadeInDown(
                      child: Text(
                        'loading_videos'.tr(),
                        style: AppTextStyles.styleRegular16sp(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Error State
          if (state is TvError) {
            return Center(
              child: TvErrorState(errorText: state.message, language: language),
            );
          }

          // Loaded State (includes LoadingMore)
          if (state is TvLoaded || state is TvLoadingMore) {
            final videos = state is TvLoaded
                ? state.videos
                : (state as TvLoadingMore).currentVideos;

            if (videos.isEmpty) {
              return TvVideosEmpty(isDarkMode: isDarkMode, language: language);
            }

            return TvSuccessVideosLoadedWidget(
              videos: videos,
              language: language,
            );
          }

          // Initial State
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
