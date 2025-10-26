class SubcategoryInfoModel {
  String? id;
  String? name;
  String? slug;
  String? description;
  String? language;
  String? parentCategoryId;
  String? parentCategoryName;
  int? order;
  String? colorHex;
  bool? isActive;
  bool? showOnMenu;
  bool? showOnHomepage;
  int? subCategoriesCount;
  int? postsCount;
  String? categoryPath;
  DateTime? createdAt;
  DateTime? updatedAt;

  SubcategoryInfoModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.language,
    this.parentCategoryId,
    this.parentCategoryName,
    this.order,
    this.colorHex,
    this.isActive,
    this.showOnMenu,
    this.showOnHomepage,
    this.subCategoriesCount,
    this.postsCount,
    this.categoryPath,
    this.createdAt,
    this.updatedAt,
  });

  factory SubcategoryInfoModel.fromJson(Map<String, dynamic> json) =>
      SubcategoryInfoModel(
        id: json['id'] as String?,
        name: json['name'] as String?,
        slug: json['slug'] as String?,
        description: json['description'] as String?,
        language: json['language'] as String?,
        parentCategoryId: json['parentCategoryId'] as String?,
        parentCategoryName: json['parentCategoryName'] as String?,
        order: json['order'] as int?,
        colorHex: json['colorHex'] as String?,
        isActive: json['isActive'] as bool?,
        showOnMenu: json['showOnMenu'] as bool?,
        showOnHomepage: json['showOnHomepage'] as bool?,
        subCategoriesCount: json['subCategoriesCount'] as int?,
        postsCount: json['postsCount'] as int?,
        categoryPath: json['categoryPath'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'description': description,
    'language': language,
    'parentCategoryId': parentCategoryId,
    'parentCategoryName': parentCategoryName,
    'order': order,
    'colorHex': colorHex,
    'isActive': isActive,
    'showOnMenu': showOnMenu,
    'showOnHomepage': showOnHomepage,
    'subCategoriesCount': subCategoriesCount,
    'postsCount': postsCount,
    'categoryPath': categoryPath,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
