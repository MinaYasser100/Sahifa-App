import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_cubit.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_state.dart';
import 'package:sahifa/features/reels/ui/widgets/reel_item_new.dart';
import 'package:sahifa/features/reels/manager/preload_video_cache.dart';

class ReelsBodyView extends StatefulWidget {
  const ReelsBodyView({super.key});

  @override
  State<ReelsBodyView> createState() => _ReelsBodyViewState();
}

class _ReelsBodyViewState extends State<ReelsBodyView>
    with WidgetsBindingObserver {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // سيتم إنشاء PageController بعد معرفة initialPage من الـ state
    // Load reels when page opens
    final cubit = context.read<ReelsCubit>();
    final currentState = cubit.state;

    // إذا كان في state موجود، استخدم آخر index
    if (currentState is ReelsLoaded) {
      _pageController = PageController(initialPage: currentState.currentIndex);
    } else {
      _pageController = PageController();
      cubit.loadReels();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // إيقاف الفيديوهات لما التطبيق يروح في الخلفية
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // تنظيف الـ cache لما نخرج من التطبيق
      PreloadVideoCache.instance.clear();
    }
  }

  @override
  void deactivate() {
    // يتم استدعاؤه لما نخرج من الصفحة (مش التطبيق كله)
    PreloadVideoCache.instance.clear();
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // إيقاف كل الفيديوهات وتنظيف الـ preload cache
    PreloadVideoCache.instance.clear();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black, // خلفية سودا بدل البيضاء

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
                    color: ColorsTheme().errorColor,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(color: ColorsTheme().errorColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ReelsCubit>().loadReels();
                    },
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

            // استخدام WidgetsBinding لتحديث الصفحة بعد build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted &&
                  _pageController.hasClients &&
                  _pageController.page?.round() != state.currentIndex) {
                _pageController.jumpToPage(state.currentIndex);
              }
            });

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () => context.read<ReelsCubit>().refreshReels(),
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: state.reels.length + (state.hasMore ? 1 : 0),
                    // تحسينات الأداء للتقليب السريع
                    physics: const BouncingScrollPhysics(), // تقليب أسهل وأسرع
                    pageSnapping: true,
                    padEnds: false, // إزالة المساحة الزيادة
                    allowImplicitScrolling: true, // تحسين الأداء
                    onPageChanged: (index) {
                      context.read<ReelsCubit>().changePage(index);

                      // Preload the next video's controller to reduce white frames
                      final nextIndex = index + 1;
                      if (nextIndex < state.reels.length) {
                        final nextUrl = state.reels[nextIndex].videoUrl;
                        // fire-and-forget preload
                        PreloadVideoCache.instance.preload(nextUrl);
                      }
                    },
                    itemBuilder: (context, index) {
                      // Show loading indicator at the end if there's more
                      if (index == state.reels.length && state.hasMore) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorsTheme().primaryColor,
                          ),
                        );
                      }

                      // استخدام RepaintBoundary لتحسين الأداء
                      return RepaintBoundary(
                        child: ReelItem(
                          key: ValueKey(state.reels[index].id),
                          reel: state.reels[index],
                          isCurrentPage: index == state.currentIndex,
                        ),
                      );
                    },
                  ),
                ),

                // Loading More Indicator (floating)
                if (state.isLoadingMore)
                  Positioned(
                    bottom: 100,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ColorsTheme().whiteColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'loading_more'.tr(),
                              style: TextStyle(
                                color: ColorsTheme().whiteColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Error Message (if any)
                if (state.error != null)
                  Positioned(
                    top: 50,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ColorsTheme().errorColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.error!,
                        style: TextStyle(color: ColorsTheme().whiteColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
