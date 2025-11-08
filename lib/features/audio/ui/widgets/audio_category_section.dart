import 'package:flutter/material.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_book_card_widget.dart';

class AudioCategorySection extends StatelessWidget {
  final String categoryName;
  final List<AudioItemModel> audioItems;

  const AudioCategorySection({
    super.key,
    required this.categoryName,
    required this.audioItems,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (audioItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            categoryName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? ColorsTheme().whiteColor
                  : ColorsTheme().blackColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: audioItems.length,
            itemBuilder: (context, index) {
              return AudioBookCardWidget(audioItem: audioItems[index]);
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
