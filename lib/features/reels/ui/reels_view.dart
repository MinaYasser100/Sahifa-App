import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/reels/data/repo/reels_api_repo.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_cubit.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_state.dart';
import 'package:sahifa/features/reels/manager/video_player_manager.dart';
import 'package:sahifa/features/reels/ui/widgets/reel_item.dart';

/// Reels View - بسيط زي Instagram
class ReelsView extends StatefulWidget {
  const ReelsView({super.key});

  @override
  State<ReelsView> createState() => _ReelsViewState();
}

class _ReelsViewState extends State<ReelsView> {
  late PageController _pageController;
  final _videoManager = VideoPlayerManager();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    debugPrint('🎬 REELS: View initialized');
  }

  @override
  void dispose() {
    debugPrint('🛑 REELS: Disposing - STOPPING ALL VIDEOS');
    
    // إيقاف فوري وكامل
    _videoManager.killAllVideos();
    
    _pageController.dispose();
    super.dispose();
    
    debugPrint('🛑 REELS: Dispose complete');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReelsCubit(ReelsApiRepo(DioHelper()))..loadReels(),
      child: _buildBody(),
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
