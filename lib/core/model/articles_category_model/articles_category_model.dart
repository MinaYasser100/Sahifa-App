import 'article_model.dart';

class ArticlesCategoryModel {
  int? pageSize;
  int? pageNumber;
  int? totalCount;
  int? totalPages;
  int? itemsFrom;
  int? itemsTo;
  List<ArticleModel>? articles;

  ArticlesCategoryModel({
    this.pageSize,
    this.pageNumber,
    this.totalCount,
    this.totalPages,
    this.itemsFrom,
    this.itemsTo,
    this.articles,
  });

  factory ArticlesCategoryModel.fromJson(Map<String, dynamic> json) {
    return ArticlesCategoryModel(
      pageSize: json['pageSize'] as int?,
      pageNumber: json['pageNumber'] as int?,
      totalCount: json['totalCount'] as int?,
      totalPages: json['totalPages'] as int?,
      itemsFrom: json['itemsFrom'] as int?,
      itemsTo: json['itemsTo'] as int?,
      articles: (json['items'] as List<dynamic>?)
          ?.map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'pageSize': pageSize,
    'pageNumber': pageNumber,
    'totalCount': totalCount,
    'totalPages': totalPages,
    'itemsFrom': itemsFrom,
    'itemsTo': itemsTo,
    'items': articles?.map((e) => e.toJson()).toList(),
  };
}
