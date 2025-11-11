import 'package:flutter/material.dart';
import 'package:sahifa/core/widgets/custom_audio_magazine_section/custom_audio_magazine_section.dart';
import 'package:sahifa/core/widgets/galleries_section/galleries_section.dart';
import 'package:sahifa/features/search/ui/widgets/categories_grid_loading.dart';
import 'package:sahifa/features/search/ui/widgets/categories_grid_widgets/archive_category_card.dart';

class CategoriesGridLoadingSection extends StatelessWidget {
  const CategoriesGridLoadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Al-Thawra Archive - دايماً موجودة
          ArchiveCategoryCard(),
          const SizedBox(height: 16),
          // Audio Magazine Section
          const CustomAudioMagazineSection(notMargin: true, isDecorated: true),
          const SizedBox(height: 12),
          // Galleries Section
          const GalleriesSection(notMargin: true, isDecorated: true),
          const SizedBox(height: 16),
          // Loading skeleton
          const CategoriesGridLoading(),
        ],
      ),
    );
  }
}
