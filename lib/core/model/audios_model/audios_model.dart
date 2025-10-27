import 'package:sahifa/core/model/audios_model/audio_item_model.dart';

class AudiosModel {
  int? pageSize;
  int? pageNumber;
  int? totalCount;
  int? totalPages;
  int? itemsFrom;
  int? itemsTo;
  List<AudioItemModel>? audios;

  AudiosModel({
    this.pageSize,
    this.pageNumber,
    this.totalCount,
    this.totalPages,
    this.itemsFrom,
    this.itemsTo,
    this.audios,
  });

  factory AudiosModel.fromJson(Map<String, dynamic> json) => AudiosModel(
    pageSize: json['pageSize'] as int?,
    pageNumber: json['pageNumber'] as int?,
    totalCount: json['totalCount'] as int?,
    totalPages: json['totalPages'] as int?,
    itemsFrom: json['itemsFrom'] as int?,
    itemsTo: json['itemsTo'] as int?,
    audios: (json['items'] as List<dynamic>?)
        ?.map((e) => AudioItemModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'pageSize': pageSize,
    'pageNumber': pageNumber,
    'totalCount': totalCount,
    'totalPages': totalPages,
    'itemsFrom': itemsFrom,
    'itemsTo': itemsTo,
    'items': audios?.map((e) => e.toJson()).toList(),
  };
}
