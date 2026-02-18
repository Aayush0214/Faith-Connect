import '../entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.id,
    required super.userId,
    required super.postId,
    required super.userName,
    super.userPhoto,
    required super.commentText,
    required super.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      postId: json['post_id']?.toString() ?? '',
      userName: json['users']['full_name'] ?? 'Unknown User',
      userPhoto: json['users']['profile_photo_url'],
      commentText: json['comment_text'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at']).toLocal()
          : DateTime.now(),
    );
  }
}