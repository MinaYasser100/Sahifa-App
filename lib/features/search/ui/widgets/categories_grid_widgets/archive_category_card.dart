import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/features/search/ui/widgets/category_card.dart';

class ArchiveCategoryCard extends StatelessWidget {
  const ArchiveCategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: CategoryCard(
        categoryName: 'altharwa_archive'.tr(),
        isLarge: true,
        onTap: () {
          context.push(Routes.alThawraArchiveView);
        },
      ),
    );
  }
}
