import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class PdfGridItemCachedImage extends StatelessWidget {
  const PdfGridItemCachedImage({super.key, required this.thumbnailUrl});

  final String? thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: thumbnailUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: ColorsTheme().primaryColor.withValues(alpha: 0.1),
        child: Center(
          child: CircularProgressIndicator(
            color: ColorsTheme().primaryColor,
            strokeWidth: 2,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: ColorsTheme().primaryColor.withValues(alpha: 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.picture_as_pdf_rounded,
              size: 40,
              color: ColorsTheme().primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              'pdf'.tr(),
              style: TextStyle(
                color: ColorsTheme().primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
