import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/reel_model/reel_model.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_cubit.dart';
import 'package:sahifa/features/reels/ui/widgets/reel_comments_bottom_sheet.dart';

import 'reel_actions_column.dart';

class ReelActionsSection extends StatelessWidget {
  const ReelActionsSection({super.key, required this.reel});

  final ReelModel reel;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12,
      bottom: 80,
      child: ReelActionsColumn(
        isLiked: reel.isLiked,
        likes: reel.likes,
        comments: reel.comments,
        shares: reel.shares,
        onLikeTap: () {
          context.read<ReelsCubit>().toggleLike(reel.id);
        },
        onCommentTap: () {
          showReelCommentsBottomSheet(
            context,
            reelId: reel.id,
            commentsCount: reel.comments,
          );
        },
        onShareTap: () {},
        onMoreTap: () {},
      ),
    );
  }
}
