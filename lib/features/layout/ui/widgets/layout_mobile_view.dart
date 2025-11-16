import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/features/home/ui/home_view.dart';
import 'package:sahifa/features/pdf/ui/pdf_view.dart';
import 'package:sahifa/features/video_feed/presentation/view/video_feed_view.dart';
import 'package:sahifa/features/tv/ui/tv_view.dart';

class LayoutMobileView extends StatefulWidget {
  final PageController pageController;

  const LayoutMobileView({super.key, required this.pageController});

  @override
  State<LayoutMobileView> createState() => _LayoutMobileViewState();
}

class _LayoutMobileViewState extends State<LayoutMobileView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    final newIndex = widget.pageController.page?.round() ?? 0;
    if (newIndex != _currentIndex) {
      debugPrint('📱 PAGE CHANGED: From $_currentIndex to $newIndex');
      _currentIndex = newIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const _KeepAlivePage(child: HomeView()),
      const _KeepAlivePage(child: VideoFeedView()),
      _KeepAlivePage(child: PdfView()),
      const _KeepAlivePage(child: TvView()),
    ];

    // استخدام PageView مع AutomaticKeepAlive عشان الـ widgets تفضل alive
    return PageView(
      controller: widget.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: pages,
    );
  }
}

// Helper widget للحفاظ على حالة الصفحات
class _KeepAlivePage extends StatefulWidget {
  final Widget child;

  const _KeepAlivePage({required this.child});

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // مهم للـ AutomaticKeepAliveClientMixin
    return widget.child;
  }
}
