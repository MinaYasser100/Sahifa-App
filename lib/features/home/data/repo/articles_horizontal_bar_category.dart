import 'package:dartz/dartz.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';

abstract class ArticlesHorizontalBarCategoryRepo {
  Future<Either<String, ArticlesCategoryModel>> getArticlesByCategory(
    String categorySlug,
    String language,
  );
}

class ArticlesHorizontalBarCategoryRepoImpl
    implements ArticlesHorizontalBarCategoryRepo {
  final DioHelper _dioHelper;

  ArticlesHorizontalBarCategoryRepoImpl(this._dioHelper);
  @override
  Future<Either<String, ArticlesCategoryModel>> getArticlesByCategory(
    String categorySlug,
    String language,
  ) async {
    try {
      final response = await _dioHelper.getData(
        url: ApiEndpoints.articles.path,
        query: {
          ApiQueryParams.categorySlug: categorySlug,
          ApiQueryParams.pageSize: 30,
          ApiQueryParams.language: language,
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
