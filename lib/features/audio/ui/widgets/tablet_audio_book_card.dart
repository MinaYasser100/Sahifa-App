import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_image_widget.dart';

class TabletAudioBookCard extends StatelessWidget {
  final AudioItemModel audioItem;

  const TabletAudioBookCard({super.key, required this.audioItem});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.push(Routes.audioBookDetails, extra: audioItem);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomImageWidget(
              height: double.infinity,
              imageUrl: '${audioItem.thumbnailUrl}',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            audioItem.title ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? ColorsTheme().whiteColor
                  : ColorsTheme().blackColor,
            ),
          ),
        ],
      ),
    );
  }
}
