import 'package:sahifa/features/home/data/models/category_with_subcategories.dart';

class CategoriesData {
  static List<CategoryWithSubcategories> getCategories() {
    return [
      CategoryWithSubcategories(
        id: 'news',
        name: 'News',
        icon: 'newspaper',
        subcategories: [
          Subcategory(id: 'local', name: 'Local News'),
          Subcategory(id: 'international', name: 'International'),
          Subcategory(id: 'politics', name: 'Politics'),
          Subcategory(id: 'breaking', name: 'Breaking News'),
        ],
      ),
      CategoryWithSubcategories(
        id: 'sports',
        name: 'Sports',
        icon: 'sports_soccer',
        subcategories: [
          Subcategory(id: 'football', name: 'Football'),
          Subcategory(id: 'basketball', name: 'Basketball'),
          Subcategory(id: 'tennis', name: 'Tennis'),
          Subcategory(id: 'athletics', name: 'Athletics'),
        ],
      ),
      CategoryWithSubcategories(
        id: 'economy',
        name: 'Economy',
        icon: 'attach_money',
        subcategories: [
          Subcategory(id: 'market', name: 'Market News'),
          Subcategory(id: 'business', name: 'Business'),
          Subcategory(id: 'finance', name: 'Finance'),
          Subcategory(id: 'stocks', name: 'Stocks'),
        ],
      ),
      CategoryWithSubcategories(
        id: 'technology',
        name: 'Technology',
        icon: 'computer',
        subcategories: [
          Subcategory(id: 'mobile', name: 'Mobile'),
          Subcategory(id: 'ai', name: 'AI & Machine Learning'),
          Subcategory(id: 'software', name: 'Software'),
          Subcategory(id: 'gadgets', name: 'Gadgets'),
        ],
      ),
      CategoryWithSubcategories(
        id: 'entertainment',
        name: 'Entertainment',
        icon: 'movie',
        subcategories: [
          Subcategory(id: 'cinema', name: 'Cinema'),
          Subcategory(id: 'music', name: 'Music'),
          Subcategory(id: 'tv', name: 'TV Shows'),
          Subcategory(id: 'celebrities', name: 'Celebrities'),
        ],
      ),
      CategoryWithSubcategories(
        id: 'health',
        name: 'Health',
        icon: 'favorite',
        subcategories: [
          Subcategory(id: 'medical', name: 'Medical News'),
          Subcategory(id: 'fitness', name: 'Fitness'),
          Subcategory(id: 'nutrition', name: 'Nutrition'),
          Subcategory(id: 'mental', name: 'Mental Health'),
        ],
      ),
      CategoryWithSubcategories(
        id: 'culture',
        name: 'Culture',
        icon: 'menu_book',
        subcategories: [
          Subcategory(id: 'books', name: 'Books'),
          Subcategory(id: 'art', name: 'Art'),
          Subcategory(id: 'history', name: 'History'),
          Subcategory(id: 'literature', name: 'Literature'),
        ],
      ),
      CategoryWithSubcategories(
        id: 'security',
        name: 'Security & Courts',
        icon: 'security',
        subcategories: [
          Subcategory(id: 'police', name: 'Police Reports'),
          Subcategory(id: 'courts', name: 'Court Cases'),
          Subcategory(id: 'investigations', name: 'Investigations'),
          Subcategory(id: 'crime', name: 'Crime News'),
        ],
      ),
    ];
  }
}
