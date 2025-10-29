import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/layout/ui/widgets/tablet/tablet_nav_item.dart';

class TabletNavigationRail extends StatelessWidget {
  const TabletNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.navItems,
    required this.isDark,
  });

  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<NavItemData> navItems;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  color: ColorsTheme().primaryColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
          ),
          const SizedBox(height: 32),
          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                return TabletNavItem(
                  item: navItems[index],
                  isSelected: selectedIndex == index,
                  isDark: isDark,
                  onTap: () => onItemTapped(index),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
