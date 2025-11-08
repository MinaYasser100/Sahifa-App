class CommentModel {
  final String id;
  final String userName;
  final String userId;
  final String userAvatar;
  final String comment;
  final DateTime date;
  final bool isApproved;

  CommentModel({
    required this.id,
    required this.userName,
    required this.userId,
    required this.userAvatar,
    required this.comment,
    required this.date,
    this.isApproved = false,
  });
}
