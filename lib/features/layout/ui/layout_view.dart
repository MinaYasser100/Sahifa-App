import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/ui/home_view.dart';
import 'package:sahifa/features/pdf/ui/pdf_view.dart';
import 'package:sahifa/features/reels/ui/reels_view.dart';
import 'package:sahifa/features/tv/ui/tv_view.dart';

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  final _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );

  int maxCount = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      const HomeView(),
      const ReelsView(),
      const PdfView(),
      const TvView(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          bottomBarPages.length,
          (index) => bottomBarPages[index],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: LayoutConst.bottomBarColor,
        showLabel: true,
        textOverflow: TextOverflow.visible,
        maxLine: 1,
        shadowElevation: 5,
        kBottomRadius: 28.0,
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
            itemLabel: 'Home',
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
            itemLabel: 'Reels',
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
            itemLabel: 'PDF',
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
            itemLabel: 'TV',
          ),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
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
