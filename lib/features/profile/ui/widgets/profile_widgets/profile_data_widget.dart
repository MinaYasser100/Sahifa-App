import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/features/profile/data/model/public_user_profile_model.dart';
import 'package:sahifa/features/profile/ui/widgets/profile_widgets/profile_image_widget.dart';

class ProfileDataWidget extends StatelessWidget {
  const ProfileDataWidget({
    super.key,
    required this.isDark,
    required this.profile,
  });

  final bool isDark;
  final PublicUserProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: Center(
        child: Column(
          children: [
            // Profile Image
            ProfileImageWidget(
              isDark: isDark,
              imageUrl: profile.profileImageUrl,
            ),
            const SizedBox(height: 16),

            // User Name
            Text(
              profile.userName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Email
            Text(
              profile.email,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),

            // Last Seen (if available)
            if (profile.lastSeen != null) ...[
              const SizedBox(height: 4),
              Text(
                '${'last_seen'.tr()}: ${_formatDate(profile.lastSeen!)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[500] : Colors.grey[500],
                ),
              ),
            ],

            // About Me (if available)
            if (profile.aboutMe != null && profile.aboutMe!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  profile.aboutMe!,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            // Social Accounts (if available)
            if (profile.socialAccounts.accounts.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSocialAccountsSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSocialAccountsSection() {
    final accounts = profile.socialAccounts.accounts;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'social_accounts'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (accounts['facebook'] != null &&
                  accounts['facebook']!.isNotEmpty)
                _buildSocialButton(
                  icon: Icons.facebook,
                  label: 'Facebook',
                  url: accounts['facebook']!,
                  color: const Color(0xFF1877F2),
                ),
              if (accounts['twitter'] != null &&
                  accounts['twitter']!.isNotEmpty)
                _buildSocialButton(
                  icon: Icons.close, // X icon
                  label: 'X (Twitter)',
                  url: accounts['twitter']!,
                  color: Colors.black,
                ),
              if (accounts['instagram'] != null &&
                  accounts['instagram']!.isNotEmpty)
                _buildSocialButton(
                  icon: Icons.photo_camera,
                  label: 'Instagram',
                  url: accounts['instagram']!,
                  color: const Color(0xFFE4405F),
                ),
              if (accounts['linkedin'] != null &&
                  accounts['linkedin']!.isNotEmpty)
                _buildSocialButton(
                  icon: Icons.business_center,
                  label: 'LinkedIn',
                  url: accounts['linkedin']!,
                  color: const Color(0xFF0A66C2),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required String url,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        // TODO: Open URL using url_launcher
        // You can implement this later
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} ${'days_ago'.tr()}';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${'hours_ago'.tr()}';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${'minutes_ago'.tr()}';
      } else {
        return 'just_now'.tr();
      }
    } catch (e) {
      return dateString;
    }
  }
}
