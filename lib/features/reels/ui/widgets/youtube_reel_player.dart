import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeReelPlayer extends StatefulWidget {
  final String videoId;
  final bool isCurrentPage;

  const YouTubeReelPlayer({
    super.key,
    required this.videoId,
    required this.isCurrentPage,
  });

  @override
  State<YouTubeReelPlayer> createState() => _YouTubeReelPlayerState();
}

class _YouTubeReelPlayerState extends State<YouTubeReelPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        loop: true,
        hideControls: true, // إخفاء الكونترول عشان يشبه TikTok/Reels
        disableDragSeek: false,
        enableCaption: false,
        forceHD: false, // تقليل الجودة للأداء الأسرع
        useHybridComposition: true, // تحسين الأداء على Android
      ),
    )..addListener(_playerListener);
  }

  void _playerListener() {
    if (mounted) {
      // تحديث الـ state بس لما يتغير
      if (_isPlayerReady != _controller.value.isReady) {
        setState(() {
          _isPlayerReady = _controller.value.isReady;
        });

        // Auto play when ready and is current page
        if (_isPlayerReady && widget.isCurrentPage) {
          _controller.play();
        }
      } else if (_controller.value.isReady) {
        // تحديث الـ UI لما playing state يتغير
        setState(() {});
      }
    }
  }

  @override
  void didUpdateWidget(YouTubeReelPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle page change
    if (oldWidget.isCurrentPage != widget.isCurrentPage && mounted) {
      try {
        if (widget.isCurrentPage) {
          // لما نرجع للصفحة، نشغل من آخر مكان
          if (_controller.value.isReady) {
            _controller.play();
          }
        } else {
          // لما نخرج من الصفحة، نوقف بس (مش نرجع للأول)
          _controller.pause();
        }
      } catch (e) {
        debugPrint('Error in YouTube didUpdateWidget: $e');
      }
    }
  }

  @override
  void dispose() {
    try {
      _controller.removeListener(_playerListener);
      _controller.dispose();
    } catch (e) {
      debugPrint('Error disposing YouTube controller: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _controller.value.isPlaying;

    return GestureDetector(
      onTap: () {
        // Toggle play/pause
        if (isPlaying) {
          // لما نوقف الفيديو، نعمل pause عشان يقف على آخر frame
          _controller.pause();
        } else {
          // لما نشغل الفيديو من جديد، يكمل من نفس المكان
          _controller.play();
        }
      },
      child: Container(
        color: Colors.black, // خلفية سودا بدل البيضاء
        child: Stack(
          fit: StackFit.expand,
          children: [
            // YouTube Player - بياخد كل العرض المتاح
            Center(
              child: AspectRatio(
                aspectRatio: 9 / 16, // نسبة Reels/TikTok القياسية
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: false,
                  progressIndicatorColor: ColorsTheme().primaryColor,
                  bottomActions: [], // No bottom controls
                  topActions: [], // No top controls
                  aspectRatio: 9 / 16,
                  width: double.infinity, // يأخذ كل العرض
                  onReady: () {
                    // لما الفيديو يبقى جاهز
                    setState(() {
                      _isPlayerReady = true;
                    });
                  },
                ),
              ),
            ),

            // Loading indicator
            if (!_isPlayerReady)
              Center(
                child: CircularProgressIndicator(
                  color: ColorsTheme().whiteColor,
                ),
              ),

            // Play icon overlay - بس لما الفيديو موقوف والـ player جاهز
            if (_isPlayerReady && !isPlaying)
              IgnorePointer(
                child: Container(
                  color:
                      Colors.transparent, // overlay شفاف عشان نشوف الفيديو تحت
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: ColorsTheme().whiteColor,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
