import 'package:flutter/material.dart';
import 'package:sahifa/features/video_feed/presentation/view/widgets/video_feed_view_interaction_buttons.dart';
import 'package:sahifa/features/video_feed/presentation/view/widgets/video_feed_view_user_info_section.dart';

class VideoFeedViewOverlaySection extends StatelessWidget {
  const VideoFeedViewOverlaySection({
    required this.userAvatarUrl,
    required this.userName,
    required this.caption,
    required this.isBookmarked,
    required this.isLiked,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    super.key,
  });

  final String userAvatarUrl;
  final String userName;
  final String caption;
  final bool isBookmarked;
  final bool isLiked;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          VideoFeedViewUserInfoSection(
            userAvatarUrl: userAvatarUrl,
            userName: userName,
            caption: caption,
          ),
          VideoFeedViewInteractionButtons(
            isLiked: isLiked,
            isBookmarked: isBookmarked,
            likesCount: likesCount,
            commentsCount: commentsCount,
            sharesCount: sharesCount,
          ),
        ],
      ),
    );
  }
}
