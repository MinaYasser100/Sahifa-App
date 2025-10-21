import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/additional_setting_model/additional_setting_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/colors.dart';

import 'additonal_settings_item.dart';

class AppInfoSection extends StatelessWidget {
  final bool isDark;

  const AppInfoSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Column(
        children: [
          AdditionalSettingsItem(
            model: AdditionalSettingModel(
              icon: Icons.info_outline,
              title: 'about_us'.tr(),
              isDark: isDark,
              onTap: () {
                context.push(Routes.aboutUsView);
              },
            ),
          ),
          const Divider(height: 1),
          AdditionalSettingsItem(
            model: AdditionalSettingModel(
              icon: Icons.privacy_tip_outlined,
              title: 'privacy_policy'.tr(),
              isDark: isDark,
              onTap: () {
                context.push(Routes.privacyPolicyView);
              },
            ),
          ),
          const Divider(height: 1),
          AdditionalSettingsItem(
            model: AdditionalSettingModel(
              icon: Icons.contact_support_outlined,
              title: 'contact_us'.tr(),
              isDark: isDark,
              onTap: () {
                context.push(Routes.contactUsView);
              },
            ),
          ),
          const Divider(height: 1),
          AdditionalSettingsItem(
            model: AdditionalSettingModel(
              icon: Icons.share_outlined,
              title: 'help_share'.tr(),
              isDark: isDark,
              onTap: () {
                _showComingSoonDialog(context, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, bool isDark) {
    final colors = ColorsTheme();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? colors.cardColor : colors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Icon(
              Icons.access_time,
              size: 60,
              color: isDark ? colors.secondaryColor : colors.primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'coming_soon_title'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? colors.whiteColor : colors.primaryDark,
              ),
            ),
          ],
        ),
        content: Text(
          'coming_soon'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? colors.softBlue : colors.grayColor,
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'ok'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
