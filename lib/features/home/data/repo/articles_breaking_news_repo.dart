import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class ArticlesBreakingNewsRepo {
  Future<Either<String, ArticlesCategoryModel>> getBreakingNewsArticles(
    String language,
  );
}

class ArticlesBreakingNewsRepoImpl implements ArticlesBreakingNewsRepo {
  final DioHelper _dioHelper;

  ArticlesBreakingNewsRepoImpl(this._dioHelper);

  @override
  Future<Either<String, ArticlesCategoryModel>> getBreakingNewsArticles(
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
          ApiQueryParams.pageSize: 15,
          ApiQueryParams.language: backendLanguage,
          ApiQueryParams.isBreaking: true,
        },
      );
      final ArticlesCategoryModel articlesCategoryModel =
          ArticlesCategoryModel.fromJson(response.data);
      return Right(articlesCategoryModel);
    } catch (e) {
      return Left('Error fetching breaking news articles'.tr());
    }
  }
}
