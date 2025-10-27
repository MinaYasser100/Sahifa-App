import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/core/utils/colors.dart';
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final relatedBooks = _getRelatedBooks();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 60.0,
                  bottom: 20.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: audioItem.thumbnailUrl ?? '',
                    width: 250,
                    height: 350,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 250,
                      height: 350,
                      color: isDarkMode
                          ? ColorsTheme().cardColor
                          : ColorsTheme().grayColor,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: isDarkMode
                              ? ColorsTheme().primaryDark
                              : ColorsTheme().primaryColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 250,
                      height: 350,
                      color: isDarkMode
                          ? ColorsTheme().cardColor
                          : ColorsTheme().grayColor,
                      child: Icon(
                        Icons.error_outline,
                        size: 50,
                        color: isDarkMode
                            ? ColorsTheme().whiteColor
                            : ColorsTheme().blackColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Duration
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 20,
                    color: isDarkMode
                        ? ColorsTheme().softBlue
                        : ColorsTheme().primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${'duration'.tr()}: ${audioItem.duration ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode
                          ? ColorsTheme().softBlue
                          : ColorsTheme().primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                audioItem.title ?? '',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? ColorsTheme().whiteColor
                      : ColorsTheme().blackColor,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Author
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 20,
                    color: isDarkMode
                        ? ColorsTheme().grayColor
                        : ColorsTheme().blackColor.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${'author'.tr()}: ${audioItem.authorName ?? 'Unknown'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode
                          ? ColorsTheme().grayColor
                          : ColorsTheme().blackColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                color: isDarkMode
                    ? ColorsTheme().grayColor.withValues(alpha: 0.3)
                    : ColorsTheme().dividerColor,
                thickness: 1,
              ),
            ),

            const SizedBox(height: 16),

            // Description Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'description'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? ColorsTheme().whiteColor
                      : ColorsTheme().blackColor,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Description Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                audioItem.summary ?? 'No description available',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: isDarkMode
                      ? ColorsTheme().grayColor
                      : ColorsTheme().blackColor.withValues(alpha: 0.8),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Related Books Section
            RelatedAudioBooksSection(relatedBooks: relatedBooks),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
