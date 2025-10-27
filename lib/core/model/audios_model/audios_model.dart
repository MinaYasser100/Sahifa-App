import 'item.dart';

class AudioModel {
  int? pageSize;
  int? pageNumber;
  int? totalCount;
  int? totalPages;
  int? itemsFrom;
  int? itemsTo;
  List<Item>? items;

  AudioModel({
    this.pageSize,
    this.pageNumber,
    this.totalCount,
    this.totalPages,
    this.itemsFrom,
    this.itemsTo,
    this.items,
  });

  factory AudioModel.fromJson(Map<String, dynamic> json) => AudioModel(
    pageSize: json['pageSize'] as int?,
    pageNumber: json['pageNumber'] as int?,
    totalCount: json['totalCount'] as int?,
    totalPages: json['totalPages'] as int?,
    itemsFrom: json['itemsFrom'] as int?,
    itemsTo: json['itemsTo'] as int?,
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
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
