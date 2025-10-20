import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class MagazinesLoadingMoreIndicator extends StatelessWidget {
  const MagazinesLoadingMoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorsTheme().primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'loading_more_magazines'.tr(),
            style: TextStyle(color: ColorsTheme().primaryColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
