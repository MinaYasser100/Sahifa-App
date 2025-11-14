class ArticleModel {
  String? id;
  String? title;
  String? slug;
  String? summary;
  String? image;
  String? imageDescription;
  String? content;
  String? status;
  String? language;
  String? postType;
  bool? isFeatured;
  bool? isBreaking;
  bool? isSlider;
  bool? isRecommended;
  int? viewsCount;
  int? likesCount;
  String? createdAt;
  String? publishedAt;
  String? authorId;
  String? authorName;
  String? authorImage;
  bool? ownerIsAuthor;
  String? categoryId;
  String? categoryName;
  String? categorySlug;
  List<String>? tags;
  List<dynamic>? likedByUsers;
  bool? isLikedByCurrentUser;

  ArticleModel({
    this.id,
    this.title,
    this.slug,
    this.summary,
    this.image,
    this.imageDescription,
    this.content,
    this.status,
    this.language,
    this.postType,
    this.isFeatured,
    this.isBreaking,
    this.isSlider,
    this.isRecommended,
    this.viewsCount,
    this.likesCount,
    this.createdAt,
    this.publishedAt,
    this.authorId,
    this.authorName,
    this.authorImage,
    this.ownerIsAuthor,
    this.categoryId,
    this.categoryName,
    this.categorySlug,
    this.tags,
    this.likedByUsers,
    this.isLikedByCurrentUser,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
    id: json['id'] as String?,
    title: json['title'] as String?,
    slug: json['slug'] as String?,
    summary: json['description'] as String?,
    image: json['image'] as String?,
    imageDescription: json['imageDescription'] as String?,
    content: json['content'] as String?,
    status: json['status'] as String?,
    language: json['language'] as String?,
    postType: json['postType'] as String?,
    isFeatured: json['isFeatured'] as bool?,
    isBreaking: json['isBreaking'] as bool?,
    isSlider: json['isSlider'] as bool?,
    isRecommended: json['isRecommended'] as bool?,
    viewsCount: json['viewsCount'] as int?,
    likesCount: json['likesCount'] as int?,
    createdAt: json['createdAt'] as String?,
    publishedAt: json['publishedAt'] as String?,
    authorId: json['authorId'] as String?,
    authorName: json['authorName'] as String?,
    authorImage: json['authorImage'] as String?,
    ownerIsAuthor: json['ownerIsAuthor'] as bool?,
    categoryId: json['categoryId'] as String?,
    categoryName: json['categoryName'] as String?,
    categorySlug: json['categorySlug'] as String?,
    tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    likedByUsers: json['likedByUsers'] as List<dynamic>?,
    isLikedByCurrentUser: json['isLikedByCurrentUser'] as bool?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'slug': slug,
    'description': summary,
    'image': image,
    'imageDescription': imageDescription,
    'content': content,
    'status': status,
    'language': language,
    'postType': postType,
    'isFeatured': isFeatured,
    'isBreaking': isBreaking,
    'isSlider': isSlider,
    'isRecommended': isRecommended,
    'viewsCount': viewsCount,
    'likesCount': likesCount,
    'createdAt': createdAt,
    'publishedAt': publishedAt,
    'authorId': authorId,
    'authorName': authorName,
    'authorImage': authorImage,
    'ownerIsAuthor': ownerIsAuthor,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'categorySlug': categorySlug,
    'tags': tags,
    'likedByUsers': likedByUsers,
    'isLikedByCurrentUser': isLikedByCurrentUser,
  };
}
