import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class AudioSpeedControl extends StatelessWidget {
  final double currentSpeed;
  final ValueChanged<double> onSpeedChanged;

  const AudioSpeedControl({
    super.key,
    required this.currentSpeed,
    required this.onSpeedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.speed,
          size: 20,
          color: isDark
              ? ColorsTheme().grayColor
              : ColorsTheme().blackColor.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 8),
        _SpeedButton(
          speed: 0.75,
          currentSpeed: currentSpeed,
          onTap: () => onSpeedChanged(0.75),
          isDark: isDark,
        ),
        const SizedBox(width: 8),
        _SpeedButton(
          speed: 1.0,
          currentSpeed: currentSpeed,
          onTap: () => onSpeedChanged(1.0),
          isDark: isDark,
        ),
        const SizedBox(width: 8),
        _SpeedButton(
          speed: 1.25,
          currentSpeed: currentSpeed,
          onTap: () => onSpeedChanged(1.25),
          isDark: isDark,
        ),
        const SizedBox(width: 8),
        _SpeedButton(
          speed: 1.5,
          currentSpeed: currentSpeed,
          onTap: () => onSpeedChanged(1.5),
          isDark: isDark,
        ),
      ],
    );
  }
}

class _SpeedButton extends StatelessWidget {
  final double speed;
  final double currentSpeed;
  final VoidCallback onTap;
  final bool isDark;

  const _SpeedButton({
    required this.speed,
    required this.currentSpeed,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = speed == currentSpeed;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorsTheme().primaryColor
              : (isDark
                    ? ColorsTheme().cardColor
                    : ColorsTheme().grayColor.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? ColorsTheme().primaryColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          '${speed}x',
          style: AppTextStyles.styleMedium14sp(context).copyWith(
            color: isSelected
                ? Colors.white
                : (isDark
                      ? ColorsTheme().whiteColor
                      : ColorsTheme().blackColor),
          ),
        ),
      ),
    );
  }
}
