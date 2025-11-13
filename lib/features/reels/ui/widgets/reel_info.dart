import 'package:flutter/material.dart';
import 'package:sahifa/core/model/reels_model/reel.dart';

/// معلومات الريل (اليوزر والكابشن)
class ReelInfo extends StatelessWidget {
  final Reel reel;

  const ReelInfo({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // User info
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: reel.userAvatarUrl != null
                  ? NetworkImage(reel.userAvatarUrl!)
                  : null,
              child: reel.userAvatarUrl == null
                  ? const Icon(Icons.person, size: 20)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              reel.userName ?? 'Unknown',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Caption
        if (reel.caption != null && reel.caption!.isNotEmpty)
          Text(
            reel.caption!,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
