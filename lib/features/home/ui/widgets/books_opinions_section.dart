import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_horizontal_books_opinions.dart';

class BooksOpinionsSection extends StatelessWidget {
  const BooksOpinionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            context.push(
              Routes.articalsSectionView,
              extra: 'books_opinions'.tr(),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              children: [
                Text(
                  'books_opinions'.tr(),
                  style: AppTextStyles.styleBold24sp(context).copyWith(
                    color: isDarkMode
                        ? ColorsTheme().whiteColor
                        : ColorsTheme().primaryLight,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: isDarkMode
                      ? ColorsTheme().whiteColor
                      : ColorsTheme().primaryLight,
                ),
              ],
            ),
          ),
        ),
        CustomHorizontalBooksOpinions(),
      ],
    );
  }
}
