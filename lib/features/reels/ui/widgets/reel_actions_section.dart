import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/reels_model/reel.dart';
import 'package:sahifa/core/utils/auth_checker.dart';
import 'package:sahifa/features/reels/data/repo/like_reel_repo.dart';
import 'package:sahifa/features/reels/manager/like_reel_cubit/like_reel_cubit.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_cubit.dart';
import 'package:sahifa/features/reels/ui/widgets/reel_comments_bottom_sheet.dart';

import 'reel_actions_column.dart';

class ReelActionsSection extends StatelessWidget {
  const ReelActionsSection({super.key, required this.reel});

  final Reel reel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LikeReelCubit(LikeReelRepoImpl()),
      child: BlocConsumer<LikeReelCubit, LikeReelState>(
        listener: (context, likeState) {
          // Handle like/unlike success
          if (likeState is LikeReelSuccess) {
            // Update the main ReelsCubit state
            if (likeState.reelId == reel.id) {
              context.read<ReelsCubit>().updateReelLikeState(
                reelId: reel.id,
                isLiked: likeState.isLiked,
              );
            }
          }

          // Handle like/unlike error
          if (likeState is LikeReelError) {
            // Revert the optimistic update in ReelsCubit
            if (likeState.reelId == reel.id) {
              context.read<ReelsCubit>().updateReelLikeState(
                reelId: reel.id,
                isLiked: likeState.wasLiked,
              );

              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(likeState.message),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }
        },
        builder: (context, likeState) {
          // Determine current like state
          bool isLiked = reel.isLikedByCurrentUser ?? false;
          int likesCount = reel.likesCount;

          // Apply optimistic update if loading
          if (likeState is LikeReelLoading && likeState.reelId == reel.id) {
            isLiked = likeState.isLiking;
            likesCount = likeState.isLiking ? likesCount + 1 : likesCount - 1;
          }

          return Positioned(
            right: 12,
            bottom: 80,
            child: ReelActionsColumn(
              isLiked: isLiked,
              likes: likesCount,
              comments: reel.commentsCount,
              shares: reel.sharesCount,
              onLikeTap: () async {
                // Check authentication before like
                if (await AuthChecker.checkAuthAndNavigate(context)) {
                  // Optimistic update in ReelsCubit first
                  context.read<ReelsCubit>().updateReelLikeState(
                    reelId: reel.id,
                    isLiked: !(reel.isLikedByCurrentUser ?? false),
                  );

                  // Then call API through LikeReelCubit
                  context.read<LikeReelCubit>().toggleLike(
                    reelId: reel.id,
                    currentlyLiked: reel.isLikedByCurrentUser ?? false,
                  );
                }
              },
              onCommentTap: () async {
                // Check authentication before comment
                if (await AuthChecker.checkAuthAndNavigate(context)) {
                  showReelCommentsBottomSheet(
                    context,
                    reelId: reel.id,
                    commentsCount: reel.commentsCount,
                  );
                }
              },
              onShareTap: () {},
              onMoreTap: () {},
            ),
          );
        },
      ),
    );
  }
}
