import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/magazine_model/magazine_model/pdf_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/features/altharwa_archive/ui/widgets/pdf_grid_item.dart';

class MagazinesGridView extends StatelessWidget {
  const MagazinesGridView({
    super.key,
    required this.magazines,
    required this.scrollController,
  });

  final List<PdfModel> magazines;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        controller: scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.6,
        ),
        itemCount: magazines.length,
        itemBuilder: (context, index) {
          final magazine = magazines[index];
          return PdfGridItem(
            thumbnailUrl: magazine.thumbnailUrl,
            issueNumber: magazine.issueNumber,
            date: magazine.createdAt,
            onTap: () {
              if (magazine.pdfUrl != null && magazine.pdfUrl!.isNotEmpty) {
                context.push(Routes.searchPdfView, extra: magazine.pdfUrl);
              }
            },
          );
        },
      ),
    );
  }
}
