import 'package:dartz/dartz.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class ArticlesHomeCategoryRepo {
  Future<Either<String, ArticlesCategoryModel>> getArticlesByCategory(
    String categorySlug,
    String language,
  );
}

class ArticlesHomeCategoryRepoImpl implements ArticlesHomeCategoryRepo {
  final DioHelper _dioHelper;
  ArticlesHomeCategoryRepoImpl(this._dioHelper);
  @override
  Future<Either<String, ArticlesCategoryModel>> getArticlesByCategory(
    String categorySlug,
    String language,
  ) async {
    try {
      // Convert language code to backend format
      final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
        language,
      );

      final response = await _dioHelper.getData(
        url: ApiEndpoints.articles.path,
        query: {
          ApiQueryParams.categorySlug: categorySlug,
          ApiQueryParams.pageSize: 15,
          ApiQueryParams.language: backendLanguage,
        },
      );
      final ArticlesCategoryModel articlesCategoryModel =
          ArticlesCategoryModel.fromJson(response.data);
      return Right(articlesCategoryModel);
    } catch (e) {
      return Left('Error fetching articles');
    }
  }
}
