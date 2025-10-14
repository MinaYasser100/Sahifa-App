import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';
import 'package:sahifa/features/altharwa_archive/ui/widgets/pdf_grid_item.dart';

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

class DateRangeFilterSheet extends StatefulWidget {
  const DateRangeFilterSheet({super.key});

  @override
  State<DateRangeFilterSheet> createState() => _DateRangeFilterSheetState();
}

class _DateRangeFilterSheetState extends State<DateRangeFilterSheet> {
  late TextEditingController fromSelectedDate;
  late TextEditingController toSelectedDate;

  @override
  void initState() {
    fromSelectedDate = TextEditingController();
    toSelectedDate = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    fromSelectedDate.dispose();
    toSelectedDate.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Filter by Date',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // From Date Field
          GestureDetector(
            onTap: () => _selectDate(context, fromSelectedDate),
            child: AbsorbPointer(
              child: CustomTextFormField(
                textFieldModel: TextFieldModel(
                  controller: fromSelectedDate,
                  hintText: 'From Date',
                  icon: Icons.calendar_today_rounded,
                  keyboardType: TextInputType.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // To Date Field
          GestureDetector(
            onTap: () => _selectDate(context, toSelectedDate),
            child: AbsorbPointer(
              child: CustomTextFormField(
                textFieldModel: TextFieldModel(
                  controller: toSelectedDate,
                  hintText: 'To Date',
                  icon: Icons.calendar_today_rounded,
                  keyboardType: TextInputType.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Search Button
          SizedBox(
            child: ElevatedButton(
              onPressed: () {
                // Handle search logic here
                if (fromSelectedDate.text.isNotEmpty &&
                    toSelectedDate.text.isNotEmpty) {
                  // Perform search
                  Navigator.pop(context);
                  // Add your search logic here
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select both dates'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },

              child: Text(
                'Search',
                style: AppTextStyles.styleBold16sp(context),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
