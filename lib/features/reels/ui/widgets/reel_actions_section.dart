import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/reels_model/reel.dart';
import 'package:sahifa/core/utils/auth_checker.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_cubit.dart';
import 'package:sahifa/features/reels/ui/widgets/reel_comments_bottom_sheet.dart';

import 'reel_actions_column.dart';

class ReelActionsSection extends StatelessWidget {
  const ReelActionsSection({super.key, required this.reel});

  final Reel reel;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12,
      bottom: 80,
      child: ReelActionsColumn(
        isLiked: reel.isLikedByCurrentUser ?? false,
        likes: reel.likesCount,
        comments: reel.commentsCount,
        shares: reel.sharesCount,
        onLikeTap: () async {
          // Check authentication before like
          if (await AuthChecker.checkAuthAndNavigate(context)) {
            context.read<ReelsCubit>().toggleLike(reel.id);
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
  }
}
