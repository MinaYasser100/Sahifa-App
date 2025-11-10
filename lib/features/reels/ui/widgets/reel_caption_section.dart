import 'package:flutter/material.dart';
import 'package:sahifa/core/model/reels_model/reel.dart';
import 'package:sahifa/core/utils/colors.dart';

class ReelCaptionSection extends StatelessWidget {
  const ReelCaptionSection({super.key, required this.reel});

  final Reel reel;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80,
      left: 16,
      right: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Caption
          if (reel.caption != null && reel.caption!.isNotEmpty)
            Text(
              reel.caption!,
              style: TextStyle(color: ColorsTheme().whiteColor, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
