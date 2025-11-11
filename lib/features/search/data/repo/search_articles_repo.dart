import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class SearchArticlesRepo {
  Future<Either<String, List<ArticleModel>>> searchArticles({
    required String query,
    required String language,
    CancelToken? cancelToken,
  });
}

class SearchArticlesRepoImpl implements SearchArticlesRepo {
  final DioHelper _dioHelper;
  SearchArticlesRepoImpl(this._dioHelper);

  @override
  Future<Either<String, List<ArticleModel>>> searchArticles({
    required String query,
    required String language,
    CancelToken? cancelToken,
  }) async {
    try {
      final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
        language,
      );

      final response = await _dioHelper.getData(
        url: ApiEndpoints.posts.path,
        query: {
          ApiQueryParams.search: query,
          ApiQueryParams.pageSize: 30,
          ApiQueryParams.language: backendLanguage,
          ApiQueryParams.type: PostType.article.value,
          ApiQueryParams.includeLikedByUsers: true,
        },
        cancelToken: cancelToken,
      );

      final ArticlesCategoryModel articlesCategoryModel =
          ArticlesCategoryModel.fromJson(response.data);
      return Right(articlesCategoryModel.articles ?? []);
    } on DioException catch (e) {
      // Check if request was cancelled
      if (e.type == DioExceptionType.cancel) {
        log('Search request cancelled: $query');
        return Left("search_cancelled".tr());
      }
      log('Error searching articles: $e');
      return Left("Error searching articles".tr());
    } catch (e) {
      log('Error searching articles: $e');
      return Left("Error searching articles".tr());
    }
  }
}
