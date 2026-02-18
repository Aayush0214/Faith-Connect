part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchExplorePosts extends HomeEvent {}

class FetchFollowingPosts extends HomeEvent {}

class FetchMoreHomePosts extends HomeEvent {
  final bool isExplore;

  const FetchMoreHomePosts({required this.isExplore});

  @override
  List<Object?> get props => [isExplore];
}

class ToggleLikeEvent extends HomeEvent {
  final String postId;
  const ToggleLikeEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class ToggleSavePostEvent extends HomeEvent {
  final String postId;
  const ToggleSavePostEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class _OnSocialUpdateEvent extends HomeEvent {
  final Map<String, dynamic> update;
  const _OnSocialUpdateEvent({required this.update});
}