class CommentModel {
  final String id;
  final String userName;
  final String userAvatar;
  final String comment;
  final DateTime date;
  final int likes;

  CommentModel({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.comment,
    required this.date,
    this.likes = 0,
  });
}
