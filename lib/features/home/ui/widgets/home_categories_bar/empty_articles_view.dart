import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class EmptyArticlesView extends StatelessWidget {
  const EmptyArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 100,
              color: ColorsTheme().grayColor.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'no_articles_found'.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorsTheme().grayColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'no_articles_description'.tr(),
              style: TextStyle(
                fontSize: 16,
                color: ColorsTheme().grayColor.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
