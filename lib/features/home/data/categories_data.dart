import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/features/home/data/models/category_with_subcategories.dart';

class CategoriesData {
  static List<CategoryWithSubcategories> getCategories() {
    return [
      CategoryWithSubcategories(
        id: 'news',
        name: 'news'.tr(),
        icon: 'newspaper',
        subcategories: [
          Subcategory(id: 'local', name: 'local_news'.tr()),
          Subcategory(id: 'international', name: 'international'.tr()),
          Subcategory(id: 'politics', name: 'politics'.tr()),
          Subcategory(id: 'breaking', name: 'breaking_news'.tr()),
        ],
      ),
      CategoryWithSubcategories(
        id: 'sports',
        name: 'sports'.tr(),
        icon: 'sports_soccer',
        subcategories: [
          Subcategory(id: 'football', name: 'football'.tr()),
          Subcategory(id: 'basketball', name: 'basketball'.tr()),
          Subcategory(id: 'tennis', name: 'tennis'.tr()),
          Subcategory(id: 'athletics', name: 'athletics'.tr()),
        ],
      ),
      CategoryWithSubcategories(
        id: 'economy',
        name: 'economy'.tr(),
        icon: 'attach_money',
        subcategories: [
          Subcategory(id: 'market', name: 'market_news'.tr()),
          Subcategory(id: 'business', name: 'business'.tr()),
          Subcategory(id: 'finance', name: 'finance'.tr()),
          Subcategory(id: 'stocks', name: 'stocks'.tr()),
        ],
      ),
      CategoryWithSubcategories(
        id: 'technology',
        name: 'technology'.tr(),
        icon: 'computer',
        subcategories: [
          Subcategory(id: 'mobile', name: 'mobile'.tr()),
          Subcategory(id: 'ai', name: 'ai_machine_learning'.tr()),
          Subcategory(id: 'software', name: 'software'.tr()),
          Subcategory(id: 'gadgets', name: 'gadgets'.tr()),
        ],
      ),
      CategoryWithSubcategories(
        id: 'entertainment',
        name: 'entertainment'.tr(),
        icon: 'movie',
        subcategories: [
          Subcategory(id: 'cinema', name: 'cinema'.tr()),
          Subcategory(id: 'music', name: 'music'.tr()),
          Subcategory(id: 'tv', name: 'tv_shows'.tr()),
          Subcategory(id: 'celebrities', name: 'celebrities'.tr()),
        ],
      ),
      CategoryWithSubcategories(
        id: 'health',
        name: 'health'.tr(),
        icon: 'favorite',
        subcategories: [
          Subcategory(id: 'medical', name: 'medical_news'.tr()),
          Subcategory(id: 'fitness', name: 'fitness'.tr()),
          Subcategory(id: 'nutrition', name: 'nutrition'.tr()),
          Subcategory(id: 'mental', name: 'mental_health'.tr()),
        ],
      ),
      CategoryWithSubcategories(
        id: 'culture',
        name: 'culture'.tr(),
        icon: 'menu_book',
        subcategories: [
          Subcategory(id: 'books', name: 'books'.tr()),
          Subcategory(id: 'art', name: 'art'.tr()),
          Subcategory(id: 'history', name: 'history'.tr()),
          Subcategory(id: 'literature', name: 'literature'.tr()),
        ],
      ),
      CategoryWithSubcategories(
        id: 'security',
        name: 'security_courts'.tr(),
        icon: 'security',
        subcategories: [
          Subcategory(id: 'police', name: 'police_reports'.tr()),
          Subcategory(id: 'courts', name: 'court_cases'.tr()),
          Subcategory(id: 'investigations', name: 'investigations'.tr()),
          Subcategory(id: 'crime', name: 'crime_news'.tr()),
        ],
      ),
    ];
  }
}
