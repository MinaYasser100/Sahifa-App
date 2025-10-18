import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/banner_date_info.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/banner_share_button.dart';

class BannerInfoSection extends StatelessWidget {
  const BannerInfoSection({
    super.key,
    required this.title,
    required this.dateTime,
  });

  final String title;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // العنوان
            Text(
              title,
              maxLines: 1,

              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,

                fontWeight: FontWeight.bold,
                color: ColorsTheme().whiteColor,
              ),
            ),
            const SizedBox(height: 8),
            // التاريخ و أيقونة المشاركة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BannerDateInfo(dateTime: dateTime),
                const BannerShareButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
