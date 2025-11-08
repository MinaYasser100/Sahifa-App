import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class MagazinesLoadingWidget extends StatelessWidget {
  const MagazinesLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: ColorsTheme().primaryColor),
          const SizedBox(height: 16),
          Text(
            'loading_magazines'.tr(),
            style: TextStyle(color: ColorsTheme().primaryColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
