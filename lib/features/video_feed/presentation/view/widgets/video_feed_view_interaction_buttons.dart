import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/video_feed/presentation/view/widgets/video_feed_view_interaction_button.dart';

class VideoFeedViewInteractionButtons extends StatelessWidget {
  const VideoFeedViewInteractionButtons({
    required this.isLiked,
    required this.isBookmarked,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    super.key,
  });

  final bool isLiked;
  final bool isBookmarked;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 20,
        children: [
          VideoFeedViewInteractionButton(
            icon: isLiked ? Icons.favorite : Icons.favorite_border,
            count: likesCount,
            color: isLiked ? const Color(0xFFD32F2F) : colors.whiteColor,
          ),
          VideoFeedViewInteractionButton(
            icon: Icons.message,
            count: commentsCount,
          ),
          VideoFeedViewInteractionButton(icon: Icons.share, count: sharesCount),
          Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: colors.whiteColor,
            size: 36,
          ),
        ],
      ),
    );
  }
}
