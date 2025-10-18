import 'package:flutter/material.dart';
import 'package:sahifa/core/widgets/custom_trending/custom_trending_articles_section.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/custom_banner_carousel_section.dart';

import 'articals_group_section.dart';
import 'books_opinions_section.dart';

class HomeBodyView extends StatelessWidget {
  const HomeBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Banner Carousel Section
        const SliverToBoxAdapter(child: CustomBannerCarouselSection()),

        // Local News Section Header
        SliverToBoxAdapter(child: ArticalsGroupSection()),
        SliverToBoxAdapter(child: BooksOpinionsSection()),
        SliverToBoxAdapter(child: ArticalsGroupSection()),
        SliverToBoxAdapter(child: ArticalsGroupSection()),
        SliverToBoxAdapter(child: CustomTrendingArticlesSection()),
        SliverToBoxAdapter(child: SizedBox(height: 70)),
      ],
    );
  }
}
