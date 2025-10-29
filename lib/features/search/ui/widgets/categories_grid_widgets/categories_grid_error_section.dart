import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_audio_magazine_section/custom_audio_magazine_section.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/search/ui/manager/search_cateories_cubit/search_categories_cubit.dart';
import 'package:sahifa/features/search/ui/widgets/categories_grid_widgets/archive_category_card.dart';

class CategoriesGridErrorSection extends StatelessWidget {
  final String errorMessage;

  const CategoriesGridErrorSection({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Al-Thawra Archive - دايماً موجودة
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: ArchiveCategoryCard(),
        ),
        const SizedBox(height: 16),
        // Audio Magazine Section
        const CustomAudioMagazineSection(notMargin: true, isDecorated: true),
        const SizedBox(height: 16),
        // Error with retry
        CustomErrorLoadingWidget(
          message: errorMessage,
          onPressed: () {
            final lang = LanguageHelper.getCurrentLanguageCode(context);
            context.read<SearchCategoriesCubit>().refreshSearchCategories(lang);
          },
        ),
      ],
    );
  }
}
