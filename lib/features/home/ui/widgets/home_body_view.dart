import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/custom_banner_carousel_section.dart';
import 'package:sahifa/core/widgets/custom_categories_loading_widget.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/core/widgets/custom_trending/custom_trending_articles_section.dart';
import 'package:sahifa/features/home/manger/cateogries_horizontal_bar_cubit/categories_horizontal_bar_cubit.dart';

import 'articals_group_section.dart';
import 'books_opinions_section.dart';

class HomeBodyView extends StatefulWidget {
  const HomeBodyView({super.key});

  @override
  State<HomeBodyView> createState() => _HomeBodyViewState();
}

class _HomeBodyViewState extends State<HomeBodyView> {
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
              SliverToBoxAdapter(child: CustomBannerCarouselSection()),
              SliverToBoxAdapter(child: CustomCategoriesLoadingWidget()),
            ],
          );
        } else if (state is CategoriesHorizontalBarError) {
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: CustomBannerCarouselSection()),
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
          // Use all categories (don't filter by subcategories)
          final categories = state.categories;

          return CustomScrollView(
            slivers: [
              // Banner Carousel Section
              const SliverToBoxAdapter(child: CustomBannerCarouselSection()),

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
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // index 0 is for categories[1], index 1 is for categories[2], etc.
                        final categoryIndex = index + 1;
                        return ArticalsGroupSection(
                          parentCategory: categories[categoryIndex],
                        );
                      },
                      childCount:
                          categories.length - 2, // Exclude first and last
                    ),
                  ),

                // Last category (only if more than 1 category)
                if (categories.length > 1)
                  SliverToBoxAdapter(
                    child: ArticalsGroupSection(
                      parentCategory: categories[categories.length - 1],
                    ),
                  ),

                // CustomTrendingArticlesSection after last category
                const SliverToBoxAdapter(
                  child: CustomTrendingArticlesSection(),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 70)),
              ]
              // If no categories, still show BooksOpinions and Trending
              else ...[
                const SliverToBoxAdapter(child: BooksOpinionsSection()),
                const SliverToBoxAdapter(
                  child: CustomTrendingArticlesSection(),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 70)),
              ],
            ],
          );
        }

        return const CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: CustomBannerCarouselSection()),
            SliverToBoxAdapter(child: BooksOpinionsSection()),
            SliverToBoxAdapter(child: CustomTrendingArticlesSection()),
            SliverFillRemaining(
              child: Center(child: Text('No categories found')),
            ),
          ],
        );
      },
    );
  }
}
