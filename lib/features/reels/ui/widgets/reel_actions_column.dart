import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';

class ReelActionsColumn extends StatelessWidget {
  final bool isLiked;
  final int likes;
  final int comments;
  final int shares;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final VoidCallback onMoreTap;

  const ReelActionsColumn({
    super.key,
    required this.isLiked,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onShareTap,
    required this.onMoreTap,
  });

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Like
        _buildActionButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          label: _formatCount(likes),
          onTap: onLikeTap,
          color: isLiked ? ColorsTheme().errorColor : ColorsTheme().whiteColor,
        ),
        const SizedBox(height: 24),
        // Comment
        _buildActionButton(
          icon: Icons.comment,
          label: _formatCount(comments),
          onTap: onCommentTap,
        ),
        const SizedBox(height: 24),
        // Share
        _buildActionButton(
          icon: FontAwesomeIcons.share,
          label: _formatCount(shares),
          onTap: onShareTap,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: ColorsTheme().whiteColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
