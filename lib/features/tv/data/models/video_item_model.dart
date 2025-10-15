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
        title: 'latest news and analysis',
        thumbnailUrl: 'https://picsum.photos/400/225?random=1',
        category: 'Politics',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        videoUrl: 'https://example.com/video1.mp4',
        viewCount: 15420,
        duration: '8:45',
      ),
      VideoItemModel(
        id: '2',
        title: 'Analysis of Al Ahly vs Zamalek Match',
        thumbnailUrl: 'https://picsum.photos/400/225?random=2',
        category: 'Sports',
        date: DateTime.now().subtract(const Duration(hours: 5)),
        videoUrl: 'https://example.com/video2.mp4',
        viewCount: 28350,
        duration: '12:15',
      ),
      VideoItemModel(
        id: '3',
        title: 'Gold and Currency Prices Today',
        thumbnailUrl: 'https://picsum.photos/400/225?random=3',
        category: 'Economy',
        date: DateTime.now().subtract(const Duration(hours: 8)),
        videoUrl: 'https://example.com/video3.mp4',
        viewCount: 9870,
        duration: '5:30',
      ),
      VideoItemModel(
        id: '4',
        title: 'Behind the Scenes of the New Movie',
        thumbnailUrl: 'https://picsum.photos/400/225?random=4',
        category: 'Art',
        date: DateTime.now().subtract(const Duration(days: 1)),
        videoUrl: 'https://example.com/video4.mp4',
        viewCount: 45230,
        duration: '15:20',
      ),
      VideoItemModel(
        id: '5',
        title: 'Weather Forecast for Tomorrow',
        thumbnailUrl: 'https://picsum.photos/400/225?random=5',
        category: 'Weather',
        date: DateTime.now().subtract(const Duration(days: 1)),
        videoUrl: 'https://example.com/video5.mp4',
        viewCount: 12450,
        duration: '3:45',
      ),
      VideoItemModel(
        id: '6',
        title: 'Global News Update',
        thumbnailUrl: 'https://picsum.photos/400/225?random=6',
        category: 'World',
        date: DateTime.now().subtract(const Duration(days: 2)),
        videoUrl: 'https://example.com/video6.mp4',
        viewCount: 67890,
        duration: '10:00',
      ),
      VideoItemModel(
        id: '7',
        title: 'Health Tips to Overcome Stress',
        thumbnailUrl: 'https://picsum.photos/400/225?random=7',
        category: 'Health',
        date: DateTime.now().subtract(const Duration(days: 2)),
        videoUrl: 'https://example.com/video7.mp4',
        viewCount: 34120,
        duration: '7:15',
      ),
      VideoItemModel(
        id: '8',
        title: 'Latest Technologies in the World of Technology',
        thumbnailUrl: 'https://picsum.photos/400/225?random=8',
        category: 'Technology',
        date: DateTime.now().subtract(const Duration(days: 3)),
        videoUrl: 'https://example.com/video8.mp4',
        viewCount: 89430,
        duration: '14:30',
      ),
    ];
  }
}
