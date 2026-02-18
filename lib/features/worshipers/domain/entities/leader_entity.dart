// lib/features/worshiper/domain/entities/leader_entity.dart
class LeaderEntity {
  final String id;
  final String name;
  final String? bio;
  final String faith;
  final int postsCount;
  final String? photoUrl;
  final bool isFollowing;
  final int followersCount;

  LeaderEntity({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.faith,
    this.bio,
    this.isFollowing = false,
    this.followersCount = 0,
    this.postsCount = 0,
  });
}