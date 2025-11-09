import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/widgets/custom_audio_magazine_section/custom_audio_magazine_section.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/custom_tablet_banner_section.dart';
import 'package:sahifa/core/widgets/custom_categories_loading_widget.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/core/widgets/custom_trending/custom_tablet_trending_articles_grid.dart';
import 'package:sahifa/features/home/manger/cateogries_horizontal_bar_cubit/categories_horizontal_bar_cubit.dart';

import 'articals_group_section.dart';
import 'books_opinions_section.dart';

class HomeTabletBodyView extends StatefulWidget {
  const HomeTabletBodyView({super.key});

  @override
  State<HomeTabletBodyView> createState() => _HomeTabletBodyViewState();
}

class _HomeTabletBodyViewState extends State<HomeTabletBodyView> {
  bool _isFirstLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _isFirstLoad = false;
      context.read<CategoriesHorizontalBarCubit>().fetchCategoriesHorizontalBar(
        context.locale.languageCode,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      CategoriesHorizontalBarCubit,
      CategoriesHorizontalBarState
    >(
      builder: (context, state) {
        if (state is CategoriesHorizontalBarLoading) {
          return const CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: CustomTabletBannerSection()),
              SliverToBoxAdapter(child: CustomAudioMagazineSection()),
              SliverToBoxAdapter(child: CustomCategoriesLoadingWidget()),
            ],
          );
        } else if (state is CategoriesHorizontalBarError) {
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: CustomTabletBannerSection()),
              const SliverToBoxAdapter(child: CustomAudioMagazineSection()),
              SliverFillRemaining(
                child: CustomErrorLoadingWidget(
                  message: state.errorMessage,
                  onPressed: () {
                    context
                        .read<CategoriesHorizontalBarCubit>()
                        .fetchCategoriesHorizontalBar(
                          context.locale.languageCode,
                        );
                  },
                ),
              ),
            ],
          );
        } else if (state is CategoriesHorizontalBarLoaded) {
          final categories = state.categories;

          return RefreshIndicator(
            onRefresh: () async {
              await context
                  .read<CategoriesHorizontalBarCubit>()
                  .refreshCategoriesHorizontalBar(context.locale.languageCode);
            },
            child: CustomScrollView(
              slivers: [
                // Tablet Banner Section (Horizontal List)
                const SliverToBoxAdapter(child: CustomTabletBannerSection()),

                // Audio Magazine Section (always visible)
                const SliverToBoxAdapter(child: CustomAudioMagazineSection()),

                // If we have categories
                if (categories.isNotEmpty) ...[
                  // First category
                  SliverToBoxAdapter(
                    child: ArticalsGroupSection(parentCategory: categories[0]),
                  ),

                  // BooksOpinionsSection after first category
                  const SliverToBoxAdapter(child: BooksOpinionsSection()),

                  // Middle categories (from index 1 to length-2)
                  if (categories.length > 2)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final categoryIndex = index + 1;
                        return ArticalsGroupSection(
                          parentCategory: categories[categoryIndex],
                        );
                      }, childCount: categories.length - 2),
                    ),

                  // Last category (only if more than 1 category)
                  if (categories.length > 1)
                    SliverToBoxAdapter(
                      child: ArticalsGroupSection(
                        parentCategory: categories[categories.length - 1],
                      ),
                    ),

                  // Tablet Trending Articles Grid (2 columns)
                  const SliverToBoxAdapter(
                    child: CustomTabletTrendingArticlesGrid(),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 70)),
                ] else ...[
                  const SliverToBoxAdapter(child: BooksOpinionsSection()),
                  const SliverToBoxAdapter(
                    child: CustomTabletTrendingArticlesGrid(),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 70)),
                ],
              ],
            ),
          );
        }

        return const CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: CustomTabletBannerSection()),
            SliverToBoxAdapter(child: CustomAudioMagazineSection()),
            SliverToBoxAdapter(child: BooksOpinionsSection()),
            SliverToBoxAdapter(child: CustomTabletTrendingArticlesGrid()),
            SliverFillRemaining(
              child: Center(child: Text('No categories found')),
            ),
          ],
        );
      },
    );
  }
}
