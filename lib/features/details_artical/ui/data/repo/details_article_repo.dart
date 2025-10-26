import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';

abstract class DetailsArticleRepo {
  Future<Either<String, ArticleModel>> getArticleDetails({
    required String articleSlug,
    required String categorySlug,
  });
}

class DetailsArticleRepoImpl implements DetailsArticleRepo {
  final DioHelper _dioHelper;
  DetailsArticleRepoImpl(this._dioHelper);
  @override
  Future<Either<String, ArticleModel>> getArticleDetails({
    required String articleSlug,
    required String categorySlug,
  }) async {
    try {
      final response = await _dioHelper.getData(
        url: ApiEndpoints.articleDetails.path,
        query: {
          ApiQueryParams.slug: articleSlug,
          ApiQueryParams.categorySlug: categorySlug,
        },
      );
      final ArticleModel articleModel = ArticleModel.fromJson(
        response.data['data'],
      );
      return Right(articleModel);
    } catch (e) {
      log("Error fetching article details: $e");
      return Left("Error fetching article details".tr());
    }
  }
}
