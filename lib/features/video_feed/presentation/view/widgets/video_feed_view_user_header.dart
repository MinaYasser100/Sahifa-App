import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/features/video_feed/presentation/view/widgets/video_feed_view_follow_button.dart';

class VideoFeedViewUserHeader extends StatelessWidget {
  const VideoFeedViewUserHeader({
    required this.userAvatarUrl,
    required this.userName,
    super.key,
  });

  final String userAvatarUrl;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();
    return Row(
      spacing: 8,
      children: [
        CircleAvatar(radius: 20, backgroundImage: NetworkImage(userAvatarUrl)),
        Text(
          userName,
          style: AppTextStyles.styleBold18sp(
            context,
          ).copyWith(color: colors.whiteColor),
        ),
        const VideoFeedViewFollowButton(),
      ],
    );
  }
}
