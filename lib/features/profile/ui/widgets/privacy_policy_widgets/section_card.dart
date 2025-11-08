import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/profile/data/model/feature_card_model.dart';

class SectionCard extends StatelessWidget {
  final FeatureCardModel featureCardModel;

  const SectionCard({super.key, required this.featureCardModel});

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();

    return Card(
      elevation: 2,
      color: featureCardModel.isDark ? colors.primaryColor : colors.whiteColor,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: featureCardModel.isDark
                        ? colors.primaryColor.withValues(alpha: 0.3)
                        : colors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    featureCardModel.icon,
                    color: featureCardModel.isDark
                        ? colors.secondaryColor
                        : colors.primaryColor,
                    size: 20,
                  ),
                ),
                if (featureCardModel.title != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      featureCardModel.title ?? '',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: featureCardModel.isDark
                            ? colors.whiteColor
                            : colors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Text(
              featureCardModel.description,
              style: TextStyle(
                fontSize: 16,
                height: 1.8,
                color: featureCardModel.isDark
                    ? colors.softBlue
                    : Colors.grey[700],
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
