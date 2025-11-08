import 'package:flutter/material.dart';
import 'package:sahifa/features/home/ui/home_view.dart';
import 'package:sahifa/features/pdf/ui/pdf_view.dart';
import 'package:sahifa/features/reels/ui/reels_view.dart';
import 'package:sahifa/features/tv/ui/tv_view.dart';

class LayoutMobileView extends StatelessWidget {
  final PageController pageController;

  const LayoutMobileView({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const ReelsView(),
      PdfView(),
      const TvView(),
    ];

    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(pages.length, (index) => pages[index]),
    );
  }
}
