import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/reels/manager/reel_commets_cubit/reel_comments_cubit.dart';
import 'package:sahifa/features/reels/ui/widgets/comments_bottom_sheet_widgets/add_comment_field.dart';
import 'package:sahifa/features/reels/ui/widgets/comments_bottom_sheet_widgets/comments_bottom_sheet_header.dart';
import 'package:sahifa/features/reels/ui/widgets/comments_bottom_sheet_widgets/comments_empty_state.dart';
import 'package:sahifa/features/reels/ui/widgets/comments_bottom_sheet_widgets/comments_error_state.dart';
import 'package:sahifa/features/reels/ui/widgets/comments_bottom_sheet_widgets/comments_list.dart';
import 'package:sahifa/features/reels/ui/widgets/comments_bottom_sheet_widgets/comments_loading_state.dart';

class ReelCommentsBottomSheet extends StatelessWidget {
  final String reelId;
  final int commentsCount;

  const ReelCommentsBottomSheet({
    super.key,
    required this.reelId,
    required this.commentsCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => ReelCommentsCubit()..loadComments(reelId),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: isDarkMode
              ? ColorsTheme().blackColor
              : ColorsTheme().whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            BlocBuilder<ReelCommentsCubit, ReelCommentsState>(
              builder: (context, state) {
                int displayCount = commentsCount;
                if (state is ReelCommentsLoaded) {
                  displayCount = state.comments.length;
                }

                return CommentsBottomSheetHeader(
                  commentsCount: displayCount,
                  isDarkMode: isDarkMode,
                );
              },
            ),
            const Divider(height: 1),
            AddCommentField(reelId: reelId, isDarkMode: isDarkMode),
            const Divider(height: 1),
            Expanded(
              child: BlocBuilder<ReelCommentsCubit, ReelCommentsState>(
                builder: (context, state) {
                  if (state is ReelCommentsLoading) {
                    return const CommentsLoadingState();
                  }

                  if (state is ReelCommentsError) {
                    return CommentsErrorState(
                      message: state.message,
                      onRetry: () {
                        context.read<ReelCommentsCubit>().loadComments(reelId);
                      },
                    );
                  }

                  if (state is ReelCommentsLoaded) {
                    if (state.comments.isEmpty) {
                      return const CommentsEmptyState();
                    }
                    return ReelCommentsList(
                      comments: state.comments,
                      currentUserId:
                          'current_user', // TODO: Get from auth/user service
                    );
                  }

                  return const CommentsEmptyState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to show the bottom sheet
void showReelCommentsBottomSheet(
  BuildContext context, {
  required String reelId,
  required int commentsCount,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        ReelCommentsBottomSheet(reelId: reelId, commentsCount: commentsCount),
  );
}
