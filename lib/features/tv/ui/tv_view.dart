import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/repo/banner_repo.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/manager/banners_cubit/banners_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              BannersCubit(getIt<BannerRepoImpl>())..fetchBanners(),
        ),
        BlocProvider(
          create: (context) => TvCubit(getIt<TVRepoImpl>())..fetchVideos(),
        ),
      ],
      child: const _TvViewBody(),
    );
  }
}

class _TvViewBody extends StatelessWidget {
  const _TvViewBody();

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
            return Center(child: TvErrorState(errorText: state.message));
          }

          // Loaded State
          if (state is TvLoaded) {
            final videos = state.videos;

            if (videos.isEmpty) {
              return TvVideosEmpty(isDarkMode: isDarkMode);
            }

            return TvSuccessVideosLoadedWidget(videos: videos);
          }

          // Initial State
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
