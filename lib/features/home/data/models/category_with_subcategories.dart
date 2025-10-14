class CategoryWithSubcategories {
  final String id;
  final String name;
  final String icon;
  final List<Subcategory> subcategories;

  CategoryWithSubcategories({
    required this.id,
    required this.name,
    required this.icon,
    required this.subcategories,
  });
}

class Subcategory {
  final String id;
  final String name;
  final String? icon;

  Subcategory({required this.id, required this.name, this.icon});
}
