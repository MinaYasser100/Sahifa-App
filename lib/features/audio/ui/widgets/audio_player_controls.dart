import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/language_helper.dart';

class AudioPlayerControls extends StatelessWidget {
  final bool isPlaying;
  final bool isBuffering;
  final VoidCallback onPlayPause;
  final VoidCallback onSeekBackward;
  final VoidCallback onSeekForward;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const AudioPlayerControls({
    super.key,
    required this.isPlaying,
    required this.isBuffering,
    required this.onPlayPause,
    required this.onSeekBackward,
    required this.onSeekForward,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = LanguageHelper.getCurrentLanguageCode(context) == 'ar';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Backward 10s
        IconButton(
          icon: Icon(
            isArabic ? Icons.forward_10 : Icons.replay_10,
            size: 32,
            color: isDark ? ColorsTheme().whiteColor : ColorsTheme().blackColor,
          ),
          onPressed: onSeekBackward,
        ),
        // Play/Pause
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorsTheme().primaryColor,
            boxShadow: [
              BoxShadow(
                color: ColorsTheme().primaryColor.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: isBuffering
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed: onPlayPause,
                ),
        ),
        // Forward 15s
        IconButton(
          icon: Icon(
            isArabic ? Icons.replay_10 : Icons.forward_10,
            size: 32,
            color: isDark ? ColorsTheme().whiteColor : ColorsTheme().blackColor,
          ),
          onPressed: onSeekForward,
        ),
      ],
    );
  }
}
