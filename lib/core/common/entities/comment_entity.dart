class CommentEntity {
  final String id;
  final String userId;
  final String postId;
  final String userName;
  final String? userPhoto;
  final String commentText;
  final DateTime createdAt;

  CommentEntity({
    required this.id,
    required this.userId,
    required this.postId,
    required this.userName,
    this.userPhoto,
    required this.commentText,
    required this.createdAt,
  });
}