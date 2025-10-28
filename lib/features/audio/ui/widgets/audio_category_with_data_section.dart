import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/audio/manager/audios_by_category_cubit/audio_by_category_cubit.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_book_card_widget.dart';

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
          return _buildSkeletonLoader(isDarkMode);
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

  Widget _buildSkeletonLoader(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category name skeleton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: 150,
            height: 24,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                  : ColorsTheme().primaryLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Horizontal audio items skeleton
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? ColorsTheme().primaryColor.withValues(alpha: 0.1)
                      : ColorsTheme().primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image skeleton
                    Container(
                      width: 160,
                      height: 220,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                            : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.headphones,
                          size: 48,
                          color: isDarkMode
                              ? ColorsTheme().primaryColor.withValues(
                                  alpha: 0.3,
                                )
                              : ColorsTheme().primaryLight.withValues(
                                  alpha: 0.3,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title skeleton
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            height: 14,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? ColorsTheme().primaryColor.withValues(
                                      alpha: 0.2,
                                    )
                                  : ColorsTheme().primaryLight.withValues(
                                      alpha: 0.2,
                                    ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 80,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? ColorsTheme().primaryColor.withValues(
                                      alpha: 0.2,
                                    )
                                  : ColorsTheme().primaryLight.withValues(
                                      alpha: 0.2,
                                    ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
