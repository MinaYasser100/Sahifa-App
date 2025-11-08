import 'package:sahifa/core/model/tv_videos_model/video_model.dart';

class TvVideosModel {
  int? pageSize;
  int? pageNumber;
  int? totalCount;
  int? totalPages;
  int? itemsFrom;
  int? itemsTo;
  List<VideoModel>? videos;

  TvVideosModel({
    this.pageSize,
    this.pageNumber,
    this.totalCount,
    this.totalPages,
    this.itemsFrom,
    this.itemsTo,
    this.videos,
  });

  factory TvVideosModel.fromJson(Map<String, dynamic> json) => TvVideosModel(
        pageSize: json['pageSize'] as int?,
        pageNumber: json['pageNumber'] as int?,
        totalCount: json['totalCount'] as int?,
        totalPages: json['totalPages'] as int?,
        itemsFrom: json['itemsFrom'] as int?,
        itemsTo: json['itemsTo'] as int?,
        videos: (json['items'] as List<dynamic>?)
            ?.map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'pageSize': pageSize,
        'pageNumber': pageNumber,
        'totalCount': totalCount,
        'totalPages': totalPages,
        'itemsFrom': itemsFrom,
        'itemsTo': itemsTo,
        'items': videos?.map((e) => e.toJson()).toList(),
      };
}
