import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/profile/data/model/feature_card_model.dart';

class InfoCard extends StatelessWidget {
  final FeatureCardModel featureCardModel;

  const InfoCard({super.key, required this.featureCardModel});

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();

    return Card(
      color: featureCardModel.isDark ? colors.primaryColor : colors.whiteColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: featureCardModel.isDark
                    ? colors.primaryColor.withValues(alpha: 0.3)
                    : colors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                featureCardModel.icon,
                color: featureCardModel.isDark
                    ? colors.secondaryColor
                    : colors.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    featureCardModel.title ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      color: featureCardModel.isDark
                          ? colors.softBlue
                          : colors.grayColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    featureCardModel.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: featureCardModel.isDark
                          ? colors.whiteColor
                          : colors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
