class NewsItemModel {
  final String imageUrl;
  final String title;
  final String description;
  final DateTime date;
  final int viewerCount;

  NewsItemModel({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.date,
    required this.viewerCount,
  });
}
