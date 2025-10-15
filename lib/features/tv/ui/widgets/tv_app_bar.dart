import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/colors.dart';

class TvAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TvAppBar({super.key, required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Icon(FontAwesomeIcons.tv),
          const SizedBox(width: 12),
          Text('Al Thawra TV'),
        ],
      ),

      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          color: isDarkMode
              ? ColorsTheme().primaryLight.withValues(alpha: 0.2)
              : ColorsTheme().dividerColor,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            context.push(Routes.profileView);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
