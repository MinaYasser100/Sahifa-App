// lib/features/profile/data/model/public_user_profile_model.dart

/// Model for user's social media accounts
class SocialAccounts {
  final Map<String, String> accounts;

  const SocialAccounts({required this.accounts});

  factory SocialAccounts.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const SocialAccounts(accounts: {});

    // Convert all values to strings
    final Map<String, String> stringMap = {};
    json.forEach((key, value) {
      if (value != null) {
        stringMap[key] = value.toString();
      }
    });

    return SocialAccounts(accounts: stringMap);
  }

  Map<String, dynamic> toJson() => accounts;
}

/// Model for users who liked a post
class PostLikedUserDto {
  final String userName;
  final String? imageUrl;

  const PostLikedUserDto({required this.userName, this.imageUrl});

  factory PostLikedUserDto.fromJson(Map<String, dynamic> json) {
    return PostLikedUserDto(
      userName: json['userName'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'userName': userName, 'imageUrl': imageUrl};
  }
}

/// Model for user's post summary
class UserPostSummaryDto {
  final String id;
  final String title;
  final String slug;
  final String? description;
  final String? image;
  final int viewsCount;
  final int likesCount;
  final String? publishedAt;
  final String? categorySlug;
  final List<PostLikedUserDto> likedByUsers;
  final bool? isLikedByCurrentUser;

  const UserPostSummaryDto({
    required this.id,
    required this.title,
    required this.slug,
    this.description,
    this.image,
    required this.viewsCount,
    required this.likesCount,
    this.publishedAt,
    this.categorySlug,
    this.likedByUsers = const [],
    this.isLikedByCurrentUser,
  });

  factory UserPostSummaryDto.fromJson(Map<String, dynamic> json) {
    return UserPostSummaryDto(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      image: json['image'],
      viewsCount: json['viewsCount'] ?? 0,
      likesCount: json['likesCount'] ?? 0,
      publishedAt: json['publishedAt'],
      categorySlug: json['categorySlug'],
      likedByUsers:
          (json['likedByUsers'] as List<dynamic>?)
              ?.map((e) => PostLikedUserDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isLikedByCurrentUser: json['isLikedByCurrentUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'description': description,
      'image': image,
      'viewsCount': viewsCount,
      'likesCount': likesCount,
      'publishedAt': publishedAt,
      'categorySlug': categorySlug,
      'likedByUsers': likedByUsers.map((e) => e.toJson()).toList(),
      'isLikedByCurrentUser': isLikedByCurrentUser,
    };
  }
}

/// Model for paginated list of user posts
class PagedListOfUserPostSummaryDto {
  final int pageSize;
  final int pageNumber;
  final int totalCount;
  final int totalPages;
  final int itemsFrom;
  final int itemsTo;
  final List<UserPostSummaryDto> items;

  const PagedListOfUserPostSummaryDto({
    required this.pageSize,
    required this.pageNumber,
    required this.totalCount,
    required this.totalPages,
    required this.itemsFrom,
    required this.itemsTo,
    required this.items,
  });

  factory PagedListOfUserPostSummaryDto.fromJson(Map<String, dynamic> json) {
    return PagedListOfUserPostSummaryDto(
      pageSize: json['pageSize'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      itemsFrom: json['itemsFrom'] ?? 0,
      itemsTo: json['itemsTo'] ?? 0,
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => UserPostSummaryDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageSize': pageSize,
      'pageNumber': pageNumber,
      'totalCount': totalCount,
      'totalPages': totalPages,
      'itemsFrom': itemsFrom,
      'itemsTo': itemsTo,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

/// Main model for public user profile
class PublicUserProfileModel {
  final String userName;
  final String? lastSeen;
  final String memberSince;
  final String email;
  final String? profileImageUrl;
  final String? aboutMe;
  final String slug;
  final String role;
  final SocialAccounts socialAccounts;
  final PagedListOfUserPostSummaryDto posts;

  const PublicUserProfileModel({
    required this.userName,
    this.lastSeen,
    required this.memberSince,
    required this.email,
    this.profileImageUrl,
    this.aboutMe,
    required this.slug,
    required this.role,
    required this.socialAccounts,
    required this.posts,
  });

  factory PublicUserProfileModel.fromJson(Map<String, dynamic> json) {
    return PublicUserProfileModel(
      userName: json['userName'] ?? '',
      lastSeen: json['lastSeen'],
      memberSince: json['memberSince'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      aboutMe: json['aboutMe'],
      slug: json['slug'] ?? '',
      role: json['role'] ?? '',
      socialAccounts: SocialAccounts.fromJson(json['socialAccounts']),
      posts: PagedListOfUserPostSummaryDto.fromJson(json['posts'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'lastSeen': lastSeen,
      'memberSince': memberSince,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'aboutMe': aboutMe,
      'slug': slug,
      'role': role,
      'socialAccounts': socialAccounts.toJson(),
      'posts': posts.toJson(),
    };
  }
}
