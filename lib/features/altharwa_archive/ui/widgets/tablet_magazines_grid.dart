import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/magazine_model/magazine_model/pdf_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/features/altharwa_archive/ui/widgets/pdf_grid_item.dart';

class TabletMagazinesGrid extends StatelessWidget {
  const TabletMagazinesGrid({
    super.key,
    required this.magazines,
    required this.scrollController,
  });

  final List<PdfModel> magazines;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        controller: scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.6,
        ),
        itemCount: magazines.length,
        itemBuilder: (context, index) {
          final pdfModel = magazines[index];
          return PdfGridItem(
            thumbnailUrl: pdfModel.thumbnailUrl,
            issueNumber: pdfModel.issueNumber,
            date: pdfModel.createdAt,
            onTap: () {
              if (pdfModel.pdfUrl != null && pdfModel.pdfUrl!.isNotEmpty) {
                context.push(Routes.archivePdfView, extra: pdfModel);
              }
            },
          );
        },
      ),
    );
  }
}
