class PostEntity {
  final String id;
  final String leaderId;
  final String leaderName;
  final String? leaderPhoto;
  final String postType; // 'post' or 'reel'
  final String? caption;
  final String? mediaUrl;
  final String? mediaType;
  final String? thumbnailUrl;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isSaved;
  final DateTime createdAt;

  PostEntity({
    required this.id, required this.leaderId, required this.leaderName,
    this.leaderPhoto, required this.postType, this.caption,
    this.mediaUrl, this.mediaType, this.thumbnailUrl,
    required this.likesCount, required this.commentsCount,
    required this.isLiked, required this.isSaved, required this.createdAt,
  });
}