import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/ui/home_view.dart';
import 'package:sahifa/features/pdf/ui/pdf_view.dart';
import 'package:sahifa/features/reels/ui/reels_view.dart';
import 'package:sahifa/features/tv/ui/tv_view.dart';
import 'package:sahifa/features/layout/ui/widgets/tablet/tablet_widgets.dart';

class LayoutTabletView extends StatefulWidget {
  const LayoutTabletView({super.key});

  @override
  State<LayoutTabletView> createState() => _LayoutTabletViewState();
}

class _LayoutTabletViewState extends State<LayoutTabletView>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _pages = [
    const HomeView(),
    const ReelsView(),
    PdfView(),
    const TvView(),
  ];

  late final List<NavItemData> _navItems;

  @override
  void initState() {
    super.initState();

    _navItems = [
      NavItemData(
        icon: FontAwesomeIcons.house,
        label: 'home',
        gradient: [ColorsTheme().primaryColor, ColorsTheme().secondaryColor],
      ),
      NavItemData(
        icon: FontAwesomeIcons.video,
        label: 'reels',
        gradient: [ColorsTheme().primaryColor, ColorsTheme().secondaryColor],
      ),
      NavItemData(
        icon: FontAwesomeIcons.filePdf,
        label: 'pdf',
        gradient: [ColorsTheme().primaryColor, ColorsTheme().secondaryColor],
      ),
      NavItemData(
        icon: FontAwesomeIcons.tv,
        label: 'tv',
        gradient: [ColorsTheme().primaryColor, ColorsTheme().secondaryColor],
      ),
    ];

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? ColorsTheme().blackColor
          : const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // Modern Navigation Rail
          TabletNavigationRail(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
            navItems: _navItems,
            isDark: isDark,
          ),

          // Content Area with Fade Animation
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
