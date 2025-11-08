import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/profile/data/model/feature_card_model.dart';
import 'package:sahifa/features/profile/ui/widgets/about_us_widgets/feature_card.dart';
import 'package:sahifa/features/profile/ui/widgets/about_us_widgets/hero_section.dart';
import 'package:sahifa/features/profile/ui/widgets/about_us_widgets/info_card.dart';
import 'package:sahifa/features/profile/ui/widgets/about_us_widgets/stats_section.dart';

class TabletAboutUsView extends StatelessWidget {
  const TabletAboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('about_us'.tr())),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section with Image
            HeroSection(isDark: isDark),

            // Content Section
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'about_us_title'.tr(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? colors.whiteColor : colors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Description
                    Text(
                      'about_us_content'.tr(),
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.8,
                        color: isDark ? colors.softBlue : Colors.grey[700],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 40),

                    // Features Grid - 4 columns for tablet
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
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
                    ),

                    const SizedBox(height: 40),

                    // Stats Section
                    StatsSection(isDark: isDark),

                    const SizedBox(height: 40),

                    // Info Cards - 3 columns for tablet
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: InfoCard(
                            featureCardModel: FeatureCardModel(
                              icon: Icons.calendar_today,
                              title: 'founded_year'.tr(),
                              description: '1962',
                              isDark: isDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InfoCard(
                            featureCardModel: FeatureCardModel(
                              icon: Icons.location_on,
                              title: 'address_label'.tr(),
                              description: 'address_value'.tr(),
                              isDark: isDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InfoCard(
                            featureCardModel: FeatureCardModel(
                              icon: Icons.article,
                              title: 'publication_type'.tr(),
                              description: 'daily_newspaper'.tr(),
                              isDark: isDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
