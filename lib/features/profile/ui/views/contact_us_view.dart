import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/profile/data/model/contact_info_model.dart';
import 'package:sahifa/features/profile/ui/widgets/contact_us_widgets/contact_info_card.dart';
import 'package:sahifa/features/profile/ui/widgets/contact_us_widgets/contact_us_header.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('contact_us'.tr())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            ContactUsHeader(isDark: isDark, colors: colors),
            const SizedBox(height: 40),

            // Contact Information Cards
            ContactInfoCard(
              model: ContactInfoModel(
                icon: Icons.email_outlined,
                title: 'email_label'.tr(),
                value: 'info@althawrah.ye',
                isDark: isDark,
                onTap: () {
                  _launchEmail('info@althawrah.ye');
                },
                onCopy: () {
                  _copyToClipboard(context, 'info@althawrah.ye');
                },
              ),
            ),
            const SizedBox(height: 16),

            ContactInfoCard(
              model: ContactInfoModel(
                icon: Icons.phone_outlined,
                title: 'phone_label'.tr(),
                value: '+00000000000',
                isDark: isDark,
                onTap: () {
                  _launchPhone('+00000000000');
                },
                onCopy: () {
                  _copyToClipboard(context, '+00000000000');
                },
              ),
            ),
            const SizedBox(height: 16),

            ContactInfoCard(
              model: ContactInfoModel(
                icon: Icons.phone_android_outlined,
                title: 'mobile_label'.tr(),
                value: '+00000000000',
                isDark: isDark,
                onTap: () {
                  _launchPhone('+00000000000');
                },
                onCopy: () {
                  _copyToClipboard(context, '+00000000000');
                },
              ),
            ),
            const SizedBox(height: 16),

            ContactInfoCard(
              model: ContactInfoModel(
                icon: Icons.location_on_outlined,
                title: 'address_label'.tr(),
                value: 'address_value'.tr(),
                isDark: isDark,
                onTap: null,
                onCopy: () {
                  _copyToClipboard(context, 'address_value'.tr());
                },
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('copied_to_clipboard'.tr()),
        duration: const Duration(seconds: 2),
        backgroundColor: ColorsTheme().successColor,
      ),
    );
  }
}
