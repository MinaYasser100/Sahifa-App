import 'gallery_model.dart';

class GalleriesModel {
  String? id;
  String? title;
  String? slug;
  String? description;
  String? language;
  String? categoryId;
  String? categoryName;
  String? categorySlug;
  String? authorId;
  String? authorName;
  String? authorImage;
  bool? ownerIsAuthor;
  int? pageViews;
  int? likesCount;
  bool? isLikedByCurrentUser;
  String? status;
  String? imageUrl;
  String? imageDescription;
  bool? showItemNumbersInPostDetailsPage;
  List<GalleryModel>? items;
  List<String>? tags;
  DateTime? createdAt;
  String? createdBy;
  List<dynamic>? likedByUsers;

  GalleriesModel({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.language,
    this.categoryId,
    this.categoryName,
    this.categorySlug,
    this.authorId,
    this.authorName,
    this.authorImage,
    this.ownerIsAuthor,
    this.pageViews,
    this.likesCount,
    this.isLikedByCurrentUser,
    this.status,
    this.imageUrl,
    this.imageDescription,
    this.showItemNumbersInPostDetailsPage,
    this.items,
    this.tags,
    this.createdAt,
    this.createdBy,
    this.likedByUsers,
  });

  factory GalleriesModel.fromJson(Map<String, dynamic> json) {
    return GalleriesModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      language: json['language'] as String?,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      categorySlug: json['categorySlug'] as String?,
      authorId: json['authorId'] as String?,
      authorName: json['authorName'] as String?,
      authorImage: json['authorImage'] as String?,
      ownerIsAuthor: json['ownerIsAuthor'] as bool?,
      pageViews: json['pageViews'] as int?,
      likesCount: json['likesCount'] as int?,
      isLikedByCurrentUser: json['isLikedByCurrentUser'] as bool?,
      status: json['status'] as String?,
      imageUrl: json['imageUrl'] as String?,
      imageDescription: json['imageDescription'] as String?,
      showItemNumbersInPostDetailsPage:
          json['showItemNumbersInPostDetailsPage'] as bool?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => GalleryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String?,
      likedByUsers: json['likedByUsers'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'slug': slug,
    'description': description,
    'language': language,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'categorySlug': categorySlug,
    'authorId': authorId,
    'authorName': authorName,
    'authorImage': authorImage,
    'ownerIsAuthor': ownerIsAuthor,
    'pageViews': pageViews,
    'likesCount': likesCount,
    'isLikedByCurrentUser': isLikedByCurrentUser,
    'status': status,
    'imageUrl': imageUrl,
    'imageDescription': imageDescription,
    'showItemNumbersInPostDetailsPage': showItemNumbersInPostDetailsPage,
    'items': items?.map((e) => e.toJson()).toList(),
    'tags': tags,
    'createdAt': createdAt?.toIso8601String(),
    'createdBy': createdBy,
    'likedByUsers': likedByUsers,
  };
}
