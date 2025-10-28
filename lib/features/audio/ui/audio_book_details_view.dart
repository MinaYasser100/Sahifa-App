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

class AudioBookDetailsView extends StatelessWidget {
  final AudioItemModel audioItem;
  const AudioBookDetailsView({super.key, required this.audioItem});

  List<AudioItemModel> _getRelatedBooks() {
    return [
      AudioItemModel(
        id: '10',
        title: 'كتاب صوتي مشابه 1',
        thumbnailUrl: 'https://via.placeholder.com/160x220',
        duration: '40:20',
        authorName: 'كاتب آخر',
        summary: 'وصف الكتاب المشابه',
        categoryName: audioItem.categoryName,
      ),
      AudioItemModel(
        id: '11',
        title: 'كتاب صوتي مشابه 2',
        thumbnailUrl: 'https://via.placeholder.com/160x220',
        duration: '35:45',
        authorName: 'كاتب ثالث',
        summary: 'وصف كتاب آخر مشابه',
        categoryName: audioItem.categoryName,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final relatedBooks = _getRelatedBooks();

    return Scaffold(
      appBar: AppBar(
        title: audioItem.title != null
            ? Text(
                audioItem.title!,
                style: AppTextStyles.styleBold18sp(context),
              )
            : Text('audio_details'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              BookImageSection(audioItem: audioItem, isDark: isDark),
              const SizedBox(height: 28),
              AudioDetailsInfoSection(
                audioItem: audioItem,
                isDark: isDark,
                onListenPressed: () {
                  context.push(Routes.audioPlayerView, extra: audioItem);
                },
              ),
              const SizedBox(height: 10),
              Divider(color: isDark ? ColorsTheme().grayColor : Colors.black12),
              const SizedBox(height: 8),
              DescriptionSection(audioItem: audioItem, isDark: isDark),
              const SizedBox(height: 10),
              Divider(color: isDark ? ColorsTheme().grayColor : Colors.black12),
              const SizedBox(height: 14),
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                child: RelatedAudioBooksSection(relatedBooks: relatedBooks),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
