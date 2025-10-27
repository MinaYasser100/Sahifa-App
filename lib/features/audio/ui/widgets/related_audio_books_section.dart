import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_book_card_widget.dart';

class RelatedAudioBooksSection extends StatelessWidget {
  final List<AudioItemModel> relatedBooks;

  const RelatedAudioBooksSection({super.key, required this.relatedBooks});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (relatedBooks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'related_audio_books'.tr(),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: relatedBooks.length,
            itemBuilder: (context, index) {
              return AudioBookCardWidget(audioItem: relatedBooks[index]);
            },
          ),
        ),
      ],
    );
  }
}
