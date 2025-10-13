import 'package:flutter/material.dart';
import 'package:sahifa/features/home/ui/widgets/banner_carousel_section.dart';

import 'articals_group_section.dart';

class HomeBodyView extends StatelessWidget {
  const HomeBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Banner Carousel Section
        const SliverToBoxAdapter(child: BannerCarouselSection()),

        // Local News Section Header
        SliverToBoxAdapter(child: ArticalsGroupSection()),
        SliverToBoxAdapter(child: ArticalsGroupSection()),
        SliverToBoxAdapter(child: ArticalsGroupSection()),

        SliverToBoxAdapter(child: SizedBox(height: 70)),
      ],
    );
  }
}
