import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

import 'horizontal_articals_list_section.dart';

class ArticalsGroupSection extends StatelessWidget {
  const ArticalsGroupSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            context.push(Routes.articalsSectionView, extra: 'Local News');
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Text(
                  'Local News',
                  style: AppTextStyles.styleBold18sp(
                    context,
                  ).copyWith(color: ColorsTheme().primaryLight),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: ColorsTheme().primaryLight,
                ),
              ],
            ),
          ),
        ),
        HorizontalArticalsListSection(),
        SizedBox(height: 20),
      ],
    );
  }
}
