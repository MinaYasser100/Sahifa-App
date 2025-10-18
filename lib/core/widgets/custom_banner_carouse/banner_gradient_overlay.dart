import 'package:flutter/material.dart';

class BannerGradientOverlay extends StatelessWidget {
  const BannerGradientOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.black.withValues(alpha: 0.2),
            ],
          ),
        ),
      ),
    );
  }
}
