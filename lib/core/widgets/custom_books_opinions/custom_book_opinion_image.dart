import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';

class CustomBookOpinionImage extends StatelessWidget {
  const CustomBookOpinionImage({
    super.key,
    required this.imageUrl,
    required this.containerWidth,
    this.isListItem = false,
  });

  final String imageUrl;
  final double containerWidth;
  final bool isListItem;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final imageSize = containerWidth / 2;
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      width: containerWidth,
      height: isTablet ? 240 : (isListItem ? 220 : 180),
      decoration: BoxDecoration(
        color: ColorsTheme().primaryColor,
        borderRadius: isListItem ? null : BorderRadius.circular(8),
        border: isListItem
            ? null
            : Border.all(
                color: isDarkMode
                    ? ColorsTheme().primaryLight.withValues(alpha: 0.2)
                    : ColorsTheme().grayColor.withValues(alpha: 0.3),
                width: 2,
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: isTablet ? 120 : (isListItem ? 120 : 90),
              height: isTablet ? 120 : (isListItem ? 120 : 100),
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    color: ColorsTheme().primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.book,
                      size: 40,
                      color: ColorsTheme().whiteColor,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    color: ColorsTheme().primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'محمد محمود',
              style: AppTextStyles.styleBold16sp(
                context,
              ).copyWith(color: ColorsTheme().whiteColor),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
