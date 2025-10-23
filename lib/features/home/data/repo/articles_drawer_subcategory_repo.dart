import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';

abstract class ArticlesDrawerSubcategoryRepo {
  Future<Either<String, ArticlesCategoryModel>> getArticlesDrawerSubcategory({
    required String categorySlug,
    required String language,
  });
}

class ArticlesDrawerSubcategoryRepoImpl
    implements ArticlesDrawerSubcategoryRepo {
  final DioHelper _dioHelper;
  ArticlesDrawerSubcategoryRepoImpl(this._dioHelper);
  @override
  Future<Either<String, ArticlesCategoryModel>> getArticlesDrawerSubcategory({
    required String categorySlug,
    required String language,
  }) async {
    try {
      final response = await _dioHelper.getData(
        url: ApiEndpoints.articles.path,
        query: {
          ApiQueryParams.pageSize: 30,
          ApiQueryParams.language: language,
          ApiQueryParams.categorySlug: categorySlug,
        },
      );
      final ArticlesCategoryModel articlesCategoryModel =
          ArticlesCategoryModel.fromJson(response.data);
      return Right(articlesCategoryModel);
    } catch (e) {
      return Left("Error fetching articles of this category".tr());
    }
  }
}
