class ArticleModel {
  String? id;
  String? title;
  String? slug;
  String? summary;
  String? image;
  String? imageDescription;
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
  String? authorName;
  String? categoryId;
  String? categoryName;
  String? categorySlug;

  ArticleModel({
    this.id,
    this.title,
    this.slug,
    this.summary,
    this.image,
    this.imageDescription,
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
    this.authorName,
    this.categoryId,
    this.categoryName,
    this.categorySlug,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
    id: json['id'] as String?,
    title: json['title'] as String?,
    slug: json['slug'] as String?,
    summary: json['summary'] as String?,
    image: json['image'] as String?,
    imageDescription: json['imageDescription'] as String?,
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
    'image': image,
    'imageDescription': imageDescription,
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
    'authorName': authorName,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'categorySlug': categorySlug,
  };
}
