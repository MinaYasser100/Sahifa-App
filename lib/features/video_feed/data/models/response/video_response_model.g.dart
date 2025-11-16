// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoResponseModel _$VideoResponseModelFromJson(Map<String, dynamic> json) =>
    VideoResponseModel(
      id: json['id'] as String,
      videoUrl: json['videoUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      caption: json['caption'] as String?,
      duration: json['duration'] as String?,
      viewsCount: (json['viewsCount'] as num).toInt(),
      likesCount: (json['likesCount'] as num).toInt(),
      commentsCount: (json['commentsCount'] as num).toInt(),
      sharesCount: (json['sharesCount'] as num).toInt(),
      isPublished: json['isPublished'] as bool? ?? true,
      createdAt: VideoResponseModel._timestampFromJson(json['createdAt']),
      userId: json['userId'] as String,
      userName: json['userName'] as String?,
      userAvatarUrl: json['userAvatarUrl'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      isLikedByCurrentUser: json['isLikedByCurrentUser'] as bool?,
    );

Map<String, dynamic> _$VideoResponseModelToJson(VideoResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'videoUrl': instance.videoUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'caption': instance.caption,
      'duration': instance.duration,
      'viewsCount': instance.viewsCount,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'sharesCount': instance.sharesCount,
      'isPublished': instance.isPublished,
      'createdAt': instance.createdAt == null
          ? null
          : VideoResponseModel._timestampToJson(instance.createdAt!),
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatarUrl': instance.userAvatarUrl,
      'tags': instance.tags,
      'isLikedByCurrentUser': instance.isLikedByCurrentUser,
    };
