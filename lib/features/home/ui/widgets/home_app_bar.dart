import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.person),
        onPressed: () {
          context.push(Routes.profileView);
        },
      ),
      title: const Text('Al Thawra'),
      actions: [
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
