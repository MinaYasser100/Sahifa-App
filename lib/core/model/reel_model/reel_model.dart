// lib/features/reels/data/models/reel_model.dart
class ReelModel {
  final String id;
  final String videoUrl;
  final String userName;
  final String userAvatar;
  final String caption;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;

  ReelModel({
    required this.id,
    required this.videoUrl,
    required this.userName,
    required this.userAvatar,
    required this.caption,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isLiked = false,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['id'],
      videoUrl: json['video_url'],
      userName: json['user_name'],
      userAvatar: json['user_avatar'] ?? '',
      caption: json['caption'] ?? '',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
      isLiked: json['is_liked'] ?? false,
    );
  }

  ReelModel copyWith({bool? isLiked, int? likes}) {
    return ReelModel(
      id: id,
      videoUrl: videoUrl,
      userName: userName,
      userAvatar: userAvatar,
      caption: caption,
      likes: likes ?? this.likes,
      comments: comments,
      shares: shares,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'video_url': videoUrl,
      'user_name': userName,
      'user_avatar': userAvatar,
      'caption': caption,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'is_liked': isLiked,
    };
  }
}
