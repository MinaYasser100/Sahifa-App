import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/profile/manager/profile_user_cubit/profile_user_cubit.dart';
import 'package:sahifa/core/services/auth_service.dart';

class UserProfileSection extends StatefulWidget {
  const UserProfileSection({super.key, required this.isDark});

  final bool isDark;

  @override
  State<UserProfileSection> createState() => _UserProfileSectionState();
}

class _UserProfileSectionState extends State<UserProfileSection> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    // Get current user's info from storage
    final userInfo = await _authService.getUserInfo();
    final userName = userInfo['name']; // 'name' contains the username

    if (userName != null && userName.isNotEmpty && mounted) {
      // Fetch profile using the cubit
      context.read<ProfileUserCubit>().fetchUserProfile(userName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUserCubit, ProfileUserState>(
      builder: (context, state) {
        if (state is ProfileUserLoading) {
          return _buildLoadingState();
        }

        if (state is ProfileUserError) {
          return _buildErrorState(state.message);
        }

        if (state is ProfileUserSuccess) {
          return _buildProfileData(state);
        }

        // Initial/default state
        return _buildDefaultState();
      },
    );
  }

  Widget _buildLoadingState() {
    return FadeInDown(
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: widget.isDark
                  ? ColorsTheme().primaryLight
                  : ColorsTheme().primaryColor,
              radius: 50,
              child: CircularProgressIndicator(color: ColorsTheme().whiteColor),
            ),
            const SizedBox(height: 16),
            Text('loading'.tr(), style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return FadeInDown(
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: widget.isDark
                  ? ColorsTheme().primaryLight
                  : ColorsTheme().primaryColor,
              radius: 50,
              child: Icon(
                Icons.error_outline,
                color: ColorsTheme().whiteColor,
                size: 50,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultState() {
    return FadeInDown(
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: widget.isDark
                  ? ColorsTheme().primaryLight
                  : ColorsTheme().primaryColor,
              radius: 50,
              child: Icon(
                Icons.person,
                color: ColorsTheme().whiteColor,
                size: 50,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'User Profile'.tr(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileData(ProfileUserSuccess state) {
    final profile = state.profile;

    return FadeInDown(
      child: Center(
        child: Column(
          children: [
            // Profile Image
            _buildProfileImage(profile.profileImageUrl),
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
                color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),

            // Last Seen (if available)
            if (profile.lastSeen != null) ...[
              const SizedBox(height: 4),
              Text(
                '${'last_seen'.tr()}: ${_formatDate(profile.lastSeen!)}',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.isDark ? Colors.grey[500] : Colors.grey[500],
                ),
              ),
            ],

            // About Me (if available)
            if (profile.aboutMe != null && profile.aboutMe!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.isDark ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  profile.aboutMe!,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: widget.isDark
            ? ColorsTheme().primaryLight
            : ColorsTheme().primaryColor,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                CircularProgressIndicator(color: ColorsTheme().whiteColor),
            errorWidget: (context, url, error) =>
                Icon(Icons.person, color: ColorsTheme().whiteColor, size: 50),
          ),
        ),
      );
    }

    // Default profile image
    return CircleAvatar(
      backgroundColor: widget.isDark
          ? ColorsTheme().primaryLight
          : ColorsTheme().primaryColor,
      radius: 50,
      child: Icon(Icons.person, color: ColorsTheme().whiteColor, size: 50),
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
