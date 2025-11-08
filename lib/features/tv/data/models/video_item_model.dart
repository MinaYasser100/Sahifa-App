import 'package:easy_localization/easy_localization.dart';

class VideoItemModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String category;
  final DateTime date;
  final String videoUrl;
  final int viewCount;
  final String duration;

  VideoItemModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.category,
    required this.date,
    required this.videoUrl,
    required this.viewCount,
    required this.duration,
  });

  static List<VideoItemModel> getSampleVideos() {
    return [
      VideoItemModel(
        id: '1',
        title: 'video_1_title'.tr(),
        thumbnailUrl:
            'https://althawra-news.net/user_images/news/16-10-25-787182266.jpg',
        category: 'category_politics'.tr(),
        date: DateTime.now().subtract(const Duration(hours: 2)),
        videoUrl: 'https://youtu.be/IA6fQdNKPEY?si=ovqgs3j6B2F2Y5Hv',
        viewCount: 15420,
        duration: '8:45',
      ),
      VideoItemModel(
        id: '2',
        title: 'video_2_title'.tr(),
        thumbnailUrl: 'https://picsum.photos/400/225?random=2',
        category: 'category_sports'.tr(),
        date: DateTime.now().subtract(const Duration(hours: 5)),
        videoUrl: 'https://youtu.be/IA6fQdNKPEY?si=ovqgs3j6B2F2Y5Hv',
        viewCount: 28350,
        duration: '12:15',
      ),
      VideoItemModel(
        id: '3',
        title: 'video_3_title'.tr(),
        thumbnailUrl: 'https://picsum.photos/400/225?random=3',
        category: 'category_economy'.tr(),
        date: DateTime.now().subtract(const Duration(hours: 8)),
        videoUrl: 'https://youtu.be/IA6fQdNKPEY?si=ovqgs3j6B2F2Y5Hv',
        viewCount: 9870,
        duration: '5:30',
      ),
      VideoItemModel(
        id: '4',
        title: 'video_4_title'.tr(),
        thumbnailUrl:
            'https://althawra-news.net/user_images/news/16-10-25-787182266.jpg',
        category: 'category_art'.tr(),
        date: DateTime.now().subtract(const Duration(days: 1)),
        videoUrl: 'https://youtu.be/IA6fQdNKPEY?si=ovqgs3j6B2F2Y5Hv',
        viewCount: 45230,
        duration: '15:20',
      ),
      VideoItemModel(
        id: '5',
        title: 'video_5_title'.tr(),
        thumbnailUrl: 'https://picsum.photos/400/225?random=5',
        category: 'category_weather'.tr(),
        date: DateTime.now().subtract(const Duration(days: 1)),
        videoUrl: 'https://youtu.be/IA6fQdNKPEY?si=ovqgs3j6B2F2Y5Hv',
        viewCount: 12450,
        duration: '3:45',
      ),
      VideoItemModel(
        id: '6',
        title: 'video_6_title'.tr(),
        thumbnailUrl:
            'https://althawra-news.net/user_images/news/16-10-25-787182266.jpg',
        category: 'category_world'.tr(),
        date: DateTime.now().subtract(const Duration(days: 2)),
        videoUrl: 'https://youtu.be/IA6fQdNKPEY?si=ovqgs3j6B2F2Y5Hv',
        viewCount: 67890,
        duration: '10:00',
      ),
      VideoItemModel(
        id: '7',
        title: 'video_7_title'.tr(),
        thumbnailUrl: 'https://picsum.photos/400/225?random=7',
        category: 'category_health'.tr(),
        date: DateTime.now().subtract(const Duration(days: 2)),
        videoUrl: 'https://youtu.be/IA6fQdNKPEY?si=ovqgs3j6B2F2Y5Hv',
        viewCount: 34120,
        duration: '7:15',
      ),
      VideoItemModel(
        id: '8',
        title: 'video_8_title'.tr(),
        thumbnailUrl: 'https://picsum.photos/400/225?random=8',
        category: 'category_technology'.tr(),
        date: DateTime.now().subtract(const Duration(days: 3)),
        videoUrl: 'https://youtu.be/IA6fQdNKPEY?si=ovqgs3j6B2F2Y5Hv',
        viewCount: 89430,
        duration: '14:30',
      ),
    ];
  }
}
