import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/tv/data/models/video_item_model.dart';
import 'package:sahifa/features/tv/ui/widgets/video_item_card.dart';

import 'widgets/tv_app_bar.dart';

class TvView extends StatefulWidget {
  const TvView({super.key});

  @override
  State<TvView> createState() => _TvViewState();
}

class _TvViewState extends State<TvView> {
  late List<VideoItemModel> videos;

  @override
  void initState() {
    super.initState();
    videos = VideoItemModel.getSampleVideos();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: TvAppBar(isDarkMode: isDarkMode),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate refresh
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            videos = VideoItemModel.getSampleVideos();
          });
        },
        color: ColorsTheme().primaryColor,
        child: videos.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.videoSlash,
                      size: 80,
                      color: isDarkMode
                          ? ColorsTheme().primaryLight.withValues(alpha: 0.5)
                          : ColorsTheme().grayColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد فيديوهات متاحة',
                      style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode
                            ? ColorsTheme().whiteColor.withValues(alpha: 0.6)
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  return VideoItemCard(video: videos[index]);
                },
              ),
      ),
    );
  }
}
