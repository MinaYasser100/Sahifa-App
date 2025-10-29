import 'package:flutter/material.dart';

class TabletCardGradientOverlay extends StatelessWidget {
  const TabletCardGradientOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(16),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.5),
            ],
          ),
        ),
      ),
    );
  }
}
