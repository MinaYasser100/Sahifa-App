import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/colors.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({
    required this.location,
    required this.child,
    this.backgroundColor,
    super.key,
  });

  final Widget child;
  final String location;
  final Color? backgroundColor;

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex();
    final controller = NotchBottomBarController(index: currentIndex);

    return Scaffold(
      body: widget.child,
      backgroundColor: widget.backgroundColor,
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        key: ValueKey(widget.location),
        notchBottomBarController: controller,
        color: ColorsTheme().primaryColor,
        showLabel: false,
        kBottomRadius: 20.0,
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
        onTap: (index) => _onItemTapped(index, context),
        kIconSize: 24.0,
      ),
    );
  }

  int _calculateSelectedIndex() {
    if (widget.location == Routes.homeView) {
      return 0;
    }
    if (widget.location == Routes.reelsView) {
      return 1;
    }
    if (widget.location == Routes.pdfView) {
      return 2;
    }
    if (widget.location == Routes.tvView) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(Routes.homeView);
        break;
      case 1:
        GoRouter.of(context).go(Routes.reelsView);
        break;
      case 2:
        GoRouter.of(context).go(Routes.pdfView);
        break;
      case 3:
        GoRouter.of(context).go(Routes.tvView);
        break;
    }
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
