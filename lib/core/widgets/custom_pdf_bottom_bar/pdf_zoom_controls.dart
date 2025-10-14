import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:sahifa/core/utils/colors.dart';

class PdfZoomControls extends StatelessWidget {
  const PdfZoomControls({
    super.key,
    required this.controller,
    this.initialZoomLevel = 1.5,
  });

  final PdfViewerController controller;
  final double initialZoomLevel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme().whiteColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildZoomButton(
            icon: Icons.remove_circle_outline_rounded,
            onPressed: () {
              controller.zoomLevel = (controller.zoomLevel - 0.25).clamp(
                1.0,
                3.0,
              );
            },
          ),
          const SizedBox(width: 8),
          _buildZoomButton(
            icon: Icons.fit_screen_rounded,
            onPressed: () {
              controller.zoomLevel = initialZoomLevel;
            },
          ),
          const SizedBox(width: 8),
          _buildZoomButton(
            icon: Icons.add_circle_outline_rounded,
            onPressed: () {
              controller.zoomLevel = (controller.zoomLevel + 0.25).clamp(
                1.0,
                3.0,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: ColorsTheme().whiteColor, size: 24),
      ),
    );
  }
}
