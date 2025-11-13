import 'package:flutter/material.dart';
import 'package:sahifa/core/model/reels_model/reel.dart';
import 'package:sahifa/features/reels/ui/widgets/reel_video_player.dart';
import 'package:sahifa/features/reels/ui/widgets/reel_actions_section.dart';
import 'package:sahifa/features/reels/ui/widgets/reel_caption_section.dart';
import 'package:sahifa/features/reels/ui/widgets/reel_gradient_overlay.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// ReelItem بسيط زي Instagram
class ReelItem extends StatefulWidget {
  final Reel reel;
  final bool isCurrentPage;

  const ReelItem({super.key, required this.reel, required this.isCurrentPage});

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  VoidCallback? _toggleCallback;

  void _onToggleReady(VoidCallback toggle) {
    setState(() {
      _toggleCallback = toggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: VisibilityDetector(
        key: Key('reel_${widget.reel.id}'),
        onVisibilityChanged: (info) {
          // الـ visibility detector بس للمراقبة
          // الـ pause/play بيتعامل معاه الـ shouldPlay prop
        },
        child: GestureDetector(
          onTap: () => _toggleCallback?.call(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // الفيديو
              ReelVideoPlayer(
                reel: widget.reel,
                shouldPlay: widget.isCurrentPage,
                onToggleReady: _onToggleReady,
              ),

              // Gradient overlay - يخليه pointer transparent
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(child: ReelGradientOverlay()),
              ),

              // User info and caption - clickable
              ReelCaptionSection(reel: widget.reel),

              // Action buttons (right side) - clickable
              ReelActionsSection(reel: widget.reel),
            ],
          ),
        ),
      ),
    );
  }
}
