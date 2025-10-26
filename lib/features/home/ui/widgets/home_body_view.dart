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
                // Dynamic Parent Categories with BooksOpinions and Trending
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    // First category
                    if (index == 0) {
                      return Column(
                        children: [
                          ArticalsGroupSection(
                            parentCategory: categories[index],
                          ),
                          const BooksOpinionsSection(),
                        ],
                      );
                    }
                    // Last category
                    else if (index == categories.length - 1) {
                      return Column(
                        children: [
                          ArticalsGroupSection(
                            parentCategory: categories[index],
                          ),
                          const CustomTrendingArticlesSection(),
                          const SizedBox(height: 70),
                        ],
                      );
                    }
                    // Middle categories
                    else {
                      return ArticalsGroupSection(
                        parentCategory: categories[index],
                      );
                    }
                  }, childCount: categories.length),
                ),
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
