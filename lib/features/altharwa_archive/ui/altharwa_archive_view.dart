import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';
import 'package:sahifa/features/altharwa_archive/ui/widgets/pdf_grid_item.dart';

import 'widgets/date_range_filter_sheet.dart';

class AltharwaArchiveView extends StatefulWidget {
  const AltharwaArchiveView({super.key});

  @override
  State<AltharwaArchiveView> createState() => _AltharwaArchiveViewState();
}

class _AltharwaArchiveViewState extends State<AltharwaArchiveView> {
  late TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const String pdfPath = 'assets/pdf/World_Events_Chronicle_2025.pdf';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Altharwa Archive'),
        elevation: 10,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return DateRangeFilterSheet();
                },
              );
            },
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: CustomTextFormField(
              textFieldModel: TextFieldModel(
                controller: controller,
                hintText: 'Search...',
                icon: Icons.search,
                keyboardType: TextInputType.text,
                validator: (p0) {
                  return null;
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
          ),
        ],
      ),
    );
  }
}
