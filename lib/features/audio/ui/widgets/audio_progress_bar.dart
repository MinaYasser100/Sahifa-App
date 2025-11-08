import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class AudioProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;
  final String Function(Duration) formatDuration;

  const AudioProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Progress Bar
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor: ColorsTheme().primaryColor,
            inactiveTrackColor: isDark ? Colors.white24 : Colors.black12,
            thumbColor: ColorsTheme().primaryColor,
            overlayColor: ColorsTheme().primaryColor.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: duration.inMilliseconds > 0
                ? position.inMilliseconds.toDouble()
                : 0.0,
            max: duration.inMilliseconds.toDouble(),
            onChanged: (value) {
              onSeek(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        // Time Labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDuration(position),
                style: AppTextStyles.styleMedium14sp(context).copyWith(
                  color: isDark
                      ? ColorsTheme().grayColor
                      : ColorsTheme().blackColor.withValues(alpha: 0.6),
                ),
              ),
              Text(
                formatDuration(duration),
                style: AppTextStyles.styleMedium14sp(context).copyWith(
                  color: isDark
                      ? ColorsTheme().grayColor
                      : ColorsTheme().blackColor.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
