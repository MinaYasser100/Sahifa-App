import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/audio/data/repo/audios_by_category_repo.dart';
import 'package:sahifa/features/audio/manager/audios_by_category_cubit/audio_by_category_cubit.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_book_card_widget.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_category_skeleton_loader.dart';

class RelatedAudioBooksSection extends StatelessWidget {
  final String categorySlug;
  final String language;
  final String? currentAudioId;

  const RelatedAudioBooksSection({
    super.key,
    required this.categorySlug,
    required this.language,
    this.currentAudioId,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => AudioByCategoryCubit(
        AudiosByCategoryRepoImpl(DioHelper()),
      )..fetchAudiosByCategory(categorySlug: categorySlug, language: language),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'related_audio_books'.tr(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? ColorsTheme().whiteColor
                  : ColorsTheme().primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<AudioByCategoryCubit, AudioByCategoryState>(
            builder: (context, state) {
              if (state is AudioByCategoryLoading) {
                return const AudioCategorySkeletonLoader();
              }

              if (state is AudioByCategoryError) {
                return CustomErrorLoadingWidget(
                  message: state.message,
                  onPressed: () {
                    context.read<AudioByCategoryCubit>().fetchAudiosByCategory(
                      categorySlug: categorySlug,
                      language: language,
                    );
                  },
                );
              }

              if (state is AudioByCategoryLoaded ||
                  state is AudioByCategoryLoadingMore) {
                final audios = state is AudioByCategoryLoaded
                    ? state.audios
                    : (state as AudioByCategoryLoadingMore).audios;

                // Filter out current audio if provided
                final relatedBooks = currentAudioId != null
                    ? audios
                          .where((audio) => audio.id != currentAudioId)
                          .toList()
                    : audios;

                if (relatedBooks.isEmpty) {
                  return const SizedBox.shrink();
                }

                return SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: relatedBooks.length > 10
                        ? 10
                        : relatedBooks.length, // Limit to 10 items
                    itemBuilder: (context, index) {
                      return AudioBookCardWidget(
                        audioItem: relatedBooks[index],
                      );
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
