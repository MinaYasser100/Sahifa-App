import 'pdf_model.dart';

class MagazineModel {
  int? pageSize;
  int? pageNumber;
  int? totalCount;
  int? totalPages;
  int? itemsFrom;
  int? itemsTo;
  List<PdfModel>? items;

  MagazineModel({
    this.pageSize,
    this.pageNumber,
    this.totalCount,
    this.totalPages,
    this.itemsFrom,
    this.itemsTo,
    this.items,
  });

  factory MagazineModel.fromJson(Map<String, dynamic> json) => MagazineModel(
    pageSize: json['pageSize'] as int?,
    pageNumber: json['pageNumber'] as int?,
    totalCount: json['totalCount'] as int?,
    totalPages: json['totalPages'] as int?,
    itemsFrom: json['itemsFrom'] as int?,
    itemsTo: json['itemsTo'] as int?,
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => PdfModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'pageSize': pageSize,
    'pageNumber': pageNumber,
    'totalCount': totalCount,
    'totalPages': totalPages,
    'itemsFrom': itemsFrom,
    'itemsTo': itemsTo,
    'items': items?.map((e) => e.toJson()).toList(),
  };
}
