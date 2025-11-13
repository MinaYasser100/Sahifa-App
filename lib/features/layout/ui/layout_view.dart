import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/reels/manager/video_player_manager.dart';
import 'package:sahifa/core/widgets/adaptive_layout.dart';
import 'package:sahifa/features/layout/ui/widgets/layout_mobile_view.dart';
import 'package:sahifa/features/layout/ui/widgets/layout_tablet_view.dart';

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  final PageController _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );

  @override
  void dispose() {
    // تأكد من إيقاف كل الفيديوهات عند إغلاق التطبيق
    final videoManager = VideoPlayerManager();
    if (videoManager.isInReelsView) {
      debugPrint('🚪 LAYOUT DISPOSE: Exiting Reels View on dispose');
      videoManager.exitReelsView();
    }

    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (mounted) {
      final videoManager = VideoPlayerManager();

      // إذا كنا في الـ reels (index 1) ادخل الـ reels view، غير كده اخرج بشكل مباشر
      if (index == 1) {
        debugPrint('🎬 LAYOUT: Entering Reels View (index: $index)');
        videoManager.enterReelsView();
      } else {
        debugPrint('🚪 LAYOUT: Exiting Reels View (index: $index)');
        videoManager.exitReelsView();
      }

      _pageController.jumpToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      // Mobile Layout - مع AnimatedNotchBottomBar
      mobileLayout: (context) => _buildMobileLayout(context),

      // Tablet Layout - مع NavigationRail
      tabletLayout: (context) => const LayoutTabletView(),

      // Desktop Layout - مع Extended NavigationRail
      desktopLayout: (context) => const LayoutTabletView(),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      body: LayoutMobileView(pageController: _pageController),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: LayoutConst.bottomBarColor,
        showLabel: true,
        textOverflow: TextOverflow.visible,
        maxLine: 1,
        shadowElevation: 5,
        kBottomRadius: 20.0,
        notchColor: ColorsTheme().grayColor.withValues(alpha: 0.5),
        removeMargins: false,
        bottomBarWidth: 500,
        showShadow: false,
        durationInMilliSeconds: 300,
        itemLabelStyle: TextStyle(
          fontSize: 12,
          color: LayoutConst.inactiveIconColor,
        ),
        elevation: 1,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(
              FontAwesomeIcons.house,
              size: LayoutConst.iconSize,
              color: LayoutConst.inactiveIconColor,
            ),
            activeItem: Icon(
              FontAwesomeIcons.house,
              size: LayoutConst.iconSize,
              color: LayoutConst.activeIconColor,
            ),
            itemLabel: 'home'.tr(),
          ),
          BottomBarItem(
            inActiveItem: Icon(
              FontAwesomeIcons.video,
              size: LayoutConst.iconSize,
              color: LayoutConst.inactiveIconColor,
            ),
            activeItem: Icon(
              FontAwesomeIcons.video,
              size: LayoutConst.iconSize,
              color: LayoutConst.activeIconColor,
            ),
            itemLabel: 'reels'.tr(),
          ),
          BottomBarItem(
            inActiveItem: Icon(
              FontAwesomeIcons.filePdf,
              size: LayoutConst.iconSize,
              color: LayoutConst.inactiveIconColor,
            ),
            activeItem: Icon(
              FontAwesomeIcons.filePdf,
              size: LayoutConst.iconSize,
              color: LayoutConst.activeIconColor,
            ),
            itemLabel: 'pdf'.tr(),
          ),
          BottomBarItem(
            inActiveItem: Icon(
              FontAwesomeIcons.tv,
              size: LayoutConst.iconSize,
              color: LayoutConst.inactiveIconColor,
            ),
            activeItem: Icon(
              FontAwesomeIcons.tv,
              size: LayoutConst.iconSize,
              color: LayoutConst.activeIconColor,
            ),
            itemLabel: 'tv'.tr(),
          ),
        ],
        onTap: (index) {
          _onPageChanged(index);
        },
        kIconSize: 24.0,
      ),
    );
  }
}

class LayoutConst {
  static final Color bottomBarColor = ColorsTheme().primaryColor;
  static final Color activeIconColor = ColorsTheme().primaryColor;
  static final Color inactiveIconColor = ColorsTheme().whiteColor;
  static final Color notchColor = ColorsTheme().grayColor.withValues(
    alpha: 0.4,
  );
  static final double iconSize = 18;
}
