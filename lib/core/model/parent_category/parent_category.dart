import 'subcategory.dart';

class ParentCategory {
  String? id;
  String? name;
  String? slug;
  String? description;
  String? language;
  int? order;
  String? colorHex;
  bool? isActive;
  bool? showOnMenu;
  bool? showOnHomepage;
  int? postsCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<SubcategoryInfoModel>? subcategories;

  ParentCategory({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.language,
    this.order,
    this.colorHex,
    this.isActive,
    this.showOnMenu,
    this.showOnHomepage,
    this.postsCount,
    this.createdAt,
    this.updatedAt,
    this.subcategories,
  });

  factory ParentCategory.fromJson(Map<String, dynamic> json) {
    return ParentCategory(
      id: json['id'] as String?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      language: json['language'] as String?,
      order: json['order'] as int?,
      colorHex: json['colorHex'] as String?,
      isActive: json['isActive'] as bool?,
      showOnMenu: json['showOnMenu'] as bool?,
      showOnHomepage: json['showOnHomepage'] as bool?,
      postsCount: json['postsCount'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      subcategories: (json['subcategories'] as List<dynamic>?)
          ?.map((e) => SubcategoryInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'description': description,
    'language': language,
    'order': order,
    'colorHex': colorHex,
    'isActive': isActive,
    'showOnMenu': showOnMenu,
    'showOnHomepage': showOnHomepage,
    'postsCount': postsCount,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'subcategories': subcategories?.map((e) => e.toJson()).toList(),
  };
}
