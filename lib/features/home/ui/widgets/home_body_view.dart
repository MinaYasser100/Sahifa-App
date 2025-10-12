import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/features/home/ui/widgets/banner_carousel_section.dart';
import 'package:sahifa/features/home/ui/widgets/horizontal_news_list_section.dart';

class HomeBodyView extends StatelessWidget {
  const HomeBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Banner Carousel Section
        const SliverToBoxAdapter(child: BannerCarouselSection()),

        // Local News Section Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Text('Local News', style: AppTextStyles.styleBold18sp(context)),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              ],
            ),
          ),
        ),

        // Horizontal News List
        const SliverToBoxAdapter(child: HorizontalNewsListSection()),

        // Add more sections here as needed
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
