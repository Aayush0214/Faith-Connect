part of 'leader_dashboard_bloc.dart';

sealed class LeaderDashboardEvent extends Equatable {
  const LeaderDashboardEvent();

  @override
  List<Object> get props => [];
}

class FetchLeaderDashboardData extends LeaderDashboardEvent {
  final String leaderId;
  const FetchLeaderDashboardData({required this.leaderId});

  @override
  List<Object> get props => [leaderId];
}

class FetchMoreLeaderPosts extends LeaderDashboardEvent {
  final String leaderId;
  final String type;
  const FetchMoreLeaderPosts({required this.leaderId, required this.type});

  @override
  List<Object> get props => [leaderId, type];
}

class DeleteLeaderPostEvent extends LeaderDashboardEvent{
  final String postId;
  final String type;
  const DeleteLeaderPostEvent({required this.postId, required this.type});

  @override
  List<Object> get props => [postId];
}

class ToggleLikeEvent extends LeaderDashboardEvent {
  final String postId;
  const ToggleLikeEvent({required this.postId});

  @override
  List<Object> get props => [postId];
}

class ToggleSavePostEvent extends LeaderDashboardEvent {
  final String postId;
  const ToggleSavePostEvent({required this.postId});

  @override
  List<Object> get props => [postId];
}

class FollowUnfollowLeaderEvent extends LeaderDashboardEvent {
  final String leaderId;

  const FollowUnfollowLeaderEvent({required this.leaderId});

  @override
  List<Object> get props => [leaderId];
}

class FetchLeaderFollowers extends LeaderDashboardEvent {
  final String leaderId;
  const FetchLeaderFollowers({required this.leaderId});

  @override
  List<Object> get props => [leaderId];
}

class _OnSocialUpdateEvent extends LeaderDashboardEvent {
  final Map<String, dynamic> update;
  const _OnSocialUpdateEvent({required this.update});
}