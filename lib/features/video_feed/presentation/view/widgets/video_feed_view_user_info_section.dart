import 'package:flutter/material.dart';
import 'package:sahifa/features/video_feed/presentation/view/widgets/video_feed_view_description_text.dart';

class VideoFeedViewUserInfoSection extends StatelessWidget {
  const VideoFeedViewUserInfoSection({
    required this.userAvatarUrl,
    required this.userName,
    required this.caption,
    super.key,
  });

  final String userAvatarUrl;
  final String userName;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 8,
        children: [
          // VideoFeedViewUserHeader(
          //   userAvatarUrl: userAvatarUrl,
          //   userName: userName,
          // ),
          VideoFeedViewDescriptionText(text: caption),
        ],
      ),
    );
  }
}
