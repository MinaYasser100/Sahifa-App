import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:video_player/video_player.dart';

class ReelVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final bool isPlaying;
  final VoidCallback onTogglePlay;

  const ReelVideoPlayer({
    super.key,
    required this.controller,
    required this.isPlaying,
    required this.onTogglePlay,
  });

  @override
  State<ReelVideoPlayer> createState() => _ReelVideoPlayerState();
}

class _ReelVideoPlayerState extends State<ReelVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTogglePlay,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video
          if (widget.controller.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: widget.controller.value.size.width,
                height: widget.controller.value.size.height,
                child: VideoPlayer(widget.controller),
              ),
            )
          else
            Container(
              color: ColorsTheme().blackColor,
              child: Center(
                child: CircularProgressIndicator(
                  color: ColorsTheme().whiteColor,
                ),
              ),
            ),

          // Play/Pause icon
          if (!widget.isPlaying && widget.controller.value.isInitialized)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: ColorsTheme().whiteColor,
                  size: 48,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
