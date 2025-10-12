import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.person),
        onPressed: () {
          // Handle user icon press
        },
      ),
      title: const Text('الثورة'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Handle search icon press
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
