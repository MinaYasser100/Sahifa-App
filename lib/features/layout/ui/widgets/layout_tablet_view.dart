import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/ui/home_view.dart';
import 'package:sahifa/features/pdf/ui/pdf_view.dart';
import 'package:sahifa/features/reels/ui/reels_view.dart';
import 'package:sahifa/features/tv/ui/tv_view.dart';

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

  final List<_NavItem> _navItems = [
    _NavItem(
      icon: FontAwesomeIcons.house,
      label: 'home',
      gradient: [ColorsTheme().primaryColor, ColorsTheme().secondaryColor],
    ),
    _NavItem(
      icon: FontAwesomeIcons.video,
      label: 'reels',
      gradient: [ColorsTheme().primaryColor, ColorsTheme().secondaryColor],
    ),
    _NavItem(
      icon: FontAwesomeIcons.filePdf,
      label: 'pdf',
      gradient: [ColorsTheme().primaryColor, ColorsTheme().secondaryColor],
    ),
    _NavItem(
      icon: FontAwesomeIcons.tv,
      label: 'tv',
      gradient: [ColorsTheme().primaryColor, ColorsTheme().secondaryColor],
    ),
  ];

  @override
  void initState() {
    super.initState();
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
          Container(
            width: 100,
            decoration: BoxDecoration(
              color: isDark ? ColorsTheme().cardColor : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // App Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsTheme().primaryColor.withValues(
                          alpha: 0.3,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 32),
                // Navigation Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _navItems.length,
                    itemBuilder: (context, index) {
                      return _buildNavItem(
                        index: index,
                        item: _navItems[index],
                        isSelected: _selectedIndex == index,
                        isDark: isDark,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
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

  Widget _buildNavItem({
    required int index,
    required _NavItem item,
    required bool isSelected,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onItemTapped(index),
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: item.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  size: 24,
                  color: isSelected
                      ? Colors.white
                      : (isDark
                            ? ColorsTheme().grayColor
                            : ColorsTheme().blackColor.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 6),
                Text(
                  item.label.tr(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                              ? ColorsTheme().grayColor
                              : ColorsTheme().blackColor.withValues(
                                  alpha: 0.6,
                                )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final List<Color> gradient;

  _NavItem({required this.icon, required this.label, required this.gradient});
}
