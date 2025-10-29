import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class TabletCardIndexBadge extends StatelessWidget {
  const TabletCardIndexBadge({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorsTheme().primaryColor,
              ColorsTheme().secondaryColor,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ColorsTheme().primaryColor.withValues(
                alpha: 0.4,
              ),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.trending_up,
              color: Colors.white,
              size: 14,
            ),
            const SizedBox(width: 3),
            Text(
              '#${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
