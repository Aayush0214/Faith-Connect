part of 'leader_dashboard_bloc.dart';

enum LeaderDashboardStatus{
  initial,
  loading,
  loaded,
  failure,
  leaderActionSuccess,
}

class LeaderDashboardState extends Equatable {
  final LeaderEntity? leader;
  final List<PostEntity> posts;
  final List<PostEntity> reels;
  final List<UserEntity> leaderFollowers;
  final bool isFollowersLoading;
  final LeaderDashboardStatus status;
  final bool isFetchingMore;
  final bool hasMorePosts;
  final bool hasMoreReels;
  final String errorMessage;
  final String successActionMessage;
  final int errorTimeStamp;
  final int successTimeStamp;

  const LeaderDashboardState({
    this.leader,
    this.posts = const [],
    this.reels = const [],
    this.leaderFollowers = const[],
    this.isFollowersLoading = false,
    this.status = LeaderDashboardStatus.initial,
    this.isFetchingMore = false,
    this.hasMorePosts = true,
    this.hasMoreReels = true,
    this.errorMessage = '',
    this.successActionMessage = '',
    this.errorTimeStamp = 0,
    this.successTimeStamp = 0,
  });

  LeaderDashboardState copyWith({
    LeaderEntity? leader,
    List<PostEntity>? posts,
    List<PostEntity>? reels,
    List<UserEntity>? leaderFollowers,
    LeaderDashboardStatus? status,
    bool? isFollowersLoading,
    bool? isFetchingMore,
    bool? hasMorePosts,
    bool? hasMoreReels,
    String? errorMessage,
    String? successActionMessage,
    int? errorTimeStamp,
    int? successTimeStamp,
  }) {
    return LeaderDashboardState(
      leader: leader ?? this.leader,
      posts: posts ?? this.posts,
      reels: reels ?? this.reels,
      status: status ?? this.status,
      leaderFollowers: leaderFollowers ?? this.leaderFollowers,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasMorePosts: hasMorePosts ?? this.hasMorePosts,
      hasMoreReels: hasMoreReels ?? this.hasMoreReels,
      errorMessage: errorMessage ?? this.errorMessage,
      isFollowersLoading: isFollowersLoading ?? this.isFollowersLoading,
      successActionMessage: successActionMessage ?? this.successActionMessage,
      errorTimeStamp: errorTimeStamp ?? this.errorTimeStamp,
      successTimeStamp: successTimeStamp ?? this.successTimeStamp,
    );
  }
  @override
  List<Object?> get props =>
      [
        leader,
        posts,
        reels,
        status,
        leaderFollowers,
        isFollowersLoading,
        isFetchingMore,
        hasMorePosts,
        hasMoreReels,
        errorMessage,
        errorTimeStamp,
        successActionMessage,
        successTimeStamp
      ];
}