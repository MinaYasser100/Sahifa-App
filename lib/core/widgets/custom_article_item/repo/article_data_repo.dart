import 'package:sahifa/core/model/articles_category_model/article_model.dart';

abstract class ArticleDataRepo {
  Future<ArticleModel> fetchArticleData({
    required String articleId,
    required String language,
  });
}
