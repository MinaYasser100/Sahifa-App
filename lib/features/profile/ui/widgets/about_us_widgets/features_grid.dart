import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/features/profile/data/model/feature_card_model.dart';
import 'package:sahifa/features/profile/ui/widgets/about_us_widgets/feature_card.dart';

class FeaturesGrid extends StatelessWidget {
  final bool isDark;

  const FeaturesGrid({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1,
      children: [
        FeatureCard(
          featureCardModel: FeatureCardModel(
            icon: Icons.verified,
            title: 'credibility'.tr(),
            description: 'trusted_source'.tr(),
            isDark: isDark,
          ),
        ),
        FeatureCard(
          featureCardModel: FeatureCardModel(
            icon: Icons.public,
            title: 'comprehensive_coverage'.tr(),
            description: 'local_international'.tr(),
            isDark: isDark,
          ),
        ),
        FeatureCard(
          featureCardModel: FeatureCardModel(
            icon: Icons.history_edu,
            title: 'heritage'.tr(),
            description: 'since_1962'.tr(),
            isDark: isDark,
          ),
        ),
        FeatureCard(
          featureCardModel: FeatureCardModel(
            icon: Icons.phone_android,
            title: 'digital_presence'.tr(),
            description: 'anytime_anywhere'.tr(),
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}
