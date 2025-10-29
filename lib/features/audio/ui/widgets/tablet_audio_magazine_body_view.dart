import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/audio/data/repo/audios_by_category_repo.dart';
import 'package:sahifa/features/audio/manager/audio_categories_cubit/audio_categories_cubit.dart';
import 'package:sahifa/features/audio/manager/audios_by_category_cubit/audio_by_category_cubit.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_category_skeleton.dart';
import 'package:sahifa/features/audio/ui/widgets/tablet_audio_category_grid_section.dart';

class TabletAudioMagazineBodyView extends StatefulWidget {
  const TabletAudioMagazineBodyView({super.key});

  @override
  State<TabletAudioMagazineBodyView> createState() =>
      _TabletAudioMagazineBodyViewState();
}

class _TabletAudioMagazineBodyViewState
    extends State<TabletAudioMagazineBodyView> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final language = context.locale.languageCode;
      context.read<AudioCategoriesCubit>().fetchAudioCategories(
            language: language,
          );
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = context.locale.languageCode;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocBuilder<AudioCategoriesCubit, AudioCategoriesState>(
        builder: (context, state) {
          if (state is AudioCategoriesLoading) {
            return SingleChildScrollView(
              child: Column(
                children: List.generate(
                  3,
                  (index) => const AudioCategorySkeleton(),
                ),
              ),
            );
          }

          if (state is AudioCategoriesError) {
            return Center(
              child: CustomErrorLoadingWidget(
                message: state.message,
                onPressed: () {
                  context.read<AudioCategoriesCubit>().fetchAudioCategories(
                        language: language,
                      );
                },
              ),
            );
          }

          if (state is AudioCategoriesLoaded) {
            final categories = state.categories;

            if (categories.isEmpty) {
              return Center(
                child: Text(
                  "no_categories_available".tr(),
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AudioCategoriesCubit>().fetchAudioCategories(
                      language: language,
                    );
              },
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return BlocProvider(
                    create: (context) => AudioByCategoryCubit(
                      AudiosByCategoryRepoImpl(DioHelper()),
                    )..fetchAudiosByCategory(
                        categorySlug: category.slug ?? '',
                        language: language,
                      ),
                    child: TabletAudioCategoryGridSection(
                      category: category,
                      language: language,
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
