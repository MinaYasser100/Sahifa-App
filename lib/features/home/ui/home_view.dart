import 'package:flutter/material.dart';
import 'package:sahifa/features/home/ui/widgets/banner_carousel_section.dart';
import 'package:sahifa/features/home/ui/widgets/home_app_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: CustomScrollView(
        slivers: [
          // Banner Carousel Section
          SliverToBoxAdapter(child: BannerCarouselSection()),

          // Add more slivers here as needed
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'المحتوى الآخر',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
