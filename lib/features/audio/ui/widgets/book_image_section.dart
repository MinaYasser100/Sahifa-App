import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/core/widgets/custom_image_widget.dart';

class BookImageSection extends StatelessWidget {
  final AudioItemModel audioItem;
  final bool isDark;

  const BookImageSection({
    super.key,
    required this.audioItem,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 650),
      child: Center(
        child: CustomImageWidget(
          imageUrl: audioItem.thumbnailUrl ?? '',
          height: 290,
          width: 210,
          changeBorderRadius: false,
        ),
      ),
    );
  }
}
