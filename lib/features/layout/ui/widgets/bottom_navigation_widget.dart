import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/colors.dart';

class BottomNavigationWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      backgroundColor: backgroundColor,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          key: ValueKey(location),
          currentIndex: _calculateSelectedIndex(),
          selectedItemColor: ColorsTheme().primaryColor,
          unselectedItemColor: ColorsTheme().grayColor,
          onTap: (index) => _onItemTapped(index, context),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          items: [
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                FontAwesomeIcons.house,
                size: 24,
                color: ColorsTheme().grayColor,
              ),
              activeIcon: Icon(
                FontAwesomeIcons.house,
                size: 24,
                color: ColorsTheme().primaryColor,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                FontAwesomeIcons.video,
                size: 24,
                color: ColorsTheme().grayColor,
              ),
              activeIcon: Icon(
                FontAwesomeIcons.video,
                size: 24,
                color: ColorsTheme().primaryColor,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                FontAwesomeIcons.filePdf,
                size: 24,
                color: ColorsTheme().grayColor,
              ),
              activeIcon: Icon(
                FontAwesomeIcons.filePdf,
                size: 24,
                color: ColorsTheme().primaryColor,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                FontAwesomeIcons.tv,
                size: 24,
                color: ColorsTheme().grayColor,
              ),
              activeIcon: Icon(
                FontAwesomeIcons.tv,
                size: 24,
                color: ColorsTheme().primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateSelectedIndex() {
    if (location == Routes.homeView) {
      return 0;
    }
    if (location == Routes.reelsView) {
      return 1;
    }
    if (location == Routes.pdfView) {
      return 2;
    }
    if (location == Routes.tvView) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(Routes.homeView);
      case 1:
        GoRouter.of(context).go(Routes.reelsView);
      case 2:
        GoRouter.of(context).go(Routes.pdfView);
      case 3:
        GoRouter.of(context).go(Routes.tvView);
    }
  }
}
