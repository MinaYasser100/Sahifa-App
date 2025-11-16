import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  const VideoEntity({
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
  final DateTime? createdAt;
  final String userId;
  final String? userName;
  final String? userAvatarUrl;
  final List<String>? tags;
  final bool? isLikedByCurrentUser;

  @override
  List<Object?> get props => [
    id,
    videoUrl,
    thumbnailUrl,
    caption,
    duration,
    viewsCount,
    likesCount,
    commentsCount,
    sharesCount,
    isPublished,
    createdAt,
    userId,
    userName,
    userAvatarUrl,
    tags,
    isLikedByCurrentUser,
  ];
}
