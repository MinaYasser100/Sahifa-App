import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/profile/data/model/feature_card_model.dart';

class FeatureCard extends StatelessWidget {
  final FeatureCardModel featureCardModel;

  const FeatureCard({super.key, required this.featureCardModel});

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();

    return Card(
      elevation: 2,
      color: featureCardModel.isDark ? colors.primaryColor : colors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              featureCardModel.icon,
              size: 40,
              color: featureCardModel.isDark
                  ? colors.secondaryColor
                  : colors.primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              featureCardModel.title ?? '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: featureCardModel.isDark
                    ? colors.whiteColor
                    : colors.primaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              featureCardModel.description,
              style: TextStyle(
                fontSize: 12,
                color: featureCardModel.isDark
                    ? colors.softBlue
                    : colors.grayColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
