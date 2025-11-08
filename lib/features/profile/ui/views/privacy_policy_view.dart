import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/profile/data/model/feature_card_model.dart';
import 'package:sahifa/features/profile/ui/widgets/privacy_policy_widgets/privacy_policy_header.dart';
import 'package:sahifa/features/profile/ui/widgets/privacy_policy_widgets/section_card.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('privacy_policy'.tr())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Icon
            PrivacyPolicyHeader(isDark: isDark, colors: colors),
            const SizedBox(height: 32),

            // Introduction
            SectionCard(
              featureCardModel: FeatureCardModel(
                icon: Icons.info_outline,
                title: null,
                description: 'privacy_policy_intro'.tr(),
                isDark: isDark,
              ),
            ),

            SectionCard(
              featureCardModel: FeatureCardModel(
                icon: Icons.policy,
                title: null,
                description: 'privacy_policy_scope'.tr(),
                isDark: isDark,
              ),
            ),

            // Consent Section
            SectionCard(
              featureCardModel: FeatureCardModel(
                icon: Icons.check_circle_outline,
                title: 'consent_title'.tr(),
                description: 'consent_content'.tr(),
                isDark: isDark,
              ),
            ),

            // Information We Collect
            SectionCard(
              featureCardModel: FeatureCardModel(
                icon: Icons.folder_open,
                title: 'info_we_collect_title'.tr(),
                description: 'info_we_collect_content'.tr(),
                isDark: isDark,
              ),
            ),

            // How We Use Information
            SectionCard(
              featureCardModel: FeatureCardModel(
                icon: Icons.settings_applications,
                title: 'how_we_use_title'.tr(),
                description: 'how_we_use_content'.tr(),
                isDark: isDark,
              ),
            ),

            // Children's Information
            SectionCard(
              featureCardModel: FeatureCardModel(
                icon: Icons.child_care,
                title: 'children_info_title'.tr(),
                description: 'children_info_content'.tr(),
                isDark: isDark,
              ),
            ),

            const SizedBox(height: 32),

            // Last Updated
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? colors.primaryColor.withValues(alpha: 0.2)
                      : colors.primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.update,
                      size: 16,
                      color: isDark ? colors.softBlue : colors.grayColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${'last_updated'.tr()}: ${DateFormat('yyyy/MM/dd').format(DateTime.now())}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? colors.softBlue : colors.grayColor,
                        fontStyle: FontStyle.italic,
                      ),
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
