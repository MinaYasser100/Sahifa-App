import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/features/altharwa_archive/ui/widgets/archive_pdf_widget.dart';

class ArticlePdfPathEmptyWidget extends StatelessWidget {
  const ArticlePdfPathEmptyWidget({super.key, required this.widget});

  final ArchivePDFWidget widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pdfModel.createdAt ?? "No Date".tr()),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'no_pdf_found'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
