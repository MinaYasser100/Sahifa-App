class CategoryWithSubcategories {
  final String id;
  final String name;
  final String icon;
  final List<SubcategoryModel> subcategories;

  CategoryWithSubcategories({
    required this.id,
    required this.name,
    required this.icon,
    required this.subcategories,
  });
}

class SubcategoryModel {
  final String id;
  final String name;
  final String? icon;
  final String categoryId;

  SubcategoryModel({
    required this.id,
    required this.name,
    this.icon,
    required this.categoryId,
  });
}
