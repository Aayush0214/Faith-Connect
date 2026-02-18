import '../entities/post_entity.dart';

class PostModel extends PostEntity {
  PostModel({
    required super.id,
    required super.leaderId,
    required super.leaderName,
    super.leaderPhoto,
    required super.postType,
    super.caption,
    super.mediaUrl,
    super.mediaType,
    super.thumbnailUrl,
    required super.likesCount,
    required super.commentsCount,
    required super.isLiked,
    required super.isSaved,
    required super.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    bool checkPresence(dynamic data) {
      if (data == null) return false;
      if (data is List) return data.isNotEmpty;
      if (data is bool) return data;
      return false;
    }

    // Check karo ki leader data nested h ya flat
    // Case 1: Direct Query (Nested) -> json['leader']['full_name']
    // Case 2: RPC (Flat) -> json['leader_name']
    final leaderObj = json['leader'];

    String name = 'Unknown';
    String? photo;

    if (leaderObj != null && leaderObj is Map) {
      name = leaderObj['full_name'] ?? 'Unknown';
      photo = leaderObj['profile_photo_url'] ?? '';
    } else {
      // Worshipper side (Flat) logic
      name = json['leader_name'] ?? 'Unknown';
      photo = json['leader_photo'] ?? '';
    }

    return PostModel(
      id: json['id']?.toString() ?? '',
      leaderId: json['leader_id']?.toString() ?? '',
      leaderName: name,
      leaderPhoto: photo,
      postType: json['post_type'] ?? 'post',
      caption: json['caption'] ?? '',
      mediaUrl: json['media_url'],
      mediaType: json['media_type'] ?? 'none',
      thumbnailUrl: json['thumbnail_url'],
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0, // ensure naming consistency
      isLiked: checkPresence(json['is_liked']),
      isSaved: checkPresence(json['is_saved']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  PostModel copyWith({
    bool? isLiked,
    int? likesCount,
    bool? isSaved,
    int? commentsCount,
  }) {
    return PostModel(
      id: id,
      leaderId: leaderId,
      leaderName: leaderName,
      leaderPhoto: leaderPhoto,
      postType: postType,
      caption: caption,
      mediaUrl: mediaUrl,
      mediaType: mediaType,
      thumbnailUrl: thumbnailUrl,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
