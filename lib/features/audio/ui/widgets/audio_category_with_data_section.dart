import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/audio/manager/audios_by_category_cubit/audio_by_category_cubit.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_book_card_widget.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_category_skeleton_loader.dart';

class AudioCategoryWithDataSection extends StatelessWidget {
  final ParentCategory category;
  final String language;

  const AudioCategoryWithDataSection({
    super.key,
    required this.category,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AudioByCategoryCubit, AudioByCategoryState>(
      builder: (context, state) {
        if (state is AudioByCategoryLoading) {
          return const AudioCategorySkeletonLoader();
        }

        if (state is AudioByCategoryError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CustomErrorLoadingWidget(
              message: state.message,
              onPressed: () {
                context.read<AudioByCategoryCubit>().fetchAudiosByCategory(
                  categorySlug: category.slug ?? '',
                  language: language,
                );
              },
            ),
          );
        }

        if (state is AudioByCategoryLoaded ||
            state is AudioByCategoryLoadingMore) {
          final audios = state is AudioByCategoryLoaded
              ? state.audios
              : (state as AudioByCategoryLoadingMore).audios;

          if (audios.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  category.name ?? '',
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
                  itemCount: audios.length,
                  itemBuilder: (context, index) {
                    return AudioBookCardWidget(audioItem: audios[index]);
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
