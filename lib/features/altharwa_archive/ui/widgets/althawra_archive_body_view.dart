import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';

import 'arthawra_archive_bloc_builder_body.dart';

class AlthawraArchiveBodyView extends StatelessWidget {
  const AlthawraArchiveBodyView({
    super.key,
    required this.controller,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final TextEditingController controller;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: controller,
              hintText: 'search_placeholder'.tr(),
              keyboardType: TextInputType.text,
              validator: (p0) {
                return null;
              },
            ),
          ),
        ),
        Expanded(
          child: AlthawraArchiveBlocBuilderBody(
            scrollController: _scrollController,
          ),
        ),
      ],
    );
  }
}
