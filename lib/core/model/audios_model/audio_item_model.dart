class AudioItemModel {
  String? id;
  String? title;
  String? slug;
  String? summary;
  String? audioUrl;
  String? imageUrl;
  String? content;
  String? duration;
  String? fileSize;
  String? format;
  String? status;
  String? language;
  bool? isFeatured;
  bool? isBreaking;
  bool? isSlider;
  bool? isRecommended;
  int? viewsCount;
  int? likesCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  String? authorId;
  String? authorName;
  String? categoryId;
  String? categoryName;
  String? categorySlug;

  AudioItemModel({
    this.id,
    this.title,
    this.slug,
    this.summary,
    this.audioUrl,
    this.imageUrl,
    this.content,
    this.duration,
    this.fileSize,
    this.format,
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
    this.categorySlug,
  });

  factory AudioItemModel.fromJson(Map<String, dynamic> json) => AudioItemModel(
    id: json['id'] as String?,
    title: json['title'] as String?,
    slug: json['slug'] as String?,
    summary: json['summary'] as String?,
    audioUrl: json['audioUrl'] as String?,
    imageUrl: json['imageUrl'] as String?,
    content: json['content'] as String?,
    duration: json['duration'] as String?,
    fileSize: json['fileSize'] as String?,
    format: json['format'] as String?,
    status: json['status'] as String?,
    language: json['language'] as String?,
    isFeatured: json['isFeatured'] as bool?,
    isBreaking: json['isBreaking'] as bool?,
    isSlider: json['isSlider'] as bool?,
    isRecommended: json['isRecommended'] as bool?,
    viewsCount: json['viewsCount'] as int?,
    likesCount: json['likesCount'] as int?,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
    publishedAt: json['publishedAt'] == null
        ? null
        : DateTime.parse(json['publishedAt'] as String),
    authorId: json['authorId'] as String?,
    authorName: json['authorName'] as String?,
    categoryId: json['categoryId'] as String?,
    categoryName: json['categoryName'] as String?,
    categorySlug: json['categorySlug'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'slug': slug,
    'summary': summary,
    'audioUrl': audioUrl,
    'imageUrl': imageUrl,
    'content': content,
    'duration': duration,
    'fileSize': fileSize,
    'format': format,
    'status': status,
    'language': language,
    'isFeatured': isFeatured,
    'isBreaking': isBreaking,
    'isSlider': isSlider,
    'isRecommended': isRecommended,
    'viewsCount': viewsCount,
    'likesCount': likesCount,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'publishedAt': publishedAt?.toIso8601String(),
    'authorId': authorId,
    'authorName': authorName,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'categorySlug': categorySlug,
  };
}
