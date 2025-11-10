import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';

class SocialAccountsSection extends StatelessWidget {
  final TextEditingController facebookController;
  final TextEditingController twitterController;
  final TextEditingController instagramController;
  final TextEditingController linkedInController;

  const SocialAccountsSection({
    super.key,
    required this.facebookController,
    required this.twitterController,
    required this.instagramController,
    required this.linkedInController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'social_accounts'.tr(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Facebook
        _buildSocialField(
          label: 'Facebook',
          controller: facebookController,
          icon: Icons.facebook,
          hintKey: 'enter_facebook_url',
        ),
        const SizedBox(height: 12),

        // Twitter
        _buildSocialField(
          label: 'Twitter',
          controller: twitterController,
          icon: Icons.sports_basketball,
          hintKey: 'enter_twitter_url',
        ),
        const SizedBox(height: 12),

        // Instagram
        _buildSocialField(
          label: 'Instagram',
          controller: instagramController,
          icon: Icons.camera_alt,
          hintKey: 'enter_instagram_url',
        ),
        const SizedBox(height: 12),

        // LinkedIn
        _buildSocialField(
          label: 'LinkedIn',
          controller: linkedInController,
          icon: Icons.work,
          hintKey: 'enter_linkedin_url',
        ),
      ],
    );
  }

  Widget _buildSocialField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hintKey,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              '$label:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CustomTextFormField(
          textFieldModel: TextFieldModel(
            controller: controller,
            hintText: hintKey.tr(),
            keyboardType: TextInputType.url,
            validator: (value) => null, // Optional field
          ),
        ),
      ],
    );
  }
}
