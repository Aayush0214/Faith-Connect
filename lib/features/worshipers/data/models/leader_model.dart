import '../../domain/entities/leader_entity.dart';

class LeaderModel extends LeaderEntity {
  LeaderModel({
    required super.id,
    required super.name,
    super.photoUrl,
    required super.faith,
    super.bio,
    super.isFollowing,
    super.followersCount,
    super.postsCount,
  });

  factory LeaderModel.fromJson(Map<String, dynamic> json, {bool isFollowing = false}) {
    return LeaderModel(
      id: json['id']?.toString() ?? '',
      name: json['full_name'] ?? 'Unknown Leader',
      photoUrl: json['profile_photo_url'],
      faith: json['faith'] ?? 'Other',
      bio: json['bio'] ?? '',
      isFollowing: isFollowing,
      followersCount: json['followers_count'] ?? 0,
      postsCount: json['posts_count'] ?? 0,
    );
  }

  LeaderModel copyWith({
    bool? isFollowing,
    int? followersCount,
  }) {
    return LeaderModel(
      id: id,
      name: name,
      photoUrl: photoUrl,
      faith: faith,
      bio: bio,
      isFollowing: isFollowing ?? this.isFollowing,
      followersCount: followersCount ?? this.followersCount,
      postsCount: postsCount,
    );
  }
}