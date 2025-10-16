import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class CommentsBottomSheetHandle extends StatelessWidget {
  const CommentsBottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: ColorsTheme().grayColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
