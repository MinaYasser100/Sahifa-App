import 'package:json_annotation/json_annotation.dart';
import 'package:sahifa/features/video_feed/domain/entities/video_entity.dart';

part 'video_response_model.g.dart';

@JsonSerializable()
class VideoResponseModel {
  const VideoResponseModel({
    required this.id,
    required this.videoUrl,
    this.thumbnailUrl,
    this.caption,
    this.duration,
    required this.viewsCount,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.isPublished,
    this.createdAt,
    required this.userId,
    this.userName,
    this.userAvatarUrl,
    this.tags,
    this.isLikedByCurrentUser,
  });

  final String id;
  final String videoUrl;
  final String? thumbnailUrl;
  final String? caption;
  final String? duration;
  final int viewsCount;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isPublished;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;
  final String userId;
  final String? userName;
  final String? userAvatarUrl;
  final List<String>? tags;
  final bool? isLikedByCurrentUser;

  /// Factory constructor from JSON
  factory VideoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VideoResponseModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$VideoResponseModelToJson(this);

  /// Convert to domain entity
  VideoEntity toEntity() {
    return VideoEntity(
      id: id,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      caption: caption,
      duration: duration,
      viewsCount: viewsCount,
      likesCount: likesCount,
      commentsCount: commentsCount,
      sharesCount: sharesCount,
      isPublished: isPublished,
      createdAt: createdAt,
      userId: userId,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      tags: tags,
      isLikedByCurrentUser: isLikedByCurrentUser,
    );
  }

  /// Helper for JSON serialization of DateTime
  static DateTime _timestampFromJson(dynamic json) {
    if (json is DateTime) return json;
    if (json is String) {
      try {
        return DateTime.parse(json);
      } catch (e) {
        return DateTime.now();
      }
    }
    if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    return DateTime.now();
  }

  /// Helper for JSON deserialization of DateTime
  static String _timestampToJson(DateTime timestamp) {
    return timestamp.toIso8601String();
  }
}
