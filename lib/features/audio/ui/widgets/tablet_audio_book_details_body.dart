import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/audio/ui/widgets/auido_details_info_section.dart';
import 'package:sahifa/features/audio/ui/widgets/book_image_section.dart';
import 'package:sahifa/features/audio/ui/widgets/description_section.dart';
import 'package:sahifa/features/audio/ui/widgets/related_audio_books_section.dart';

class TabletAudioBookDetailsBody extends StatelessWidget {
  final AudioItemModel audioItem;

  const TabletAudioBookDetailsBody({super.key, required this.audioItem});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLanguage = context.locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: audioItem.title != null
            ? Text(
                audioItem.title!,
                style: AppTextStyles.styleBold18sp(context),
              )
            : Text('audio_details'.tr()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Side - Image and Info
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    BookImageSection(audioItem: audioItem, isDark: isDark),
                    const SizedBox(height: 30),
                    AudioDetailsInfoSection(
                      audioItem: audioItem,
                      isDark: isDark,
                      onListenPressed: () {
                        context.push(Routes.audioPlayerView, extra: audioItem);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              // Right Side - Description and Related
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    DescriptionSection(audioItem: audioItem, isDark: isDark),
                    const SizedBox(height: 20),
                    Divider(
                        color: isDark ? ColorsTheme().grayColor : Colors.black12),
                    const SizedBox(height: 20),
                    // Related Audio Books Section
                    if (audioItem.categorySlug != null &&
                        audioItem.categorySlug!.isNotEmpty)
                      FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        child: RelatedAudioBooksSection(
                          categorySlug: audioItem.categorySlug!,
                          language: currentLanguage,
                          currentAudioId: audioItem.id,
                        ),
                      ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
