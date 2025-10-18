import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Al Thawra'.tr()),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            context.push(Routes.profileView);
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            context.push(Routes.searchView);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
