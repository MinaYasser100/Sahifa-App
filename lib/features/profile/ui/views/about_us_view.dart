import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/adaptive_layout.dart';
import 'package:sahifa/features/profile/data/model/feature_card_model.dart';
import 'package:sahifa/features/profile/ui/views/tablet_about_us_view.dart';
import 'package:sahifa/features/profile/ui/widgets/about_us_widgets/features_grid.dart';
import 'package:sahifa/features/profile/ui/widgets/about_us_widgets/hero_section.dart';
import 'package:sahifa/features/profile/ui/widgets/about_us_widgets/info_card.dart';
import 'package:sahifa/features/profile/ui/widgets/about_us_widgets/stats_section.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobileLayout: (context) => _buildMobileLayout(context),
      tabletLayout: (context) => const TabletAboutUsView(),
      desktopLayout: (context) => const TabletAboutUsView(),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'about_us_title'.tr(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? colors.whiteColor : colors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'about_us_content'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: isDark ? colors.softBlue : Colors.grey[700],
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 32),

                  // Features Grid
                  FeaturesGrid(isDark: isDark),

                  const SizedBox(height: 32),

                  // Stats Section
                  StatsSection(isDark: isDark),

                  const SizedBox(height: 32),

                  // Info Cards
                  InfoCard(
                    featureCardModel: FeatureCardModel(
                      icon: Icons.calendar_today,
                      title: 'founded_year'.tr(),
                      description: '1962',
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InfoCard(
                    featureCardModel: FeatureCardModel(
                      icon: Icons.location_on,
                      title: 'address_label'.tr(),
                      description: 'address_value'.tr(),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InfoCard(
                    featureCardModel: FeatureCardModel(
                      icon: Icons.article,
                      title: 'publication_type'.tr(),
                      description: 'daily_newspaper'.tr(),
                      isDark: isDark,
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
