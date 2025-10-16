import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/reel_model/reel_model.dart';
import 'package:sahifa/core/utils/show_top_toast.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_cubit.dart';

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
          showSuccessToast(context, 'Comment', 'Soon will be available');
        },
        onShareTap: () {},
        onMoreTap: () {},
      ),
    );
  }
}
