import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/loading_helper.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';
import 'package:sahifa/features/reels/manager/reel_commets_cubit/reel_comments_cubit.dart';

class AddCommentField extends StatefulWidget {
  final String reelId;
  final bool isDarkMode;

  const AddCommentField({
    super.key,
    required this.reelId,
    required this.isDarkMode,
  });

  @override
  State<AddCommentField> createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends State<AddCommentField> {
  final TextEditingController _commentController = TextEditingController();

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    LoadingHelper.showWithMessage('Adding comment...');

    await context.read<ReelCommentsCubit>().addComment(
      widget.reelId,
      _commentController.text,
    );

    _commentController.clear();
    LoadingHelper.dismiss();
    LoadingHelper.showSuccess('Comment added!');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          FadeInLeft(
            child: CircleAvatar(
              radius: 18,
              backgroundColor: ColorsTheme().primaryColor.withValues(
                alpha: 0.2,
              ),
              child: Icon(
                Icons.person,
                color: widget.isDarkMode
                    ? ColorsTheme().whiteColor
                    : ColorsTheme().primaryColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FadeInRight(
              child: CustomTextFormField(
                textFieldModel: TextFieldModel(
                  controller: _commentController,
                  hintText: 'Add a comment...',
                  ischangeColor: widget.isDarkMode,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  validator: (value) => null,
                  onFieldSubmitted: (value) => _addComment(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FadeInUp(
            child: IconButton(
              onPressed: _addComment,
              icon: Icon(
                Icons.send,
                color: widget.isDarkMode
                    ? ColorsTheme().whiteColor
                    : ColorsTheme().primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
