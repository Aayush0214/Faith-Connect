part of 'reels_bloc.dart';

sealed class ReelsEvent extends Equatable {
  const ReelsEvent();

  @override
  List<Object> get props => [];
}

class FetchReelsEvent extends ReelsEvent {}

class FetchMoreReels extends ReelsEvent {}

class ToggleLikeReel extends ReelsEvent {
  final String reelId;
  const ToggleLikeReel({required this.reelId});

  @override
  List<Object> get props => [reelId];
}

class ToggleSaveReel extends ReelsEvent {
  final String reelId;
  const ToggleSaveReel({required this.reelId});

  @override
  List<Object> get props => [reelId];
}

class _OnSocialUpdateEvent extends ReelsEvent {
  final Map<String, dynamic> update;
  const _OnSocialUpdateEvent({required this.update});
}
