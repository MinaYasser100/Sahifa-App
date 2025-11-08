import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/loading_helper.dart';

class CommentsLoadingState extends StatefulWidget {
  const CommentsLoadingState({super.key});

  @override
  State<CommentsLoadingState> createState() => _CommentsLoadingStateState();
}

class _CommentsLoadingStateState extends State<CommentsLoadingState> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingHelper.showWithMessage('Loading...');
    });
  }

  @override
  void dispose() {
    LoadingHelper.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
