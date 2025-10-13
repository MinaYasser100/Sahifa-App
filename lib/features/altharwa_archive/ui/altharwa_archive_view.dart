import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/features/altharwa_archive/ui/widgets/pdf_grid_item.dart';

class AltharwaArchiveView extends StatelessWidget {
  const AltharwaArchiveView({super.key});

  @override
  Widget build(BuildContext context) {
    const String pdfPath = 'assets/pdf/World_Events_Chronicle_2025.pdf';

    return Scaffold(
      appBar: AppBar(title: const Text('Altharwa Archive'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return PdfGridItem(
              pdfTitle: 'World Events Chronicle',
              pdfNumber: index + 1,
              onTap: () {
                context.push(Routes.searchPdfView, extra: pdfPath);
              },
            );
          },
        ),
      ),
    );
  }
}
