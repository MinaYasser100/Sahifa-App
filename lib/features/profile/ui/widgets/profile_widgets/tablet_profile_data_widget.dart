import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/profile/data/model/public_user_profile_model.dart';
import 'package:sahifa/features/profile/ui/widgets/profile_widgets/profile_image_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class TabletProfileDataWidget extends StatelessWidget {
  const TabletProfileDataWidget({
    super.key,
    required this.isDark,
    required this.profile,
  });

  final bool isDark;
  final PublicUserProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side - Profile Image
            Column(
              children: [
                ProfileImageWidget(
                  isDark: isDark,
                  imageUrl: profile.profileImageUrl,
                  size: 80,
                ),
                const SizedBox(height: 16),
                // Member Since Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? ColorsTheme().primaryLight
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: isDark
                            ? ColorsTheme().whiteColor
                            : ColorsTheme().primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatMemberSince(profile.memberSince),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? ColorsTheme().whiteColor
                              : ColorsTheme().primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(width: 32),

            // Right Side - Profile Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Name
                  Text(
                    profile.userName,
                    style: AppTextStyles.styleBold28sp(context).copyWith(
                      color: isDark
                          ? ColorsTheme().whiteColor
                          : ColorsTheme().blackColor,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        profile.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  // Last Seen (if available)
                  if (profile.lastSeen != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: isDark
                              ? ColorsTheme().grayColor
                              : ColorsTheme().grayColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${'last_seen'.tr()}: ${_formatDate(profile.lastSeen!)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey[500] : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],

                  // About Me (if available)
                  if (profile.aboutMe != null &&
                      profile.aboutMe!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'about_me'.tr(),
                      style: AppTextStyles.styleBold16sp(context).copyWith(
                        color: isDark
                            ? ColorsTheme().whiteColor
                            : ColorsTheme().blackColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? ColorsTheme().primaryLight
                            : ColorsTheme().grayColor.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? ColorsTheme().primaryColor
                              : ColorsTheme().grayColor,
                        ),
                      ),
                      child: Text(
                        profile.aboutMe!,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: isDark
                              ? ColorsTheme().whiteColor
                              : ColorsTheme().primaryColor,
                        ),
                      ),
                    ),
                  ],

                  // Social Accounts (if available)
                  if (profile.socialAccounts.accounts.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'social_accounts'.tr(),
                      style: AppTextStyles.styleBold16sp(context).copyWith(
                        color: isDark
                            ? ColorsTheme().whiteColor
                            : ColorsTheme().blackColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: profile.socialAccounts.accounts.entries.map((
                        entry,
                      ) {
                        return _buildDynamicSocialButton(
                          platform: entry.key,
                          url: entry.value,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicSocialButton({
    required String platform,
    required String url,
  }) {
    // Get platform-specific icon and color
    final platformData = _getPlatformData(platform.toLowerCase());

    return InkWell(
      onTap: () async {
        try {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        } catch (e) {
          // Handle invalid URL
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: ColorsTheme().whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: platformData['color'].withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(platformData['icon'], size: 20, color: platformData['color']),
            const SizedBox(width: 8),
            Text(
              platformData['label'],
              style: TextStyle(
                color: platformData['color'],
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getPlatformData(String platform) {
    switch (platform) {
      case 'facebook':
        return {
          'icon': Icons.facebook,
          'label': 'Facebook',
          'color': const Color(0xFF1877F2),
        };
      case 'twitter':
      case 'x':
        return {
          'icon': Icons.close, // X icon
          'label': 'X (Twitter)',
          'color': Colors.black,
        };
      case 'instagram':
        return {
          'icon': Icons.camera_alt,
          'label': 'Instagram',
          'color': const Color(0xFFE4405F),
        };
      case 'linkedin':
        return {
          'icon': Icons.work,
          'label': 'LinkedIn',
          'color': const Color(0xFF0A66C2),
        };
      case 'youtube':
        return {
          'icon': Icons.play_circle_filled,
          'label': 'YouTube',
          'color': const Color(0xFFFF0000),
        };
      case 'github':
        return {'icon': Icons.code, 'label': 'GitHub', 'color': Colors.black};
      case 'website':
      case 'portfolio':
        return {
          'icon': Icons.language,
          'label': 'Website',
          'color': const Color(0xFF2196F3),
        };
      default:
        return {
          'icon': Icons.link,
          'label': platform[0].toUpperCase() + platform.substring(1),
          'color': isDark ? Colors.grey[400]! : Colors.grey[700]!,
        };
    }
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

  String _formatMemberSince(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final formatter = DateFormat('MMM yyyy');
      return formatter.format(date);
    } catch (e) {
      return dateString;
    }
  }
}
