import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/reels/data/repo/reels_api_repo.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_cubit.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_state.dart';
import 'package:sahifa/features/reels/manager/video_player_manager.dart';
import 'package:sahifa/features/reels/ui/widgets/reel_item.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Reels View - بسيط زي Instagram
class ReelsView extends StatefulWidget {
  const ReelsView({super.key});

  @override
  State<ReelsView> createState() => _ReelsViewState();
}

class _ReelsViewState extends State<ReelsView> with WidgetsBindingObserver {
  late PageController _pageController;
  final _videoManager = VideoPlayerManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _videoManager.stopAll();
    }
  }

  @override
  void dispose() {
    // أوقف كل الفيديوهات فوراً قبل الخروج
    _videoManager.stopAll();
    _videoManager.disposeAll();
    
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('reels_view'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction < 0.1) {
          debugPrint('🛑 Reels hidden - Stopping all videos');
          _videoManager.stopAll();
        } else {
          debugPrint('✅ Reels visible: ${info.visibleFraction}');
        }
      },
      child: BlocProvider(
        create: (context) => ReelsCubit(ReelsApiRepo(DioHelper()))..loadReels(),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Scaffold(
      body: BlocBuilder<ReelsCubit, ReelsState>(
        builder: (context, state) {
          if (state is ReelsLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorsTheme().primaryColor,
              ),
            );
          }

          if (state is ReelsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: ColorsTheme().primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: ColorsTheme().whiteColor),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ReelsCubit>().loadReels(),
                    child: Text('retry'.tr()),
                  ),
                ],
              ),
            );
          }

          if (state is ReelsLoaded) {
            if (state.reels.isEmpty) {
              return Center(
                child: Text(
                  'no_reels_available'.tr(),
                  style: TextStyle(
                    color: ColorsTheme().whiteColor,
                    fontSize: 16,
                  ),
                ),
              );
            }

            // Update page controller if needed
            if (_pageController.hasClients &&
                _pageController.page?.round() != state.currentIndex) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _pageController.jumpToPage(state.currentIndex);
                }
              });
            }

            return RefreshIndicator(
              onRefresh: () => context.read<ReelsCubit>().refreshReels(),
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                pageSnapping: true,
                physics: const PageScrollPhysics(),
                itemCount: state.reels.length + (state.hasMore ? 1 : 0),
                onPageChanged: (index) {
                  context.read<ReelsCubit>().changePage(index);
                },
                itemBuilder: (context, index) {
                  // Loading indicator for next page
                  if (index == state.reels.length && state.hasMore) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorsTheme().primaryColor,
                      ),
                    );
                  }

                  final reel = state.reels[index];
                  return ReelItem(
                    key: ValueKey(reel.id),
                    reel: reel,
                    isCurrentPage: index == state.currentIndex,
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
