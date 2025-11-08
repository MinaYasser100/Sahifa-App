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
          SubcategoryModel(
            id: 'local',
            name: 'local_news'.tr(),
            categoryId: 'news',
          ),
          SubcategoryModel(
            id: 'international',
            name: 'international'.tr(),
            categoryId: 'news',
          ),
          SubcategoryModel(
            id: 'politics',
            name: 'politics'.tr(),
            categoryId: 'news',
          ),
          SubcategoryModel(
            id: 'breaking',
            name: 'breaking_news'.tr(),
            categoryId: 'news',
          ),
        ],
      ),
      CategoryWithSubcategories(
        id: 'sports',
        name: 'sports'.tr(),
        icon: 'sports_soccer',
        subcategories: [
          SubcategoryModel(
            id: 'football',
            name: 'football'.tr(),
            categoryId: 'sports',
          ),
          SubcategoryModel(
            id: 'basketball',
            name: 'basketball'.tr(),
            categoryId: 'sports',
          ),
          SubcategoryModel(
            id: 'tennis',
            name: 'tennis'.tr(),
            categoryId: 'sports',
          ),
          SubcategoryModel(
            id: 'athletics',
            name: 'athletics'.tr(),
            categoryId: 'sports',
          ),
        ],
      ),
      CategoryWithSubcategories(
        id: 'economy',
        name: 'economy'.tr(),
        icon: 'attach_money',
        subcategories: [
          SubcategoryModel(
            id: 'market',
            name: 'market_news'.tr(),
            categoryId: 'economy',
          ),
          SubcategoryModel(
            id: 'business',
            name: 'business'.tr(),
            categoryId: 'economy',
          ),
          SubcategoryModel(
            id: 'finance',
            name: 'finance'.tr(),
            categoryId: 'economy',
          ),
          SubcategoryModel(
            id: 'stocks',
            name: 'stocks'.tr(),
            categoryId: 'economy',
          ),
        ],
      ),
      CategoryWithSubcategories(
        id: 'technology',
        name: 'technology'.tr(),
        icon: 'computer',
        subcategories: [
          SubcategoryModel(
            id: 'mobile',
            name: 'mobile'.tr(),
            categoryId: 'technology',
          ),
          SubcategoryModel(
            id: 'ai',
            name: 'ai_machine_learning'.tr(),
            categoryId: 'technology',
          ),
          SubcategoryModel(
            id: 'software',
            name: 'software'.tr(),
            categoryId: 'technology',
          ),
          SubcategoryModel(
            id: 'gadgets',
            name: 'gadgets'.tr(),
            categoryId: 'technology',
          ),
        ],
      ),
      CategoryWithSubcategories(
        id: 'entertainment',
        name: 'entertainment'.tr(),
        icon: 'movie',
        subcategories: [
          SubcategoryModel(
            id: 'cinema',
            name: 'cinema'.tr(),
            categoryId: 'entertainment',
          ),
          SubcategoryModel(
            id: 'music',
            name: 'music'.tr(),
            categoryId: 'entertainment',
          ),
          SubcategoryModel(
            id: 'tv',
            name: 'tv_shows'.tr(),
            categoryId: 'entertainment',
          ),
          SubcategoryModel(
            id: 'celebrities',
            name: 'celebrities'.tr(),
            categoryId: 'entertainment',
          ),
        ],
      ),
      CategoryWithSubcategories(
        id: 'health',
        name: 'health'.tr(),
        icon: 'favorite',
        subcategories: [
          SubcategoryModel(
            id: 'medical',
            name: 'medical_news'.tr(),
            categoryId: 'health',
          ),
          SubcategoryModel(
            id: 'fitness',
            name: 'fitness'.tr(),
            categoryId: 'health',
          ),
          SubcategoryModel(
            id: 'nutrition',
            name: 'nutrition'.tr(),
            categoryId: 'health',
          ),
          SubcategoryModel(
            id: 'mental',
            name: 'mental_health'.tr(),
            categoryId: 'health',
          ),
        ],
      ),
      CategoryWithSubcategories(
        id: 'culture',
        name: 'culture'.tr(),
        icon: 'menu_book',
        subcategories: [
          SubcategoryModel(
            id: 'books',
            name: 'books'.tr(),
            categoryId: 'culture',
          ),
          SubcategoryModel(id: 'art', name: 'art'.tr(), categoryId: 'culture'),
          SubcategoryModel(
            id: 'history',
            name: 'history'.tr(),
            categoryId: 'culture',
          ),
          SubcategoryModel(
            id: 'literature',
            name: 'literature'.tr(),
            categoryId: 'culture',
          ),
        ],
      ),
      CategoryWithSubcategories(
        id: 'security',
        name: 'security_courts'.tr(),
        icon: 'security',
        subcategories: [
          SubcategoryModel(
            id: 'police',
            name: 'police_reports'.tr(),
            categoryId: 'security',
          ),
          SubcategoryModel(
            id: 'courts',
            name: 'court_cases'.tr(),
            categoryId: 'security',
          ),
          SubcategoryModel(
            id: 'investigations',
            name: 'investigations'.tr(),
            categoryId: 'security',
          ),
          SubcategoryModel(
            id: 'crime',
            name: 'crime_news'.tr(),
            categoryId: 'security',
          ),
        ],
      ),
    ];
  }
}
