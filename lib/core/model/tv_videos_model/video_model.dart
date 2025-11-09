class VideoModel {
  String? id;
  String? title;
  String? slug;
  String? summary;
  String? videoUrl;
  String? videoEmbedCode;
  String? videoThumbnailUrl;
  String? duration;
  int? viewCount;
  List<String>? videoFiles;
  String? status;
  String? language;
  bool? isFeatured;
  bool? isBreaking;
  bool? isSlider;
  bool? isRecommended;
  int? viewsCount;
  int? likesCount;
  bool? isLikedByCurrentUser;
  String? createdAt;
  String? publishedAt;
  String? authorId;
  String? authorName;
  String? authorImage;
  String? categoryId;
  String? categoryName;
  String? categorySlug;
  List<String>? tags;
  List<dynamic>? likedByUsers;

  VideoModel({
    this.id,
    this.title,
    this.slug,
    this.summary,
    this.videoUrl,
    this.videoEmbedCode,
    this.videoThumbnailUrl,
    this.duration,
    this.viewCount,
    this.videoFiles,
    this.status,
    this.language,
    this.isFeatured,
    this.isBreaking,
    this.isSlider,
    this.isRecommended,
    this.viewsCount,
    this.likesCount,
    this.isLikedByCurrentUser,
    this.createdAt,
    this.publishedAt,
    this.authorId,
    this.authorName,
    this.authorImage,
    this.categoryId,
    this.categoryName,
    this.categorySlug,
    this.tags,
    this.likedByUsers,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    id: json['id'] as String?,
    title: json['title'] as String?,
    slug: json['slug'] as String?,
    summary: json['summary'] as String?,
    videoUrl: json['videoUrl'] as String?,
    videoEmbedCode: json['videoEmbedCode'] as String?,
    videoThumbnailUrl: json['videoThumbnailUrl'] as String?,
    duration: json['duration'] as String?,
    viewCount: json['viewCount'] as int?, // موجود في الريسبونس
    videoFiles: (json['videoFiles'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
    status: json['status'] as String?,
    language: json['language'] as String?,
    isFeatured: json['isFeatured'] as bool?,
    isBreaking: json['isBreaking'] as bool?,
    isSlider: json['isSlider'] as bool?,
    isRecommended: json['isRecommended'] as bool?,
    viewsCount: json['viewsCount'] as int?, // موجود في الريسبونس
    likesCount: json['likesCount'] as int?,
    isLikedByCurrentUser: json['isLikedByCurrentUser'] as bool?,
    createdAt: json['createdAt'] as String?,
    publishedAt: json['publishedAt'] as String?,
    authorId: json['authorId'] as String?,
    authorName: json['authorName'] as String?,
    authorImage: json['authorImage'] as String?,
    categoryId: json['categoryId'] as String?,
    categoryName: json['categoryName'] as String?,
    categorySlug: json['categorySlug'] as String?,
    tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    likedByUsers: (json['likedByUsers'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'slug': slug,
    'summary': summary,
    'videoUrl': videoUrl,
    'videoEmbedCode': videoEmbedCode,
    'videoThumbnailUrl': videoThumbnailUrl,
    'duration': duration,
    'viewCount': viewCount,
    'videoFiles': videoFiles,
    'status': status,
    'language': language,
    'isFeatured': isFeatured,
    'isBreaking': isBreaking,
    'isSlider': isSlider,
    'isRecommended': isRecommended,
    'viewsCount': viewsCount,
    'likesCount': likesCount,
    'isLikedByCurrentUser': isLikedByCurrentUser,
    'createdAt': createdAt,
    'publishedAt': publishedAt,
    'authorId': authorId,
    'authorName': authorName,
    'authorImage': authorImage,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'categorySlug': categorySlug,
    'tags': tags,
    'likedByUsers': likedByUsers,
  };
}
