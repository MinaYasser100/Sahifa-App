class ArticleItemModel {
  final String id;
  final String imageUrl;
  final String title;
  final String category;
  final String description;
  final DateTime date;
  final int viewerCount;

  ArticleItemModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.viewerCount,
  });
}
