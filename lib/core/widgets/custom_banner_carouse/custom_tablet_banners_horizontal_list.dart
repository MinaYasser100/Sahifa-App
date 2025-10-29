import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/banner_carousel_item.dart';

class CustomTabletBannersHorizontalList extends StatelessWidget {
  const CustomTabletBannersHorizontalList({super.key, required this.banners});

  final List<ArticleModel> banners;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: SizedBox(
        height: 270,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: banners.length,
          itemBuilder: (context, index) {
            return FadeInRight(
              delay: Duration(milliseconds: index * 100),
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () {
                    context.push(
                      Routes.detailsArticalView,
                      extra: banners[index],
                    );
                  },
                  child: SizedBox(
                    width: 360,
                    child: BannerCarouselItem(banner: banners[index]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
