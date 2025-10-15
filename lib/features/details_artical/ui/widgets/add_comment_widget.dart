import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';

class AddCommentWidget extends StatefulWidget {
  const AddCommentWidget({super.key});

  @override
  State<AddCommentWidget> createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsTheme().cardColor : ColorsTheme().whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDarkMode
              ? ColorsTheme().primaryLight.withValues(alpha: 0.1)
              : ColorsTheme().grayColor.withValues(alpha: 0.2)),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FontAwesomeIcons.comment,
                color: ColorsTheme().primaryColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "Add your comment",
                style: TextStyle(
                  color: isDarkMode
                      ? ColorsTheme().whiteColor
                      : ColorsTheme().blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Text Field
          CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: _commentController,
              focusNode: _focusNode,
              keyboardType: TextInputType.text,
              validator: (p0) => null,

              hintText: 'Write your comment here...',
            ),
          ),

          // Action Buttons (shown when expanded)
        ],
      ),
    );
  }
}
