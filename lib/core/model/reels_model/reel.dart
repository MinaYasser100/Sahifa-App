class Reel {
  final String id;
  final String videoUrl;
  final String? thumbnailUrl;
  final String? caption;
  final String? duration;
  final int viewsCount;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isPublished;
  final DateTime? createdAt;
  final String userId;
  final String? userName;
  final String? userAvatarUrl;
  final List<String>? tags;
  final bool? isLikedByCurrentUser;

  const Reel({
    required this.id,
    required this.videoUrl,
    this.thumbnailUrl,
    this.caption,
    this.duration,
    required this.viewsCount,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.isPublished,
    this.createdAt,
    required this.userId,
    this.userName,
    this.userAvatarUrl,
    this.tags,
    this.isLikedByCurrentUser,
  });

  factory Reel.fromJson(Map<String, dynamic> json) => Reel(
    id: json['id'] as String,
    videoUrl: json['videoUrl'] as String,
    thumbnailUrl: json['thumbnailUrl'] as String?,
    caption: json['caption'] as String?,
    duration: json['duration'] as String?,
    viewsCount: json['viewsCount'] as int? ?? 0,
    likesCount: json['likesCount'] as int? ?? 0,
    commentsCount: json['commentsCount'] as int? ?? 0,
    sharesCount: json['sharesCount'] as int? ?? 0,
    isPublished: json['isPublished'] as bool? ?? true,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    userId: json['userId'] as String,
    userName: json['userName'] as String?,
    userAvatarUrl: json['userAvatarUrl'] as String?,
    tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
    isLikedByCurrentUser: json['isLikedByCurrentUser'] as bool?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'videoUrl': videoUrl,
    'thumbnailUrl': thumbnailUrl,
    'caption': caption,
    'duration': duration,
    'viewsCount': viewsCount,
    'likesCount': likesCount,
    'commentsCount': commentsCount,
    'sharesCount': sharesCount,
    'isPublished': isPublished,
    'createdAt': createdAt?.toIso8601String(),
    'userId': userId,
    'userName': userName,
    'userAvatarUrl': userAvatarUrl,
    'tags': tags,
    'isLikedByCurrentUser': isLikedByCurrentUser,
  };

  Reel copyWith({
    String? id,
    String? videoUrl,
    String? thumbnailUrl,
    String? caption,
    String? duration,
    int? viewsCount,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isPublished,
    DateTime? createdAt,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    List<String>? tags,
    bool? isLikedByCurrentUser,
  }) {
    return Reel(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      caption: caption ?? this.caption,
      duration: duration ?? this.duration,
      viewsCount: viewsCount ?? this.viewsCount,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      tags: tags ?? this.tags,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
    );
  }
}
