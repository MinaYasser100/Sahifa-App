// lib/features/edit_info/data/model/user_update_model.dart

/// Model for updating user information
class UserUpdateModel {
  final String userId;
  final String userName;
  final String slug;
  final String? aboutMe;
  final String? avatarImage;
  final Map<String, String>? socialAccounts;

  const UserUpdateModel({
    required this.userId,
    required this.userName,
    required this.slug,
    this.aboutMe,
    this.avatarImage,
    this.socialAccounts,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'userId': userId, // Add userId to request body
      'userName': userName,
      'slug': slug,
    };

    if (aboutMe != null && aboutMe!.isNotEmpty) {
      data['aboutMe'] = aboutMe;
    }

    if (avatarImage != null && avatarImage!.isNotEmpty) {
      data['avatarImage'] = avatarImage;
    }

    if (socialAccounts != null && socialAccounts!.isNotEmpty) {
      data['socialAccounts'] = socialAccounts;
    }

    return data;
  }
}
