class VideoItemModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String category;
  final DateTime date;
  final String videoUrl;
  final int viewCount;
  final String duration; // مثال: "5:30"

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

  // Sample data for testing
  static List<VideoItemModel> getSampleVideos() {
    return [
      VideoItemModel(
        id: '1',
        title: 'آخر أخبار السياسة المصرية اليوم',
        thumbnailUrl: 'https://picsum.photos/400/225?random=1',
        category: 'سياسة',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        videoUrl: 'https://example.com/video1.mp4',
        viewCount: 15420,
        duration: '8:45',
      ),
      VideoItemModel(
        id: '2',
        title: 'تحليل مباراة الأهلي والزمالك',
        thumbnailUrl: 'https://picsum.photos/400/225?random=2',
        category: 'رياضة',
        date: DateTime.now().subtract(const Duration(hours: 5)),
        videoUrl: 'https://example.com/video2.mp4',
        viewCount: 28350,
        duration: '12:15',
      ),
      VideoItemModel(
        id: '3',
        title: 'أسعار الذهب والعملات اليوم',
        thumbnailUrl: 'https://picsum.photos/400/225?random=3',
        category: 'اقتصاد',
        date: DateTime.now().subtract(const Duration(hours: 8)),
        videoUrl: 'https://example.com/video3.mp4',
        viewCount: 9870,
        duration: '5:30',
      ),
      VideoItemModel(
        id: '4',
        title: 'كواليس تصوير الفيلم الجديد',
        thumbnailUrl: 'https://picsum.photos/400/225?random=4',
        category: 'فن',
        date: DateTime.now().subtract(const Duration(days: 1)),
        videoUrl: 'https://example.com/video4.mp4',
        viewCount: 45230,
        duration: '15:20',
      ),
      VideoItemModel(
        id: '5',
        title: 'توقعات حالة الطقس لهذا الأسبوع',
        thumbnailUrl: 'https://picsum.photos/400/225?random=5',
        category: 'طقس',
        date: DateTime.now().subtract(const Duration(days: 1)),
        videoUrl: 'https://example.com/video5.mp4',
        viewCount: 12450,
        duration: '3:45',
      ),
      VideoItemModel(
        id: '6',
        title: 'أهم الأحداث العالمية اليوم',
        thumbnailUrl: 'https://picsum.photos/400/225?random=6',
        category: 'عالم',
        date: DateTime.now().subtract(const Duration(days: 2)),
        videoUrl: 'https://example.com/video6.mp4',
        viewCount: 67890,
        duration: '10:00',
      ),
      VideoItemModel(
        id: '7',
        title: 'نصائح صحية للتغلب على الإجهاد',
        thumbnailUrl: 'https://picsum.photos/400/225?random=7',
        category: 'صحة',
        date: DateTime.now().subtract(const Duration(days: 2)),
        videoUrl: 'https://example.com/video7.mp4',
        viewCount: 34120,
        duration: '7:15',
      ),
      VideoItemModel(
        id: '8',
        title: 'أحدث التقنيات في عالم التكنولوجيا',
        thumbnailUrl: 'https://picsum.photos/400/225?random=8',
        category: 'تقنية',
        date: DateTime.now().subtract(const Duration(days: 3)),
        videoUrl: 'https://example.com/video8.mp4',
        viewCount: 89430,
        duration: '14:30',
      ),
    ];
  }
}
