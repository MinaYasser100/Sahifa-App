import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class TabletNavItem extends StatelessWidget {
  const TabletNavItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final NavItemData item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
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

class NavItemData {
  final IconData icon;
  final String label;
  final List<Color> gradient;

  NavItemData({
    required this.icon,
    required this.label,
    required this.gradient,
  });
}
