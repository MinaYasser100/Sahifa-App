import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/utils/auth_checker.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/video_feed/presentation/bloc/video_feed_cubit.dart';
import 'package:sahifa/features/video_feed/presentation/view/widgets/video_feed_view_interaction_button.dart';

class VideoFeedViewInteractionButtons extends StatelessWidget {
  const VideoFeedViewInteractionButtons({
    required this.videoId,
    required this.isLiked,
    required this.isBookmarked,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    super.key,
  });

  final String videoId;
  final bool isLiked;
  final bool isBookmarked;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();
    return Padding(
      padding: const EdgeInsets.only(bottom: 100, left: 12, right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 20,
        children: [
          VideoFeedViewInteractionButton(
            icon: isLiked ? Icons.favorite : Icons.favorite_border,
            count: likesCount,
            color: isLiked ? const Color(0xFFD32F2F) : colors.whiteColor,
            onTap: () async {
              final isLoggedIn = await AuthChecker.checkAuthAndNavigate(
                context,
              );
              if (!isLoggedIn) return;

              if (!context.mounted) return;

              context.read<VideoFeedCubit>().toggleLikeForVideo(
                videoId: videoId,
                currentlyLiked: isLiked,
              );
            },
          ),
          // VideoFeedViewInteractionButton(
          //   icon: Icons.message,
          //   count: commentsCount,
          // ),
          VideoFeedViewInteractionButton(icon: Icons.share, count: sharesCount),
          // Icon(
          //   isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          //   color: colors.whiteColor,
          //   size: 36,
          // ),
        ],
      ),
    );
  }
}
