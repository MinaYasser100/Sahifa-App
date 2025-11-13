import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/reels_model/reel.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_cubit.dart';

/// أزرار الإعجاب والتعليق والمشاركة
class ReelActions extends StatelessWidget {
  final Reel reel;

  const ReelActions({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Like button
        _ActionButton(
          icon: reel.isLikedByCurrentUser == true
              ? Icons.favorite
              : Icons.favorite_border,
          label: _formatCount(reel.likesCount),
          color: reel.isLikedByCurrentUser == true ? Colors.red : Colors.white,
          onTap: () => context.read<ReelsCubit>().toggleLike(reel.id),
        ),

        const SizedBox(height: 20),

        // Comment button
        _ActionButton(
          icon: Icons.comment,
          label: _formatCount(reel.commentsCount),
          onTap: () {
            // TODO: Open comments
          },
        ),

        const SizedBox(height: 20),

        // Share button
        _ActionButton(
          icon: Icons.share,
          label: _formatCount(reel.sharesCount),
          onTap: () {
            // TODO: Share reel
          },
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
