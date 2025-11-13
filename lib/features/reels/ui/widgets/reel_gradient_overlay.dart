import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class ReelGradientOverlay extends StatelessWidget {
  const ReelGradientOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            ColorsTheme().blackColor.withValues(alpha: 0.8),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
