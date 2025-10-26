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
  int? subCategoriesCount;
  String? parentCategoryId;
  String? parentCategoryName;
  String? parentCategorySlug;
  int? parentCategoryPostsCount;
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
    this.subCategoriesCount,
    this.parentCategoryId,
    this.parentCategoryName,
    this.parentCategorySlug,
    this.parentCategoryPostsCount,
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
      subCategoriesCount: json['subCategoriesCount'] as int?,
      parentCategoryId: json['parentCategoryId'] as String?,
      parentCategoryName: json['parentCategoryName'] as String?,
      parentCategorySlug: json['parentCategorySlug'] as String?,
      parentCategoryPostsCount: json['parentCategoryPostsCount'] as int?,
      subcategories: (json['subCategories'] as List<dynamic>?)
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
    'subCategoriesCount': subCategoriesCount,
    'parentCategoryId': parentCategoryId,
    'parentCategoryName': parentCategoryName,
    'parentCategorySlug': parentCategorySlug,
    'parentCategoryPostsCount': parentCategoryPostsCount,
    'subCategories': subcategories?.map((e) => e.toJson()).toList(),
  };
}
