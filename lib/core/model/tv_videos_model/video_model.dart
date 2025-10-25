class VideoModel {
  String? id;
  String? title;
  String? slug;
  String? summary;
  String? videoUrl;
  String? videoEmbedCode;
  String? videoThumbnailUrl;
  String? duration;
  String? resolution;
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
  String? createdAt;
  String? updatedAt;
  String? publishedAt;
  String? authorId;
  String? authorName;
  String? categoryId;
  String? categoryName;

  VideoModel({
    this.id,
    this.title,
    this.slug,
    this.summary,
    this.videoUrl,
    this.videoEmbedCode,
    this.videoThumbnailUrl,
    this.duration,
    this.resolution,
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
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.authorId,
    this.authorName,
    this.categoryId,
    this.categoryName,
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
    resolution: json['resolution'] as String?,
    viewCount: json['viewCount'] as int?,
    videoFiles: json['videoFiles'] as List<String>?,
    status: json['status'] as String?,
    language: json['language'] as String?,
    isFeatured: json['isFeatured'] as bool?,
    isBreaking: json['isBreaking'] as bool?,
    isSlider: json['isSlider'] as bool?,
    isRecommended: json['isRecommended'] as bool?,
    viewsCount: json['viewsCount'] as int?,
    likesCount: json['likesCount'] as int?,
    createdAt: json['createdAt'] as String?,
    updatedAt: json['updatedAt'] as String?,
    publishedAt: json['publishedAt'] as String?,
    authorId: json['authorId'] as String?,
    authorName: json['authorName'] as String?,
    categoryId: json['categoryId'] as String?,
    categoryName: json['categoryName'] as String?,
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
    'resolution': resolution,
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
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'publishedAt': publishedAt,
    'authorId': authorId,
    'authorName': authorName,
    'categoryId': categoryId,
    'categoryName': categoryName,
  };
}
