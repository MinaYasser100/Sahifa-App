class GalleryModel {
  String? id;
  String? title;
  String? imageUrl;
  String? imageDescription;
  String? content;
  String? postId;
  DateTime? createdAt;
  DateTime? updatedAt;

  GalleryModel({
    this.id,
    this.title,
    this.imageUrl,
    this.imageDescription,
    this.content,
    this.postId,
    this.createdAt,
    this.updatedAt,
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) => GalleryModel(
    id: json['id'] as String?,
    title: json['title'] as String?,
    imageUrl: json['imageUrl'] as String?,
    imageDescription: json['imageDescription'] as String?,
    content: json['content'] as String?,
    postId: json['postId'] as String?,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imageUrl': imageUrl,
    'imageDescription': imageDescription,
    'content': content,
    'postId': postId,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
