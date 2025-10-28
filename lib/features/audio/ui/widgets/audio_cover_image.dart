import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/widgets/custom_image_widget.dart';

class AudioCoverImage extends StatelessWidget {
  final String? imageUrl;
  final String audioId;

  const AudioCoverImage({
    super.key,
    required this.imageUrl,
    required this.audioId,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Center(
        child: Hero(
          tag: 'audio_$audioId',
          child: CustomImageWidget(
            imageUrl: imageUrl ?? '',
            height: 290,
            width: 210,
            changeBorderRadius: false,
          ),
        ),
      ),
    );
  }
}
