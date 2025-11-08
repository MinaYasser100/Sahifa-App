import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MagazinesEmptyWidget extends StatelessWidget {
  const MagazinesEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'no_magazines_found'.tr(),
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
